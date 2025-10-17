import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dfamedia/features/chat/domain/entities/chat_message.dart';
import 'package:dfamedia/features/chat/data/services/websocket_service.dart';

class ChatWM extends ChangeNotifier {
  final WebSocketService _webSocketService = WebSocketService();
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final List<bool> _messageSources = []; // true = от пользователя, false = от сервера
  bool _isConnected = false;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<String>? _messageSubscription;
  StreamSubscription<bool>? _connectionSubscription;

  // Getters
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  List<bool> get messageSources => List.unmodifiable(_messageSources);
  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  TextEditingController get messageController => _messageController;

  ChatWM() {
    _initializeSubscriptions();
  }

  void _initializeSubscriptions() {
    // Подписываемся на сообщения от WebSocket
    _messageSubscription = _webSocketService.messageStream.listen(
      (message) {
        _addMessage(
          ChatMessage(
            text: message,
            timestamp: DateTime.now(),
          ),
          isFromUser: false, // сообщение от сервера
        );
      },
      onError: (error) {
        _setError('Ошибка получения сообщения: $error');
      },
    );

    // Подписываемся на изменения состояния подключения
    _connectionSubscription = _webSocketService.connectionStream.listen(
      (connected) {
        _isConnected = connected;
        if (connected) {
          _clearError();
        }
        notifyListeners();
      },
    );
  }

  Future<void> connect() async {
    if (_isConnected || _isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      await _webSocketService.connect();
    } catch (e) {
      _setError('Ошибка подключения: $e');
    } finally {
      _setLoading(false);
    }
  }

  void disconnect() {
    _webSocketService.disconnect();
  }

  void sendCurrentMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || !_isConnected) return;

    // Создаем сообщение от пользователя
    final userMessage = ChatMessage(
      text: text,
      timestamp: DateTime.now(),
    );

    // Добавляем сообщение в список
    _addMessage(userMessage, isFromUser: true);

    // Отправляем через WebSocket
    _webSocketService.sendMessage(text);

    // Очищаем поле ввода
    _messageController.clear();
  }

  void _addMessage(ChatMessage message, {required bool isFromUser}) {
    _messages.add(message);
    _messageSources.add(isFromUser);
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  void clearMessages() {
    _messages.clear();
    _messageSources.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _connectionSubscription?.cancel();
    _webSocketService.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
