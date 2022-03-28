import 'package:exptech_service/api/Data.dart' as globals;
import 'package:exptech_service/api/NetWork.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../api/Get.dart';

int start = 0;
String alert = "";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late List<Widget> _children = <Widget>[];

  @override
  void dispose() {
    start = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var LocalData = Hive.box('LocalData');
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (start == 0) {
        start = 1;
        var data = await NetWork(
            '{"Function":"home","Type":"keyCache","UID":"${LocalData.get("UID")}","Token":"${globals.Token}"}');
        if (data["response"] == null) {
          _children.add(
            const Text(
              "沒有 API 服務使用數據",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.normal,
              ),
            ),
          );
        } else {
          _children.add(
            Text(
              data["response"].toString(),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.normal,
              ),
            ),
          );
        }
        setState(() {});
      }
    });
    return Scaffold(
      body: RefreshIndicator(
        child: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: _children.toList(),
        ),
        onRefresh: () async {
          start = 0;
          _children = <Widget>[];
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 1000));
          while (true) {
            if (start == 1) {
              break;
            }
            await Future.delayed(const Duration(milliseconds: 100));
          }
          return;
        },
      ),
    );
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
            child: const Text('知道了'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
