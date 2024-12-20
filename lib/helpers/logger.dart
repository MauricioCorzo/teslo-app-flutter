import 'package:logger/logger.dart';

class LoggerPrint {
  static final Logger _logger =
      Logger(printer: PrettyPrinter(), level: Level.debug);
  static void debug<T>(T message) => _logger.d(message);
  static void info<T>(T message) => _logger.i(message);
  static void warning<T>(T message) => _logger.w(message);
  static void error(String message, [dynamic error]) =>
      _logger.e(message, error: error, stackTrace: StackTrace.current);
}
