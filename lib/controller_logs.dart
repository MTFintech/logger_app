import 'package:logger_app/logs_repo.dart';
import 'log_loki.dart';
import 'logger_app.dart';

class ControllerLogs implements LogsRepo{
  final loki = getItLogger<LogLoki>();


  @override
  logException(){
    try{
      throw Exception();
    }catch(e){
      loki.logger.wtf(e);
    }
  }

  @override
  logError(String log)=> loki.logger.e(log);


  @override
  logInfo(String log)=> loki.logger.i(log);


  @override
  logWarning(String log)=> loki.logger.w(log);


  @override
  sendLogs(String log)=> loki.logger.i(log);


  @override
  resendLogs(List<String> logs)=> loki.logger.v(logs);

}