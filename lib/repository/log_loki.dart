import 'package:logger/logger.dart';
import 'package:logger_app/external/loki_server.dart';

class LogLoki extends LogOutput{
  final LokiServer lokiServer;

  var logger = Logger();

  LogLoki(this.lokiServer){

    logger = Logger(
        printer: PrettyPrinter(
          colors: false,
          printTime: true
        ),
        output: this
    );
  }

  @override
  void output(OutputEvent event) {
    final logMessage = event.lines.join('\n');
    lokiServer.sendLogToLoki(logMessage);
  }
}