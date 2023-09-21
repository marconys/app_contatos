import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Define os cabeçalhos "X-Parse-Application-Id" e "X-Parse-REST-API-Key"
    // com os valores obtidos de variáveis de ambiente usando dotenv.
    options.headers["X-Parse-Application-Id"] = dotenv.get("APLICATIONID");
    options.headers["X-Parse-REST-API-Key"] = dotenv.get("RESTAPIKEY");
    
    // Registra informações de depuração sobre a solicitação HTTP.
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    
    // Chama o método onRequest da classe pai para continuar o fluxo da solicitação.
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Registra informações de depuração sobre a resposta HTTP.
    debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    
    // Chama o método onResponse da classe pai para continuar o fluxo da resposta.
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // Registra informações de depuração sobre erros de solicitação HTTP.
    debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    
    // Chama o método onError da classe pai para continuar o fluxo do erro.
    super.onError(err, handler);
  }
}

