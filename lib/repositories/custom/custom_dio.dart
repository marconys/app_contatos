import 'package:contatos/repositories/custom/custom_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomDio {
  //Instancia um objeto privado do tipo DIO
  final _dio = Dio();

 //get dio permite que o objeto privado _dio possa ser acessado fora da classe CustomDio
  Dio get dio => _dio;

 //Conatrutor da classe
  CustomDio() {
    //Isso define o cabeçalho HTTP, todas as solicitações feitas com esta instância incluirão esse cabeçalho
    _dio.options.headers["content-type"] = "application/json";
    _dio.options.baseUrl = dotenv.get("BASEURL");
    _dio.interceptors.add(CustomInterceptors());
  }
}
