import 'package:exptech_service/api/Data.dart' as globals;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotSupportPage extends StatefulWidget {
  const NotSupportPage({Key? key}) : super(key: key);

  @override
  _NotSupportPage createState() => _NotSupportPage();
}

class _NotSupportPage extends State<NotSupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Lottie.network(
                globals.StaticDatabase["NotSupportAnimation"] ??
                    globals.NotFoundAnimation),
          ),
          const Text(
            "不支援行動裝置瀏覽器",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}
