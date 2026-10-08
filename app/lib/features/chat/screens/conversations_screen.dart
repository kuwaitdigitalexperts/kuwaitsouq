import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/chat_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../core/localization/app_localizations.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().fetchMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final auth = context.watch<AuthProvider>();
    final myId = int.tryParse(auth.user?['id']?.toString() ?? '');

    // Group messages into distinct conversations
    final Map<int, Map<String, dynamic>> conversationMap = {};
    for (final m in chat.messages) {
      final senderId = int.tryParse(m['sender_id']?.toString() ?? '');
      final receiverId = int.tryParse(m['receiver_id']?.toString() ?? '');
      if (senderId == null || receiverId == null) continue;

      final otherId = senderId == myId ? receiverId : senderId;
      if (!conversationMap.containsKey(otherId)) {
        conversationMap[otherId] = m;
      }
    }

    final conversations = conversationMap.entries.toList();

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceWhite,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          context.tr('conversations_title'),
          style: const TextStyle(
            color: AppTheme.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: chat.loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)))
          : conversations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chat_bubble_outline,
                          color: Color(0xFF2563EB),
                          size: 38,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        context.tr('no_conversations'),
                        style: const TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'تواصل مع المعلنين والمشترين مباشرة من تفاصيل أي إعلان وستظهر محادثاتك هنا',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => context.read<ChatProvider>().fetchMessages(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: conversations.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
                    itemBuilder: (ctx, i) {
                      final otherId = conversations[i].key;
                      final lastMsg = conversations[i].value;
                      final sender = lastMsg['sender'] as Map<String, dynamic>?;
                      final receiver = lastMsg['receiver'] as Map<String, dynamic>?;
                      final partner = otherId == (sender?['id']) ? sender : receiver;
                      final partnerName = partner?['name'] as String? ?? 'مستخدم كويت سوق #$otherId';
                      final text = lastMsg['message'] as String? ?? lastMsg['content'] as String? ?? '';

                      return ListTile(
                        onTap: () {
                          context.push(
                            '/chat/$otherId',
                            extra: {'userName': partnerName},
                          );
                        },
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xFFEFF6FF),
                          child: Text(
                            partnerName.isNotEmpty ? partnerName[0].toUpperCase() : 'U',
                            style: const TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        title: Text(
                          partnerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5,
                            color: AppTheme.textDark,
                          ),
                        ),
                        subtitle: Text(
                          text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
                      );
                    },
                  ),
                ),
    );
  }
}
