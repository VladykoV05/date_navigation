import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;

class AppLogger {
  static final _instance = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 3,
      colors: true,
      printEmojis: true,
    ),
    level: kReleaseMode ? Level.info : Level.debug,
  );

  static Logger get instance => _instance;

  static void d(String message) => instance.d(message);
  static void i(String message) => instance.i(message);
  static void w(String message) => instance.w(message);
  static void e(String message, [dynamic error, StackTrace? stackTrace]) =>
      instance.e(message, error: error, stackTrace: stackTrace);
}
