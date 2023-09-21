import 'package:contatos/models/contatos_model.dart';
import 'package:contatos/repositories/custom/custom_dio.dart';

class ContatosRepository {
  final _customDio = CustomDio();

  ContatosRepository();

 //Busca todos os contatos
  Future<ContatosModel> getContatos() async {
    var result = await _customDio.dio.get("/contatos");

    return ContatosModel.fromJson(result.data);
  }

  //Busca um único contato com base no objectId
  Future<Contatos?> getContaoByObjectId(String objectId) async {
    try {
      final result = await _customDio.dio.get("/contatos/$objectId");
      return Contatos.fromJson(result.data);
    } catch (e) {
      throw Exception("Ocorreu um erro ao buscar o contato: $e");
    }
  }

  //Cria um novo contato
  Future<void> createContato(Contatos contato) async {
    try {
      await _customDio.dio.post("/contatos", data: contato.toJsonEndpoint());
    } catch (e) {
      throw Exception('Ocorreu um erro ao criar o contato: $e');
    }
  }

  //Atualiza o contato com base no objectId
  Future<void> updateContao(Contatos contato) async {
    try {
      await _customDio.dio
          .put("/contatos/${contato.objectId}", data: contato.toJsonEndpoint());
    } catch (e) {
      throw Exception("Erro ao atualizar contato: $e");
    }
  }

  //Exclui o contato com base no objectId
  Future<void> deleteContato(String objectId) async {
    try {
      await _customDio.dio.delete("/contatos/$objectId");
    } catch (e) {
      throw Exception("Erro ao excluir contato");
    }
  }
}
