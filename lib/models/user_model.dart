import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String phone;
  final String? name;
  final String? email;
  final String? profileImage;
  final UserLocation? location;
  final String role; // 'user', 'seller', 'admin'
  final bool isSeller;
  final SellerInfo? sellerInfo;
  final List<String>? interests;
  final List<String>? favorites;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.phone,
    this.name,
    this.email,
    this.profileImage,
    this.location,
    this.role = 'user',
    this.isSeller = false,
    this.sellerInfo,
    this.interests,
    this.favorites,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      phone: data['phone'] ?? '',
      name: data['name'],
      email: data['email'],
      profileImage: data['profileImage'],
      location: data['location'] != null
          ? UserLocation.fromMap(data['location'])
          : null,
      role: data['role'] ?? 'user',
      isSeller: data['isSeller'] ?? false,
      sellerInfo: data['sellerInfo'] != null
          ? SellerInfo.fromMap(data['sellerInfo'])
          : null,
      interests: data['interests'] != null
          ? List<String>.from(data['interests'])
          : null,
      favorites: data['favorites'] != null
          ? List<String>.from(data['favorites'])
          : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'phone': phone,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (profileImage != null) 'profileImage': profileImage,
      if (location != null) 'location': location!.toMap(),
      'role': role,
      'isSeller': isSeller,
      if (sellerInfo != null) 'sellerInfo': sellerInfo!.toMap(),
      if (interests != null) 'interests': interests,
      if (favorites != null) 'favorites': favorites,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserModel copyWith({
    String? id,
    String? phone,
    String? name,
    String? email,
    String? profileImage,
    UserLocation? location,
    String? role,
    bool? isSeller,
    SellerInfo? sellerInfo,
    List<String>? interests,
    List<String>? favorites,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      location: location ?? this.location,
      role: role ?? this.role,
      isSeller: isSeller ?? this.isSeller,
      sellerInfo: sellerInfo ?? this.sellerInfo,
      interests: interests ?? this.interests,
      favorites: favorites ?? this.favorites,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserLocation {
  final String city;
  final List<double> coordinates; // [lng, lat]
  final String? address;

  UserLocation({required this.city, required this.coordinates, this.address});

  factory UserLocation.fromMap(Map<String, dynamic> map) {
    return UserLocation(
      city: map['city'] ?? '',
      coordinates: List<double>.from(map['coordinates'] ?? []),
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'coordinates': coordinates,
      if (address != null) 'address': address,
    };
  }
}

class SellerInfo {
  final bool kycVerified;
  final List<String>? kycDocuments;
  final String? businessName;
  final double? rating;
  final int? totalSales;

  SellerInfo({
    this.kycVerified = false,
    this.kycDocuments,
    this.businessName,
    this.rating,
    this.totalSales,
  });

  factory SellerInfo.fromMap(Map<String, dynamic> map) {
    return SellerInfo(
      kycVerified: map['kycVerified'] ?? false,
      kycDocuments: map['kycDocuments'] != null
          ? List<String>.from(map['kycDocuments'])
          : null,
      businessName: map['businessName'],
      rating: map['rating']?.toDouble(),
      totalSales: map['totalSales'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kycVerified': kycVerified,
      if (kycDocuments != null) 'kycDocuments': kycDocuments,
      if (businessName != null) 'businessName': businessName,
      if (rating != null) 'rating': rating,
      if (totalSales != null) 'totalSales': totalSales,
    };
  }
}
