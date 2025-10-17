import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dfamedia/core/theme/app_colors.dart';
import 'package:dfamedia/features/chat/domain/entities/chat_message.dart';
import 'package:dfamedia/features/chat/presentation/chat_wm.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // Подключаемся к WebSocket при инициализации экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatWM>(context, listen: false);
      chatProvider.connect();
    });
  }

  @override
  void dispose() {
    // Отключаемся от WebSocket при закрытии экрана
    final chatProvider = Provider.of<ChatWM>(context, listen: false);
    chatProvider.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ChatWM>(
          builder: (context, provider, child) {
            return Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: provider.isConnected ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Чат поддержки',
                  style: TextStyle(
                    fontFamily: 'Stolzl',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<ChatWM>(
        builder: (context, provider, child) {
          return Column(
            children: [
              if (provider.hasError)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.red.shade50,
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.error!,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontFamily: 'Stolzl',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => provider.clearError(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: provider.messages.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Начните общение',
                              style: TextStyle(
                                fontFamily: 'Stolzl',
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.messages.length,
                        itemBuilder: (context, index) {
                          final message = provider.messages[index];
                          final isFromUser = provider.messageSources[index];
                          return _buildMessageBubble(message, isFromUser);
                        },
                      ),
              ),
              
              // Поле ввода сообщения
              const _MessageInputField(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isFromUser) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isFromUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isFromUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.grey200,
              child: const Icon(
                Icons.support_agent,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isFromUser ? AppColors.crimson400 : AppColors.grey200,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isFromUser
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: isFromUser
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontFamily: 'Stolzl',
                      fontSize: 14,
                      color: isFromUser ? AppColors.white : AppColors.grey800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontFamily: 'Stolzl',
                      fontSize: 10,
                      color: isFromUser ? AppColors.white : AppColors.grey800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFromUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.crimson400,
              child: const Icon(
                Icons.person,
                size: 16,
                color: AppColors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageInputField extends StatelessWidget {
  const _MessageInputField();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatWM>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: provider.messageController,
                  decoration: InputDecoration(
                    hintText: 'Введите сообщение...',
                    hintStyle: const TextStyle(
                      fontFamily: 'Stolzl',
                      color: AppColors.grey200,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: AppColors.grey200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: AppColors.grey200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: AppColors.crimson400),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => provider.sendCurrentMessage(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: provider.isConnected ? provider.sendCurrentMessage : null,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: provider.isConnected ? AppColors.crimson400 : AppColors.grey200,
                    shape: BoxShape.circle,
                  ),
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
