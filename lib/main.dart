import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:math' show Random;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();
  String encryptedText = '';
  String decryptedText = '';

  late final String my_key;
  late final encrypt.Encrypter encrypter;
  final iv = encrypt.IV.fromLength(16);

  @override
  void initState() {
    super.initState();
    my_key = generateRandomKey(32); // Generate a 256-bit (32 characters) key
    final keydata = encrypt.Key.fromUtf8(my_key);
    encrypter = encrypt.Encrypter(encrypt.AES(keydata));
  }

  String generateRandomKey(int length) {
    var random = Random.secure();
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrserefretuvwxyz';
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AES Encryption Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(labelText: 'Enter text to encrypt'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final encrypted = encrypter.encrypt(textEditingController.text, iv: iv);
                setState(() {
                  encryptedText = encrypted.base64;
                });
              },
              child: Text('Encrypt'),
            ),
            SizedBox(height: 20),
            Text('Encrypted Text: $encryptedText'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
                setState(() {
                  decryptedText = decrypted;
                });
              },
              child: Text('Decrypt'),
            ),
            SizedBox(height: 20),
            Text('Decrypted Text: $decryptedText'),
          ],
        ),
      ),
    );
  }
}
