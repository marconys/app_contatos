import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeContatosView extends StatefulWidget {
  const HomeContatosView({super.key});

  @override
  State<HomeContatosView> createState() => _HomeContatosViewState();
}

class _HomeContatosViewState extends State<HomeContatosView> {
  var controllerName = TextEditingController(text: "");
  var controllerPhone = TextEditingController(text: "");
  String photoUrl = "UrlDefault";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Contatos'),
        centerTitle: true,
      ),
      body: ListView.builder(itemBuilder: (BuildContext bc, int index) {
        return ListTile(
          leading: (photoUrl != "UrlDefault")
              ? Image.asset("")
              : const Icon(Icons.person_3),
          title: const Text("Nome do contato"),
          subtitle: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Telefone"), Icon(Icons.phone)],
          ),
        );
      }),
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
                                          leading: const Icon(Icons.camera_enhance),
                                          title: const Text("Câmerea"),
                                          onTap: () {

                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.image_outlined),
                                          title: const Text("Galeria"),
                                          onTap: () {

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
                    TextButton(onPressed: () {}, child: const Text("Salvar")),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
