import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/chat_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../shared/theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final int userId;
  final String? userName;
  final String? initialMessage;
  final int? adId;

  const ChatScreen({
    super.key,
    required this.userId,
    this.userName,
    this.initialMessage,
    this.adId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      _ctrl.text = widget.initialMessage!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().fetchMessages(adId: widget.adId);
      if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
        _send();
      }
    });
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    _ctrl.clear();
    await context.read<ChatProvider>().sendMessage(widget.userId, text, adId: widget.adId);
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final chat = context.watch<ChatProvider>();
    final me = int.tryParse(auth.user?['id']?.toString() ?? '');

    // Filter to only this conversation
    final msgs = chat.messages.where((m) {
      final s = int.tryParse(m['sender_id']?.toString() ?? '');
      final r = int.tryParse(m['receiver_id']?.toString() ?? '');
      return (s == me && r == widget.userId) || (s == widget.userId && r == me);
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.tagBg,
              child: Text(
                widget.userName?.isNotEmpty == true
                    ? widget.userName![0].toUpperCase()
                    : 'U',
                style: const TextStyle(color: AppTheme.primaryGreen, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName ?? 'Seller / Buyer',
                    style: const TextStyle(color: AppTheme.textDark, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Row(
                    children: [
                      CircleAvatar(radius: 3.5, backgroundColor: AppTheme.primaryGreen),
                      SizedBox(width: 4),
                      Text(
                        'متصل الآن · الكويت (Online · Kuwait)',
                        style: TextStyle(color: AppTheme.primaryGreen, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Message Bubbles List
          Expanded(
            child: msgs.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 54, color: AppTheme.textMuted),
                        SizedBox(height: 12),
                        Text(
                          'No messages yet',
                          style: TextStyle(color: AppTheme.textDark, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Send a message to inquire about the item',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollCtrl,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    itemCount: msgs.length,
                    itemBuilder: (ctx, i) {
                      final msg = msgs[i];
                      final isMe = int.tryParse(msg['sender_id']?.toString() ?? '') == me;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isMe ? AppTheme.primaryGreen : AppTheme.surfaceWhite,
                            border: isMe ? null : Border.all(color: AppTheme.borderLight, width: 0.8),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isMe ? 16 : 4),
                              bottomRight: Radius.circular(isMe ? 4 : 16),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x06000000),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            msg['content'] as String? ?? '',
                            style: TextStyle(
                              color: isMe ? Colors.white : AppTheme.textDark,
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceWhite,
              border: Border(top: BorderSide(color: AppTheme.borderLight, width: 0.8)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.inputBg,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _ctrl,
                        style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.primaryGreen,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: _send,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }
}
