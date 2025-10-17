import 'package:dfamedia/core/theme/app_theme.dart';
import 'package:dfamedia/features/home/presentation/wm.dart';
import 'package:dfamedia/features/home/presentation/home_screen.dart';
import 'package:dfamedia/features/chat/presentation/chat_wm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dfamedia/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.homeWM,
    required this.chatProvider,
  });

  final HomeWM homeWM;
  final ChatWM chatProvider;

  Future<void> run() async {
    // Инициализация Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    runApp(this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeWM>.value(value: homeWM),
        ChangeNotifierProvider<ChatWM>.value(value: chatProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
