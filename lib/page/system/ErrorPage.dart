import 'package:exptech_service/api/Data.dart' as globals;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'LogPage.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic arg = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Lottie.network(globals.StaticDatabase["ErrorAnimation"] ??
                globals.NotFoundAnimation),
          ),
          Text(
            "Error 錯誤\n" + arg["type"],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LogPage(),
                            maintainState: false,
                          ));
                    },
                    child: const Text(
                      "前往日誌頁面",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
