import 'package:flutter/material.dart';

void main() {
  runApp(const E2EEChatApp());
}

class E2EEChatApp extends StatelessWidget {
  const E2EEChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E2EE Photography Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E2EE Chat'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.lock_outline, size: 64, color: Colors.deepPurple),
            SizedBox(height: 16),
            Text(
              'Bienvenido al Grupo de Fotografía',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Máxima privacidad (E2EE) activada.'),
          ],
        ),
      ),
    );
  }
}
