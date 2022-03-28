import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';

Future Get(url) async {
  try {
    var response =
        await http.get(Uri.parse(url)).timeout(const Duration(seconds: 1));
    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = convert.jsonDecode(response.body);
      Log(LogLevel.debug, jsonResponse);
      return jsonResponse;
    } else {
      Log(LogLevel.error, "StaticDatabase Not Found");
      return jsonDecode('{"state":"Error","response":"404"}');
    }
  } catch (e) {
    return jsonDecode('{"state":"Error"}');
  }
}

class Log with NetworkLoggy {
  Log(level, msg) {
    switch (level) {
      case LogLevel.error:
        loggy.error(msg);
        break;
      case LogLevel.warning:
        loggy.warning(msg);
        break;
      case LogLevel.info:
        loggy.info(msg);
        break;
      case LogLevel.debug:
        loggy.debug(msg);
        break;
    }
  }
}
