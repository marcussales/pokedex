import 'package:flutter/material.dart';
import 'package:pokedex/pages/search_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pokedex',
      home: SearchPage(),
      initialRoute: '/',
    );
  }
}
