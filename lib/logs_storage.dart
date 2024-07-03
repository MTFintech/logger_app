import 'package:shared_preferences/shared_preferences.dart';

import 'controller_logs.dart';

class LogsStorage {
  late SharedPreferences prefs;
  late ControllerLogs logsController;

  logsStorageConfig() async {
    logsController = ControllerLogs();
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('logs_loki')) {
      logsController.resendLogs(readShared());
      return;
    }
    prefs.setStringList('logs_loki', ['Date', DateTime.now().toString()]);
  }

  bool initPrefs(){
    if (!prefs.containsKey('logs_loki')) {
      prefs.setStringList('logs_loki', ['Date', DateTime.now().toString()]);
      return true;
    }
    return false;

  }

  updatePrefs(String logs) {
    initPrefs();
    var listPrefs = readShared();
    listPrefs.add(logs);
    prefs.setStringList('logs_loki', listPrefs);
  }

  verifyAndClear(){
    if(prefs.containsKey('logs_loki') && readShared().length > 2){
      logsController.resendLogs(readShared());
      cleanPrefs();
      return;
    }
  }

  cleanPrefs() => prefs.clear();

  List<String> readShared() {
    return prefs.getStringList('logs_loki') as List<String>;
  }
}
