import 'package:exptech_service/api/Data.dart' as globals;
import 'package:exptech_service/page/system/Initialization.dart';
import 'package:exptech_service/page/user/NotSupportPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loggy/flutter_loggy.dart';
import 'package:loggy/loggy.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_io/io.dart';

import 'api/Get.dart';

main() async {
  globals.StaticDatabase = await Get(
          "https://raw.githubusercontent.com/ExpTechTW/API/%E4%B8%BB%E8%A6%81%E7%9A%84-(main)/StaticDatabase/Index.json")
      as Map<String, dynamic>;
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  globals.ver = packageInfo.version;
  Loggy.initLoggy(
    logPrinter: StreamPrinter(
      const PrettyDeveloperPrinter(),
    ),
    logOptions: const LogOptions(
      LogLevel.all,
      stackTraceLevel: LogLevel.error,
    ),
  );
  // if (!kIsWeb) {
  //   logInfo('Firebase Initialize');
  //   await Firebase.initializeApp();
  //   await FirebaseMessaging.instance.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //   globals.FirebaseToken = await FirebaseMessaging.instance.getToken();
  //   logInfo('FirebaseToken: ' + globals.FirebaseToken.toString());
  // }
  logInfo('Starting App');
  runApp(const ExpTechService());
}

class ExpTechService extends StatelessWidget {
  const ExpTechService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool stop = (kIsWeb && (Platform.isAndroid || Platform.isIOS));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (!stop) ? const InitializationPage() : const NotSupportPage(),
    );
  }
}
