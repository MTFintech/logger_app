library logger_app;

import 'package:get_it/get_it.dart';
import 'package:logger_app/controller_logs.dart';
import 'package:logger_app/logs_repo.dart';
import 'log_loki.dart';
import 'logs_storage.dart';

final getItLogger = GetIt.asNewInstance();
String lokiURL = '';
var controllerLogs = ControllerLogs();

class LoggerApp{

  LoggerApp({
    required String userId,
    required String key
  }){
    lokiURL = 'https://$userId:$key@logs-prod-024.grafana.net/loki/api/v1/push';
    getItLogger.registerSingleton<LogsStorage>(LogsStorage());
    getItLogger.registerSingleton<LogLoki>(LogLoki());

    print(lokiURL);
  }

  configStore(){
    var logStore = getItLogger<LogsStorage>();
    logStore.logsStorageConfig();
  }

  logException() => controllerLogs.logException();

  logError({String log = 'Log error'})=> controllerLogs.logError(log);

  logInfo({String log = 'Log Info'})=> controllerLogs.logInfo(log);

  logWarning({String log = 'Log Warning'})=> controllerLogs.logWarning(log);

}
