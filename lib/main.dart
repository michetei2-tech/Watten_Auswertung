import 'package:flutter/material.dart';
import 'pages/start_page.dart';

void main() {
  runApp(const WattenApp());
}

class WattenApp extends StatelessWidget {
  const WattenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watten Auswertung',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const StartPage(),
    );
  }
}
