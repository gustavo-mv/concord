import 'package:flutter/material.dart';
import 'package:concord/utils/constants.dart';
import 'package:concord/views/setup/setup_page.dart';

void main() {
  runApp(const QuickChatApp());
}

class QuickChatApp extends StatelessWidget {
  const QuickChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const SetupPage());
  }
}
