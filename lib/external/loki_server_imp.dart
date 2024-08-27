import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:logger_app/external/loki_server.dart';

import '../domain/logger_usecase_imp.dart';
import '../infra/logs_storage.dart';


/// * Callback logger
class LokiServerImp implements LokiServer{

  final String lokiUrl;
  final Map<String, String> labels;
  late String _logsMessage;
  LokiServerImp(this.lokiUrl, this.labels);
  var logsStorage = getItLogger<LogsStorage>();

  final logger = Logger();

@override
  void sendLogToLoki(String logMessage) async {
  final url = lokiUrl;
  final headers = {'Content-Type': 'application/json'};
  _logsMessage = logMessage;

  final body = jsonEncode({
    'streams': [
      {
        'stream': {'app': 'Logger_app_mtbank'},
        'values': [
          [(DateTime.now().millisecondsSinceEpoch * 1000000).toString() , logMessage]
        ]}
    ]
  });


  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 204) {
      logsStorage.verifyAndClear();
      logger.i('Log enviado com sucesso!');
    } else {
      logsStorage.updatePrefs(_replaceLog(_logsMessage));
      logsStorage.updatePrefs('Status code: ${response.statusCode} - Body: ${response.body}');
      logger.i('Erro ao enviar log: ${response.statusCode}');
    }
  } catch (e) {
    logsStorage.updatePrefs(_replaceLog(_logsMessage));
    logsStorage.updatePrefs(e.toString());
    logger.i('Erro ao enviar log: $e');
  }
}

String _replaceLog(String log){
  return log.replaceAll("┌", "").replaceAll("─", "").replaceAll('│', '').replaceAll('├', '').replaceAll('┄', '').replaceAll('└', '').replaceAll('\n', '');
}
}