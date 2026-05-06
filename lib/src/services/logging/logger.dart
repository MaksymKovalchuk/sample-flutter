import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart' as logging;

final Logger logger = LoggerLogging();

typedef LogFormatter = String Function(LogMessage message, LogOptions options);

enum LoggerLevel implements Comparable<LoggerLevel> {
  error._(1000),
  warning._(800),
  info._(600),
  debug._(400),
  verbose._(200);

  const LoggerLevel._(this.value);

  final int value;

  @override
  int compareTo(LoggerLevel other) => value.compareTo(other.value);

  @override
  String toString() => '$LoggerLevel($value)';
}

base class LogOptions {
  const LogOptions({
    this.showTime = true,
    this.showEmoji = true,
    this.logInRelease = false,
    this.level = LoggerLevel.info,
    this.formatter,
  });

  final LoggerLevel level;
  final bool showTime;
  final bool showEmoji;
  final bool logInRelease;
  final LogFormatter? formatter;
}

base class LogMessage {
  const LogMessage({
    required this.message,
    required this.logLevel,
    this.error,
    this.stackTrace,
    this.time,
  });

  final Object message;
  final Object? error;
  final StackTrace? stackTrace;
  final DateTime? time;
  final LoggerLevel logLevel;
}

abstract base class Logger {
  void error(Object message, {Object? error, StackTrace? stackTrace});
  void warning(Object message);
  void info(Object message);
  void debug(Object message);
  void verbose(Object message);

  L runLogging<L>(L Function() fn, [LogOptions options = const LogOptions()]);

  Stream<LogMessage> get logs;

  void logZoneError(Object error, StackTrace stackTrace) {
    if (error is PlatformException && error.code == 'recreating_view') {
      logger.warning("Caught recreating_view PlatformException");
      return;
    }

    this.error('Zone error: $error', error: error, stackTrace: stackTrace);
  }

  void logFlutterError(FlutterErrorDetails details) {
    if (details.silent) {
      return;
    }

    final description = details.exceptionAsString();

    error(
      'Flutter Error: $description',
      error: details.exception,
      stackTrace: details.stack,
    );
  }

  bool logPlatformDispatcherError(Object error, StackTrace stackTrace) {
    this.error(
      'Platform Dispatcher Error: $error',
      error: error,
      stackTrace: stackTrace,
    );
    return true;
  }
}

final class LoggerLogging extends Logger {
  final _logger = logging.Logger('SizzleLogger');

  @override
  void debug(Object message) => _logger.fine(message);

  @override
  void error(Object message, {Object? error, StackTrace? stackTrace}) =>
      _logger.severe(message, error, stackTrace);

  @override
  void info(Object message) => _logger.info(message);

  @override
  void verbose(Object message) => _logger.finest(message);

  @override
  void warning(Object message) => _logger.warning(message);

  @override
  Stream<LogMessage> get logs =>
      _logger.onRecord.map((record) => record.toLogMessage());

  @override
  L runLogging<L>(L Function() fn, [LogOptions options = const LogOptions()]) {
    if (kReleaseMode && !options.logInRelease) {
      return fn();
    }
    logging.hierarchicalLoggingEnabled = true;

    _logger.onRecord
        .where((event) => event.loggerName == 'SizzleLogger')
        .listen((event) {
          final logMessage = event.toLogMessage();
          final message =
              options.formatter?.call(logMessage, options) ??
              _formatLoggerMessage(log: logMessage, options: options);

          if (logMessage.logLevel.compareTo(options.level) < 0) {
            return;
          }

          Zone.current.print(message);
        });

    return fn();
  }
}

String _formatLoggerMessage({
  required LogMessage log,
  required LogOptions options,
}) {
  final buffer = StringBuffer();
  if (options.showEmoji) {
    buffer.write(log.logLevel.emoji);
    buffer.write(' ');
  }
  if (options.showTime) {
    buffer.write(log.time?.formatTime());
    buffer.write(' | ');
  }
  buffer.write(log.message);
  if (log.error != null) {
    buffer.writeln();
    buffer.write(log.error);
  }
  if (log.stackTrace != null) {
    buffer.writeln();
    buffer.write(log.stackTrace);
  }

  return buffer.toString();
}

extension on DateTime {
  String formatTime() =>
      [hour, minute, second].map((i) => i.toString().padLeft(2, '0')).join(':');
}

extension on logging.LogRecord {
  LogMessage toLogMessage() => LogMessage(
    message: message,
    error: error,
    stackTrace: stackTrace,
    time: time,
    logLevel: level.toLoggerLevel(),
  );
}

extension on logging.Level {
  LoggerLevel toLoggerLevel() => switch (this) {
    logging.Level.SEVERE => LoggerLevel.error,
    logging.Level.WARNING => LoggerLevel.warning,
    logging.Level.INFO => LoggerLevel.info,
    logging.Level.FINE || logging.Level.FINER => LoggerLevel.debug,
    _ => LoggerLevel.verbose,
  };
}

extension on LoggerLevel {
  String get emoji => switch (this) {
    LoggerLevel.error => '🔥',
    LoggerLevel.warning => '⚠️',
    LoggerLevel.info => '💡',
    LoggerLevel.debug => '🐛',
    LoggerLevel.verbose => '🔬',
  };
}
