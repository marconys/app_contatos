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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Contatos'),
        centerTitle: true,
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
                            onTap: () {},
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
