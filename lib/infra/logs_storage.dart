import 'package:shared_preferences/shared_preferences.dart';

import '../domain/logger_usecase.dart';

class LogsStorage {
  late SharedPreferences prefs;
  final LoggerApp logApp;
  final loggerKey = 'logs_loki';

  LogsStorage(this.logApp);

  logsStorageConfig() async {

    prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(loggerKey) &&  prefs.getStringList(loggerKey)!.length > 2) {
      logApp.resendLogs(readShared());
      return;
    }
    prefs.setStringList(loggerKey, ['Date', DateTime.now().toString()]);
  }

  bool initPrefs(){
    if (!prefs.containsKey(loggerKey)) {
      prefs.setStringList(loggerKey, ['Date', DateTime.now().toString()]);
      return true;
    }
    return false;

  }

  updatePrefs(String logs) {
    initPrefs();
    var listPrefs = readShared();
    listPrefs.add(logs);
    prefs.setStringList(loggerKey, listPrefs);
  }

  verifyAndClear(){
    if(prefs.containsKey(loggerKey) && readShared().length > 2){
      logApp.resendLogs(readShared());
      cleanPrefs();
      return;
    }
  }

  cleanPrefs() => prefs.clear();

  List<String> readShared() => prefs.getStringList(loggerKey) as List<String>;

}
