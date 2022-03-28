import 'package:clipboard/clipboard.dart';
import 'package:exptech_service/api/Data.dart' as globals;
import 'package:exptech_service/api/NetWork.dart';
import 'package:exptech_service/page/system/LogPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

int start = 0;

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  _MinePage createState() => _MinePage();
}

class _MinePage extends State<MinePage> {
  String APIKey = "加載中...";
  String button = "註冊 API 服務";
  Color Button = Colors.blue;

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
            '{"Function":"home","Type":"key","UID":"${LocalData.get("UID")}","Token":"${globals.Token}"}');
        if (data["response"] == "Not Found") {
          APIKey = "未註冊 API 服務";
        } else {
          button = "重置 API 服務";
          Button = Colors.grey;
          APIKey = data["response"];
        }
        setState(() {});
      }
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "UID: " + LocalData.get("UID").toString(),
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "應用程式",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            "版本: " + globals.ver,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                "API Key",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                " (↧ 點擊複製)",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (APIKey != "未註冊 API 服務") {
                                await FlutterClipboard.copy(
                                    APIKey);
                              }
                            },
                            child: Text(
                              APIKey,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Button),
                                    ),
                                    onPressed: () async {
                                      await NetWork(
                                          '{"Function":"home","Type":"keySet","UID":"${LocalData.get("UID")}","Token":"${globals.Token}"}');
                                      start = 0;
                                      setState(() {});
                                    },
                                    child: Text(button),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed: () async {
                        await launch(
                            'https://github.com/ExpTechTW/ExpTech_Service');
                      },
                      child: const Text("GitHub"),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LogPage(),
                              maintainState: false,
                            ));
                      },
                      child: const Text("日誌"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
