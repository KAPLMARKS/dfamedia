import 'package:dfamedia/app.dart';
import 'package:dfamedia/core/services/database_service.dart';
import 'package:dfamedia/features/home/data/repository.dart';
import 'package:dfamedia/features/home/data/services/dfamedia.dart';
import 'package:dfamedia/features/home/data/services/local_service.dart';
import 'package:dfamedia/features/home/presentation/wm.dart';
import 'package:dfamedia/features/chat/presentation/chat_wm.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация сервисов
  final databaseService = DatabaseService();
  final onlineService = DfaMediaService();
  final localService = LocalService(databaseService);
  final repository = DfaMediaRepository(onlineService, localService);
  
  // Создание провайдеров
  final homeWM = HomeWM(repository);
  final chatProvider = ChatWM();
  
  // Создание и запуск приложения
  final app = App(
    homeWM: homeWM,
    chatProvider: chatProvider,
  );
  
  await app.run();
}
