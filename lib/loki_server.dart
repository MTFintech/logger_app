import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'logger_app.dart';
import 'logs_storage.dart';


class LokiServer extends LogOutput{

  final String lokiUrl;
  final Map<String, String> labels;
  late String _logsMessage;
  LokiServer(this.lokiUrl, this.labels);
  var logsStorage = getItLogger<LogsStorage>();

  final logger = Logger();

@override
  void output(OutputEvent event) {
    final logMessage = event.lines.join('\n');
    _sendLogToLoki(logMessage);
  }

void _sendLogToLoki(String logMessage) async {
  final url = lokiUrl;
  final headers = {'Content-Type': 'application/json'};
  _logsMessage = logMessage;

  final body = jsonEncode({
    'streams': [
      {
        'stream': {'app': 'test_loki_2.0'},
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