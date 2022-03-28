import 'package:exptech_service/api/Data.dart' as globals;
import 'package:exptech_service/api/NetWork.dart';
import 'package:exptech_service/page/user/ForgetPage.dart';
import 'package:exptech_service/page/user/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../Home.dart';
import 'TokenPage.dart';

String alert = "";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  GlobalKey _key = GlobalKey<FormState>();
  TextEditingController _user = TextEditingController();
  TextEditingController _pass = TextEditingController();
  FocusNode _u = FocusNode();
  FocusNode _p = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _user.dispose();
    _pass.dispose();
    _u.dispose();
    _p.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arg = ModalRoute.of(context)?.settings.arguments;
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (arg == "Register") {
        alert = "註冊 成功\n請使用 登入 功能";
        await showAlert(context);
      } else if (arg == "Forget") {
        alert = "密碼修改 成功\n請使用 登入 功能";
        await showAlert(context);
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: 300,
              child: Image.network(
                  globals.StaticDatabase["ExpTech"] ?? globals.NotFoundImage),
            ),
            Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    focusNode: _u,
                    controller: _user,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.supervised_user_circle_outlined),
                      labelText: "用戶名稱 or 電子郵件",
                      hintText: "請輸入 用戶名稱 or 電子郵件",
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "用戶名稱 or 電子郵件 不為空";
                      }
                    },
                    onFieldSubmitted: (v) {},
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    focusNode: _p,
                    controller: _pass,
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      labelText: "密碼",
                      hintText: "請輸入密碼",
                    ),
                    textInputAction: TextInputAction.done,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "密碼不為空";
                      }
                    },
                    onFieldSubmitted: (v) {},
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 36,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgetPage(),
                                ));
                          },
                          child: const Text("忘記密碼?"),
                        ),
                      ),
                    ],
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
                                    '{"Type":"login","user":"${_user.text}","pass":"${_pass.text}","DeviceID":"${globals.DeviceID}","Platform":"${globals.Platform}","DeviceINFO":"${globals.DeviceINFO}","FirebaseToken":"${globals.FirebaseToken}"}');
                                if (data["state"] == "Success") {
                                  var LocalData = Hive.box('LocalData');
                                  LocalData.put(
                                      "token", data["response"]["token"]);
                                  LocalData.put("UID", data["response"]["UID"]);
                                  globals.Token = data["response"]["Token"];
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Home(),
                                        maintainState: false,
                                      ));
                                } else {
                                  if (data["response"] ==
                                      "Password verification failed") {
                                    alert = "密碼 錯誤\n請嘗試使用 忘記密碼 功能";
                                    await showAlert(context);
                                  } else {
                                    alert = "未找到有效的 用戶數據\n請使用 註冊 功能";
                                    await showAlert(context);
                                  }
                                }
                              }
                            },
                            child: const Text("登入"),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ));
                          },
                          child: const Text("註冊帳號!"),
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
                                  builder: (context) => const TokenPage(),
                                ));
                          },
                          child: const Text("令牌登入!"),
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
