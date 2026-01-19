import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id;
  final List<String> participants;
  final List<Message> messages;
  final LastMessage? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Populated fields
  final UserInfo? otherUser;
  final int? unreadCount;

  ChatModel({
    required this.id,
    required this.participants,
    required this.messages,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    this.otherUser,
    this.unreadCount,
  });

  factory ChatModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ChatModel(
      id: id,
      participants: List<String>.from(data['participants'] ?? []),
      messages: (data['messages'] as List<dynamic>?)
              ?.map((m) => Message.fromMap(m as Map<String, dynamic>))
              .toList() ??
          [],
      lastMessage: data['lastMessage'] != null
          ? LastMessage.fromMap(data['lastMessage'])
          : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      otherUser: data['otherUser'] != null
          ? UserInfo.fromMap(data['otherUser'])
          : null,
      unreadCount: data['unreadCount'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'participants': participants,
      'messages': messages.map((m) => m.toMap()).toList(),
      if (lastMessage != null) 'lastMessage': lastMessage!.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

class Message {
  final String id;
  final String senderId;
  final String? text;
  final String? image;
  final DateTime timestamp;
  final bool read;

  Message({
    required this.id,
    required this.senderId,
    this.text,
    this.image,
    required this.timestamp,
    this.read = false,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['_id'] ?? map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      text: map['text'],
      image: map['image'],
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      read: map['read'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      if (text != null) 'text': text,
      if (image != null) 'image': image,
      'timestamp': Timestamp.fromDate(timestamp),
      'read': read,
    };
  }
}

class LastMessage {
  final String text;
  final DateTime timestamp;

  LastMessage({
    required this.text,
    required this.timestamp,
  });

  factory LastMessage.fromMap(Map<String, dynamic> map) {
    return LastMessage(
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class UserInfo {
  final String id;
  final String name;
  final String? profileImage;

  UserInfo({
    required this.id,
    required this.name,
    this.profileImage,
  });

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      id: map['_id'] ?? map['id'] ?? '',
      name: map['name'] ?? '',
      profileImage: map['profileImage'],
    );
  }
}
