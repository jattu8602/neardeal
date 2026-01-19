import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String sellerId;
  final int rating; // 1-5
  final String? comment;
  final List<String>? images;
  final int helpful;
  final DateTime createdAt;

  // Populated fields
  final UserInfo? user;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.sellerId,
    required this.rating,
    this.comment,
    this.images,
    this.helpful = 0,
    required this.createdAt,
    this.user,
  });

  factory ReviewModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ReviewModel(
      id: id,
      productId: data['productId'] ?? '',
      userId: data['userId'] ?? '',
      sellerId: data['sellerId'] ?? '',
      rating: data['rating'] ?? 0,
      comment: data['comment'],
      images: data['images'] != null ? List<String>.from(data['images']) : null,
      helpful: data['helpful'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      user: data['user'] != null ? UserInfo.fromMap(data['user']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'userId': userId,
      'sellerId': sellerId,
      'rating': rating,
      if (comment != null) 'comment': comment,
      if (images != null) 'images': images,
      'helpful': helpful,
      'createdAt': Timestamp.fromDate(createdAt),
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
