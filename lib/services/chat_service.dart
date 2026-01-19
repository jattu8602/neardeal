import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get user's chats
  Stream<List<ChatModel>> getUserChats() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Get or create chat
  Future<String> getOrCreateChat(String otherUserId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    // Check if chat exists
    final existingChats = await _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();

    for (var chatDoc in existingChats.docs) {
      final participants = List<String>.from(chatDoc.data()['participants'] ?? []);
      if (participants.contains(otherUserId) && participants.contains(userId)) {
        return chatDoc.id;
      }
    }

    // Create new chat
    final chatData = {
      'participants': [userId, otherUserId],
      'messages': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final docRef = await _firestore.collection('chats').add(chatData);
    return docRef.id;
  }

  // Get chat messages
  Stream<List<Message>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data == null) return [];

      final messages = data['messages'] as List<dynamic>? ?? [];
      return messages
          .map((m) => Message.fromMap(m as Map<String, dynamic>))
          .toList();
    });
  }

  // Send message
  Future<void> sendMessage(String chatId, String text, {String? imageUrl}) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final message = {
      'senderId': userId,
      'text': text,
      if (imageUrl != null) 'image': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    };

    await _firestore.collection('chats').doc(chatId).update({
      'messages': FieldValue.arrayUnion([message]),
      'lastMessage': {
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      },
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Mark messages as read
  Future<void> markAsRead(String chatId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    final messages = List<Map<String, dynamic>>.from(
        chatDoc.data()?['messages'] ?? []);

    for (var i = 0; i < messages.length; i++) {
      if (messages[i]['senderId'] != userId) {
        messages[i]['read'] = true;
      }
    }

    await _firestore.collection('chats').doc(chatId).update({
      'messages': messages,
    });
  }
}
