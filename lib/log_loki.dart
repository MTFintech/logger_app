import 'package:logger/logger.dart';
import 'logger_app.dart';
import 'loki_server.dart';

class LogLoki{

  var logger = Logger();

  LogLoki(){
    logger = Logger(
        printer: PrettyPrinter(
          colors: false,
          printTime: true
        ),
        output: LokiServer(
          lokiURL,
          {'app': 'test_loki'},
        )
    );
  }
}