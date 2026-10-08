import 'package:flutter/material.dart';
import '../api/api_client.dart';

class ChatProvider extends ChangeNotifier {
  final _api = ApiClient();
  List<Map<String, dynamic>> _messages = [];
  bool _loading = false;

  List<Map<String, dynamic>> get messages => _messages;
  bool get loading => _loading;

  Future<void> fetchMessages({int? adId}) async {
    _loading = true;
    notifyListeners();
    try {
      final data = await _api.getMessages(adId: adId);
      _messages = data.cast<Map<String, dynamic>>();
    } catch (_) {}
    _loading = false;
    notifyListeners();
  }

  Future<bool> sendMessage(int receiverId, String content, {int? adId}) async {
    try {
      final msg = await _api.sendMessage(receiverId, content, adId: adId);
      _messages.insert(0, msg);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void clear() {
    _messages = [];
    notifyListeners();
  }
}
