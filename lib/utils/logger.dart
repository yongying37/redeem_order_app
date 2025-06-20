import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'common_enum.dart';

class Logger {
  static const String _consoleResetColor = '\x1B[0m';
  static const String _consoleErrorColor = '\x1B[31m';
  static const String _consoleSuccessColor = '\x1B[32m';
  static const String _consoleWarningColor = '\x1B[33m';
  static const String _consoleInfoColor = '\x1B[34m';
  static const String _consoleVerboseColor = '\x1B[36m';

  static List<String> _formatJsonForDisplay(String rawJsonString) {
    String formattedJson = '';
    try {
      final dynamic parsedJsonObject = jsonDecode(rawJsonString);
      formattedJson = const JsonEncoder.withIndent('  ').convert(parsedJsonObject);
    } catch (e) {
      formattedJson = rawJsonString;
    }

    // Split by newlines first to preserve the JSON structure
    List<String> jsonLines = formattedJson.split('\n');
    // A log chunk is a segment of a long log message that doesn't exceed the maximum size
    // We're breaking the JSON into log chunks to avoid exceeding console line limits
    List<String> outputLogChunks = [];
    String currentOutputLogChunk = '';

    // Maximum size for each log chunk output segment to ensure readable console display
    const int maxChunkSize = 500;

    for (String jsonLine in jsonLines) {
      // If adding this line would make the log chunk too long, start a new log chunk
      if (currentOutputLogChunk.length + jsonLine.length + 1 > maxChunkSize) {
        if (currentOutputLogChunk.isNotEmpty) {
          outputLogChunks.add(currentOutputLogChunk);
        }
        currentOutputLogChunk = jsonLine;
      } else {
        // Add to current log chunk with a newline if it's not empty
        if (currentOutputLogChunk.isNotEmpty) {
          currentOutputLogChunk += '\n$jsonLine';
        } else {
          currentOutputLogChunk = jsonLine;
        }
      }
    }

    // Add the last log chunk if it's not empty
    if (currentOutputLogChunk.isNotEmpty) {
      outputLogChunks.add(currentOutputLogChunk);
    }

    return outputLogChunks;
  }

  static Future<void> _log(String logLevelColor, String logLevel, String logMessage, {String? tag, String? jsonString, RequestType? requestType, ProjectType? projectType, StackTrace? stackTrace}) async {
    String logOutput = '';
    if (kDebugMode) {
      logOutput += '$logLevelColor[$logLevel] ';
    }
    if (tag != null) {
      logOutput += '[$tag] ';
    }
    logOutput += '[${DateFormat('d MMMM yyyy HH:mm:ss').format(DateTime.now())}] ';
    if (requestType != null) {
      logOutput += '[${requestType.toString().split('.').last.toUpperCase()}] ';
    }
    if (projectType != null) {
      logOutput += '[${projectType.toString().split('.').last.toUpperCase()}] ';
    }
    logOutput += logMessage;
    if (kDebugMode) {
      logOutput += _consoleResetColor;
    }
    print(logOutput);

    if (jsonString != null) {
      List<String> formattedJsonLogChunks = _formatJsonForDisplay(jsonString);
      for (var jsonLogChunk in formattedJsonLogChunks) {
        if (kDebugMode) {
          print('$logLevelColor$jsonLogChunk$_consoleResetColor');
        } else {
          print(jsonLogChunk);
        }
      }
    }

    if (stackTrace != null) {
      if (kDebugMode) {
        print('$logLevelColor$stackTrace$_consoleResetColor');
      } else {
        print(stackTrace);
      }
    }
  }

  static void v(String logMessage, {required String tag, String? jsonString, RequestType? requestType, ProjectType? projectType, StackTrace? stackTrace}) {
    _log(_consoleVerboseColor, 'VERBOSE', logMessage, tag: tag, jsonString: jsonString, requestType: requestType, projectType: projectType, stackTrace: stackTrace);
  }

  static void d(String logMessage, {required String tag, String? jsonString, RequestType? requestType, ProjectType? projectType, StackTrace? stackTrace}) {
    _log(_consoleInfoColor, 'DEBUG', logMessage, tag: tag, jsonString: jsonString, requestType: requestType, projectType: projectType, stackTrace: stackTrace);
  }

  static void i(String logMessage, {required String tag, String? jsonString, RequestType? requestType, ProjectType? projectType, StackTrace? stackTrace}) {
    _log(_consoleSuccessColor, 'INFO', logMessage, tag: tag, jsonString: jsonString, requestType: requestType, projectType: projectType, stackTrace: stackTrace);
  }

  static void w(String logMessage, {required String tag, String? jsonString, RequestType? requestType, ProjectType? projectType, StackTrace? stackTrace}) {
    _log(_consoleWarningColor, 'WARNING', logMessage, tag: tag, jsonString: jsonString, requestType: requestType, projectType: projectType, stackTrace: stackTrace);
  }

  static void e(String logMessage, {required String tag, String? jsonString, RequestType? requestType, ProjectType?
  projectType, StackTrace? stackTrace}) {
    _log(_consoleErrorColor, 'ERROR', logMessage, tag: tag, jsonString: jsonString, requestType: requestType, projectType: projectType, stackTrace: stackTrace);
  }
}