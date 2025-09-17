library logger_app;


import 'package:get_it/get_it.dart';
import 'package:logger_app/external/loki_server.dart';
import 'package:logger_app/external/loki_server_imp.dart';

import '../repository/log_loki.dart';
import '../infra/logs_storage.dart';
import 'cred_user.dart';
import 'logger_usecase.dart';


final getItLogger = GetIt.asNewInstance();
String lokiURL = '';
late LogLoki loki;
class LoggerAppImp implements LoggerApp{

  LoggerAppImp({
    required CredUser user
  }){
    lokiURL = 'https://${user.userId}:${user.key}@logs-prod-024.grafana.net/loki/api/v1/push';

    getItLogger.registerSingleton<LogsStorage>(LogsStorage(this));
    getItLogger.registerSingleton<LokiServer>(LokiServerImp(lokiURL, {'app': user.applicationName},));
    getItLogger.registerSingleton<LogLoki>(LogLoki(getItLogger<LokiServer>()));

    loki = getItLogger<LogLoki>();
    var logStore = getItLogger<LogsStorage>();
    logStore.logsStorageConfig();

    print(lokiURL);
  }

  @override
  configStore(){
    /*
    var logStore = getItLogger<LogsStorage>();
    logStore.logsStorageConfig();
    */
  }

  @override
  logException() => loki.logger.wtf('Exception');

  @override
  logError(String log)=> loki.logger.e(log);

  @override
  logInfo(String log)=> loki.logger.i(log);

  @override
  logWarning(String log)=>  loki.logger.w(log);

  @override
  sendLogs(String log)=> loki.logger.i(log);

  @override
  resendLogs(List<String> logs)=> loki.logger.v(logs);

}
