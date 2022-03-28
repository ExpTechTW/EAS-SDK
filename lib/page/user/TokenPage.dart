import 'package:exptech_service/api/Data.dart' as globals;
import 'package:exptech_service/api/NetWork.dart';
import 'package:exptech_service/page/user/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../Home.dart';

String alert = "";

class TokenPage extends StatefulWidget {
  const TokenPage({Key? key}) : super(key: key);

  @override
  _TokenPage createState() => _TokenPage();
}

class _TokenPage extends State<TokenPage> {
  GlobalKey _key = GlobalKey<FormState>();
  TextEditingController _token = TextEditingController();
  FocusNode _t = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _token.dispose();
    _t.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    focusNode: _t,
                    controller: _token,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.verified_user_outlined),
                      labelText: "令牌",
                      hintText: "請輸入 令牌",
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "令牌 不為空";
                      }
                    },
                    onFieldSubmitted: (v) {},
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            onPressed: () async {
                              if ((_key.currentState as FormState).validate()) {
                                var data = await NetWork(
                                    '{"Type":"Token","Token":"${_token.text}","DeviceID":"${globals.DeviceID}","Platform":"${globals.Platform}","DeviceINFO":"${globals.DeviceINFO}","FirebaseToken":"${globals.FirebaseToken}"}');
                                if (data["state"] == "Success") {
                                  var LocalData = Hive.box('LocalData');
                                  LocalData.put(
                                      "token", data["response"]["token"]);
                                  LocalData.put("UID", data["response"]["UID"]);
                                  globals.Token = _token.text;
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Home(),
                                        maintainState: false,
                                      ));
                                } else {
                                  alert = "令牌 錯誤";
                                  await showAlert(context);
                                }
                              }
                            },
                            child: const Text("令牌登入"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 36,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ));
                          },
                          child: const Text("返回登入!"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showAlert(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('通知!'),
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
