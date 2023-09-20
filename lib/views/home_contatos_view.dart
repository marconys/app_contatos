import 'package:flutter/material.dart';

class HomeContatosView extends StatefulWidget {
  const HomeContatosView({super.key});

  @override
  State<HomeContatosView> createState() => _HomeContatosViewState();
}

class _HomeContatosViewState extends State<HomeContatosView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Contatos'), centerTitle: true,),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add),),
    );
  }
}