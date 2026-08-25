import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/game_hub_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Bloque l'application en mode portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
   
  ]);
  
  runApp(const GameHubApp());
}

class GameHubApp extends StatelessWidget {
  const GameHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KidiBrain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const GameHubScreen(),
    );
  }
}