import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  static const String _echoServerUrl = 'wss://echo.websocket.org';

  WebSocketChannel? _channel;
  StreamController<String>? _messageController;
  StreamController<bool>? _connectionController;
  Timer? _reconnectTimer;
  bool _isConnecting = false;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 3);

  Stream<String> get messageStream => _messageController!.stream;
  Stream<bool> get connectionStream => _connectionController!.stream;
  bool get isConnected => _channel != null && _channel!.closeCode == null;
  bool get isConnecting => _isConnecting;

  WebSocketService() {
    _messageController = StreamController<String>.broadcast();
    _connectionController = StreamController<bool>.broadcast();
  }

  Future<void> connect() async {
    if (_isConnecting || isConnected) return;

    _isConnecting = true;
    _connectionController?.add(false);

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_echoServerUrl));

      // Слушаем сообщения
      _channel!.stream.listen(
        (data) {
          final message = data.toString();
          _messageController?.add(message);
          _reconnectAttempts =
              0; // Сброс счетчика при успешном получении сообщения
        },
        onError: (error) {
          _handleConnectionError();
        },
        onDone: () {
          _handleConnectionClosed();
        },
      );

      // Ждем подтверждения подключения
      await Future.delayed(const Duration(milliseconds: 500));

      if (isConnected) {
        _isConnecting = false;
        _connectionController?.add(true);
      } else {
        throw Exception('Failed to establish connection');
      }
    } catch (e) {
      _isConnecting = false;
      _connectionController?.add(false);
      _scheduleReconnect();
    }
  }

  void sendMessage(String message) {
    if (!isConnected) {
      return;
    }

    _channel?.sink.add(message);
  }

  void disconnect() {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _channel?.sink.close(status.goingAway);
    _connectionController?.add(false);
  }

  void _handleConnectionError() {
    _isConnecting = false;
    _connectionController?.add(false);
    _scheduleReconnect();
  }

  void _handleConnectionClosed() {
    _isConnecting = false;
    _connectionController?.add(false);
    if (_shouldReconnect) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (!_shouldReconnect || _reconnectAttempts >= _maxReconnectAttempts) {
      return;
    }

    _reconnectAttempts++;

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (_shouldReconnect) {
        connect();
      }
    });
  }

  void dispose() {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _messageController?.close();
    _connectionController?.close();
  }
}
