import 'dart:html';
import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:contatos/models/contatos_model.dart';
import 'package:contatos/repositories/contatos_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String photoUrl = "UrlDefault";
  bool loading = false;

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
    //TODO: INICIAR AS VARIÁVEIS QUE FOREM CRIADAS PARA ATUALIZAÇÃO DOS CAMPOS
  }

  // Snacbar padrão.
  void showSnackBar(String menssage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(menssage),
      ),
    );
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
                    child: ListView.builder(
                        itemCount: _contatosModel.contatos?.length,
                        itemBuilder: (BuildContext bc, int index) {
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
                              leading: (photoUrl != "UrlDefault")
                                  //TODO: ALTERAR IMAGE.ASSET PARA FILE E IMPLEMENTAR FUNÇÃO PARA CONVERSÃO DO PATH
                                  ? Image.asset("")
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
                              onTap: () {
                                //TODO: IMPLEMETAR SHOWDIALOG PARA ATUALIZAÇÃO DO CONTATO
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
                                          leading:
                                              const Icon(Icons.camera_enhance),
                                          title: const Text("Câmerea"),
                                          onTap: () {
                                            //TODO: IMPLEMENTAR CAPTURA E ARMAZENAR IMAGEM DA CAMERA
                                          },
                                        ),
                                        ListTile(
                                          leading:
                                              const Icon(Icons.image_outlined),
                                          title: const Text("Galeria"),
                                          onTap: () {
                                            //TODO: IMPLEMENTAR CAPTURA DE IMAGE DA GALERIA
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: const Column(
                              children: [
                                Icon(Icons.person_add),
                                Text("Foto"),
                              ],
                            ),
                          ),
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
                        onPressed: () {
                          //TODO: IMPLEMENTAR A CRIAÇAO DE UM NOVO CONTATO.
                        },
                        child: const Text("Salvar")),
                  ],
                );
              });
        },
        //TODO: IMPLEMENTAR WIDGET PARA EXIBIR IMAGEM SELECIONADA E CONDIÇÃO PARA EXIBIÇÃO DA IMAGEM OU DO ICONE
        child: const Icon(Icons.add),
      ),
    );
  }
}
