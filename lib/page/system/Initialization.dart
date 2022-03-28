import 'package:device_info_plus/device_info_plus.dart';
import 'package:exptech_service/api/Data.dart' as globals;
import 'package:exptech_service/api/NetWork.dart';
import 'package:exptech_service/page/Home.dart';
import 'package:exptech_service/page/system/ErrorPage.dart';
import 'package:exptech_service/page/user/LoginPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loggy/loggy.dart';
import 'package:lottie/lottie.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:universal_io/io.dart';

int start = 0;
int click = 0;
String alert = "";

class InitializationPage extends StatefulWidget {
  const InitializationPage({Key? key}) : super(key: key);

  @override
  _InitializationPage createState() => _InitializationPage();
}

class _InitializationPage extends State<InitializationPage> {
  double _schedule = 0;
  String _load = "初始化...";

  @override
  void dispose() {
    start = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (start == 0) {
        start = 1;
        logInfo("加載本地資料庫...");
        _schedule = 0.1;
        _load = "加載本地資料庫...";
        setState(() {});
        await Hive.initFlutter();
        await Hive.openBox('LocalData');
        logInfo("獲取平台訊息...");
        _schedule = 0.2;
        _load = "獲取平台訊息...";
        setState(() {});
        globals.DeviceID = await PlatformDeviceId.getDeviceId;
        if (!kIsWeb) {
          if (Platform.isAndroid) {
            globals.Platform = "Android";
            DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
            AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
            globals.DeviceINFO = androidInfo.model!;
          } else if (Platform.isIOS) {
            globals.Platform = "iOS";
            DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
            IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
            globals.DeviceINFO = iosInfo.utsname.machine!;
          } else {
            globals.Platform = "UnKnow";
          }
        } else {
          globals.Platform = "Web";
        }
        _schedule = 0.4;
        logInfo("連線到 API 服務器...");
        _load = "連線到 API 服務器...";
        setState(() {});
        var data = await NetWork('{}');
        if (data["service"]["state"] == "Unstable" ||
            data["service"]["state"] == "Busy") {
          logWarning('API server state: ' + data["service"]["state"]);
          if (data["service"]["state"] == "Busy") {
            alert = "當前 API 服務器 [繁忙]\n可能導致延遲較高";
          } else {
            alert = "當前 API 服務器 [不穩定]\n可能出現服務異常";
          }
          await showAlert(context);
        } else if (data["service"]["state"] == "Error") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ErrorPage(),
                maintainState: false,
                settings: const RouteSettings(
                  arguments: {"type": "無法連線至 API 服務器"},
                ),
              ));
          return;
        }
        _schedule = 0.6;
        _load = "獲取登入令牌...";
        setState(() {});
        var LocalData = Hive.box('LocalData');
        logInfo('獲取登入令牌...');
        if (LocalData.get("token") == null) {
          logWarning('沒有發現登入令牌');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
                maintainState: false,
              ));
        } else {
          _schedule = 0.8;
          _load = "正在校對登入令牌...";
          logInfo('正在校對登入令牌...');
          setState(() {});
          logInfo('登入令牌 => ' + LocalData.get("token"));
          var data = await NetWork(
              '{"Type":"token","Token":"${LocalData.get("token")}","DeviceID":"${globals.DeviceID}"}');
          if (data["state"] == "Success") {
            globals.Token = data["response"]["Token"];
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                  maintainState: false,
                ));
          } else {
            alert = "登入令牌 已失效\n請嘗試 重新登入";
            await showAlert(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                  maintainState: false,
                ));
          }
        }
      }
    });
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Lottie.network(globals.StaticDatabase["LoadAnimation"] ??
              globals.NotFoundAnimation),
        ),
        Text(_load, style: const TextStyle(fontSize: 25)),
        Padding(
            padding: const EdgeInsets.all(10),
            child: LinearProgressIndicator(
              minHeight: 5,
              value: _schedule,
              color: Colors.lightBlue,
              backgroundColor: Colors.blueGrey,
            )),
      ],
    ));
  }
}

Future<bool?> showAlert(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('警告!'),
        content: Text(alert),
        actions: <Widget>[
          TextButton(
            child: const Text('退出'),
            onPressed: () {
              exit(0);
            },
          ),
          TextButton(
            child: const Text('繼續'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
