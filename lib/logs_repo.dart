abstract class LogsRepo {
  logException();
  logError(String log);
  logInfo(String log);
  logWarning(String log);
  sendLogs(String log);
  resendLogs(List<String> logs);
}