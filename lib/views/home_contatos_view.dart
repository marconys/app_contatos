import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:contatos/models/contatos_model.dart';
import 'package:contatos/repositories/contatos_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';

class HomeContatosView extends StatefulWidget {
  const HomeContatosView({super.key});

  @override
  State<HomeContatosView> createState() => _HomeContatosViewState();
}

class _HomeContatosViewState extends State<HomeContatosView> {
  ContatosRepository contatosRepository = ContatosRepository();
  var _contatosModel = ContatosModel([]);
  var controllerName = TextEditingController(text: "");
  var controllerPhone = TextEditingController(text: "");
  var controllerUpName = TextEditingController(text: "");
  var controllerUpPhone = TextEditingController(text: "");
  String? objectId;
  String? pathPhotoContato;
  XFile? photoUrl;
  bool loading = false;
  BuildContext? alertDialogContext;

  //busca todos os contatos e atribui a lista a variavel _contatosModel
  getContatos() async {
    setState(() {
      loading = true;
    });

    _contatosModel = await contatosRepository.getContatos();

    setState(() {
      loading = false;
    });
  }

  //Buca contato a partir do objectId;
  getContatoByObjectId(String id) async {
    var contato = await contatosRepository.getContaoByObjectId(id);
    objectId = id;
    controllerUpName.text = contato!.name;
    controllerUpPhone.text = contato.phone;
    pathPhotoContato = contato.photoURL;
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(alertDialogContext!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    getContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Contatos'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loading
                ? const CircularProgressIndicator()
                : Expanded(
                    //Lista todos os contados
                    child: ListView.builder(
                        itemCount: _contatosModel.contatos?.length,
                        itemBuilder: (BuildContext bc, int index) {
                          alertDialogContext = bc;
                          var contato = _contatosModel.contatos?[index];

                          return Dismissible(
                            key: Key(contato!.objectId),
                            onDismissed:
                                (DismissDirection dismissDirection) async {
                              await contatosRepository
                                  .deleteContato(contato.objectId);

                              getContatos();
                              showSnackBar("Contato excluído com sucesso");
                            },
                            child: ListTile(
                              //verifica antes se o path da foto foi salva, caso não tenha sido salvo ele terá o valor "sem foro" então ele exibirá um icon em vez da foto.
                              leading: (contato.photoURL != "sem foto")
                                  ? Image.file(
                                      File(contato.photoURL),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.person_3),
                              title: Text(contato.name),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(contato.phone),
                                  const Icon(Icons.phone)
                                ],
                              ),
                              //Atualizar contato
                              onTap: () {
                                getContatoByObjectId(contato.objectId);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext bc) {
                                      alertDialogContext = bc;
                                      return AlertDialog(
                                        title: const Text("Novo Contato"),
                                        content: Wrap(
                                          children: [
                                            TextField(
                                              controller: controllerUpName,
                                              decoration: const InputDecoration(
                                                  labelText: 'Nome',
                                                  hintText: 'Nome do Contato'),
                                            ),
                                            TextField(
                                              controller: controllerUpPhone,
                                              decoration: const InputDecoration(
                                                  labelText: 'Telefone',
                                                  hintText:
                                                      'Telefone do Contato'),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                TelefoneInputFormatter(),
                                              ],
                                            ),
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) {
                                                            return Wrap(
                                                              children: [
                                                                ListTile(
                                                                  leading:
                                                                      const Icon(
                                                                          Icons
                                                                              .camera_enhance),
                                                                  title: const Text(
                                                                      "Câmerea"),
                                                                  onTap:
                                                                      () async {
                                                                    await captureAndSaveImage();
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                ListTile(
                                                                  leading:
                                                                      const Icon(
                                                                          Icons
                                                                              .image_outlined),
                                                                  title: const Text(
                                                                      "Galeria"),
                                                                  onTap:
                                                                      () async {
                                                                    await getImageGallery();
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    child: const Icon(
                                                      Icons.image_search_sharp,
                                                      size: 50,
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancelar")),
                                          TextButton(
                                              //Cria um novo Contato
                                              onPressed: () async {
                                                if (controllerUpName
                                                        .text.isNotEmpty &&
                                                    controllerUpPhone
                                                        .text.isNotEmpty) {
                                                  if (photoUrl?.path != null) {
                                                    String updatedPhotoPath =
                                                        photoUrl!.path;
                                                    await contatosRepository
                                                        .updateContato(
                                                            Contatos.update(
                                                                objectId
                                                                    .toString(),
                                                                controllerUpName
                                                                    .text,
                                                                controllerUpPhone
                                                                    .text,
                                                                updatedPhotoPath));
                                                    photoUrl = null;

                                                    Navigator.pop(context);
                                                    showSnackBar(
                                                        "Contato atualizado com sucesso");

                                                    getContatos();
                                                  } else {
                                                    await contatosRepository
                                                        .updateContatoNoPhoto(
                                                            Contatos
                                                                .updateNoPhoto(
                                                      objectId.toString(),
                                                      controllerUpName.text,
                                                      controllerUpPhone.text,
                                                    ));
                                                    Navigator.pop(context);
                                                    showSnackBar(
                                                        "Contato atualizado com sucesso");
                                                        getContatos();
                                                  }
                                                } else {
                                                  Navigator.pop(context);
                                                  showSnackBar(
                                                      "todos os campos são obrigatórios");
                                                }
                                              },
                                              child: const Text("Salvar")),
                                        ],
                                      );
                                    });
                              },
                            ),
                          );
                        }),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext bc) {
                alertDialogContext = bc;
                return AlertDialog(
                  title: const Text("Novo Contato"),
                  content: Wrap(
                    children: [
                      TextField(
                        controller: controllerName,
                        decoration: const InputDecoration(
                            labelText: 'Nome', hintText: 'Nome do Contato'),
                      ),
                      TextField(
                        controller: controllerPhone,
                        decoration: const InputDecoration(
                            labelText: 'Telefone',
                            hintText: 'Telefone do Contato'),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter(),
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Wrap(
                                        children: [
                                          ListTile(
                                            leading: const Icon(
                                                Icons.camera_enhance),
                                            title: const Text("Câmerea"),
                                            onTap: () async {
                                              await captureAndSaveImage();
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                                Icons.image_outlined),
                                            title: const Text("Galeria"),
                                            onTap: () async {
                                              await getImageGallery();
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: const Icon(
                                Icons.image_search_sharp,
                                size: 50,
                              )),
                        ),
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar")),
                    TextButton(
                        //Cria um novo Contato
                        onPressed: () async {
                          if (controllerName.text.isNotEmpty &&
                              controllerName.text.isNotEmpty) {
                            //Usa o  "sem foto" caso photoUrl seja null
                            String photoUpload = photoUrl?.path ?? "sem foto";
                            await contatosRepository.createContato(
                                Contatos.create(controllerName.text,
                                    controllerPhone.text, photoUpload));
                            controllerName.clear();
                            controllerPhone.clear();
                            photoUrl = null;

                            Navigator.pop(context);
                            showSnackBar("Contato criado com sucesso");

                            getContatos();
                          } else {
                            Navigator.pop(context);
                            showSnackBar("Erro ao criar contato");
                          }
                        },
                        child: const Text("Salvar")),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> captureAndSaveImage() async {
    final ImagePicker imagePicker = ImagePicker();
    // Captura uma imagem da câmera
    photoUrl = await imagePicker.pickImage(source: ImageSource.camera);

    if (photoUrl != null) {
      // Obtém o diretório de documentos do aplicativo
      String path =
          (await path_provider.getApplicationDocumentsDirectory()).path;
      // Obtém o nome do arquivo da imagem capturada
      final String imageName = basename(photoUrl!.path);
      // Move a imagem capturada para o diretório de documentos do aplicativo
      final String imagePath = "$path/$imageName";
      await photoUrl!.saveTo(imagePath);

      // Salva a imagem na galeria
      await GallerySaver.saveImage(imagePath);

      // Chama o método para cortar a imagem (se necessário)
      cropImage(photoUrl!);
    }
  }

  Future<void> getImageGallery() async {
    final ImagePicker imagePicker = ImagePicker();
    // Captura uma imagem da galeria
    photoUrl = await imagePicker.pickImage(source: ImageSource.gallery);

    // Chama o método para cortar a imagem
    cropImage(photoUrl!);
  }

  Future<void> cropImage(XFile imageFile) async {
    // Utiliza o ImageCropper para cortar a imagem
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path, // Caminho da imagem original
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.purple, // Cor da barra de ferramentas
            toolbarWidgetColor:
                Colors.white, // Cor dos ícones da barra de ferramentas
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false), // Permite alterar a proporção
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    // Verifica se o corte foi realizado com sucesso
    if (croppedFile != null) {
      // Salva a imagem cortada na galeria
      await GallerySaver.saveImage(croppedFile.path);

      // Atualiza a variável photoUrl com o caminho da imagem cortada
      photoUrl = XFile(croppedFile.path);

      // Atualiza a interface do usuário para refletir a imagem cortada
      setState(() {});
    }
  }
}
