import 'package:flutter/material.dart';
import 'package:concord/service/socket_service.dart';
import 'package:concord/utils/constants.dart';
import 'package:concord/views/chat/chat_page.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var name = '';

    proceed() {
      if (name.length < 3) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Por favor, insira pelo menos 3 caracteres!')));
      } else {
        SocketService.setUserName(name);
        SocketService.connectAndListen();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ChatPage(),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text(appName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: size.width * 0.6,
              child: TextField(
                textAlign: TextAlign.center,
                autofocus: true,
                onChanged: (s) {
                  name = s;
                },
                onSubmitted: (s) => proceed(),
                decoration: const InputDecoration(
                    hintText: 'Digite seu nome',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: () => proceed(), child: const Text('Continuar')),
            SizedBox(height: size.height * 0.3),
          ],
        ),
      ),
    );
  }
}
