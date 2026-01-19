import 'package:cloud_firestore/cloud_firestore.dart';

enum PriceType { fixed, negotiable, discount }

enum ProductCondition { new_, likeNew, good, fair }

enum ProductStatus { active, sold, removed, pending }

class ProductModel {
  final String id;
  final String sellerId;
  final String title;
  final String? description;
  final String category;
  final String? subcategory;
  final List<String> images;
  final List<String>? videos;
  final double price;
  final double? originalPrice;
  final int? discount; // 0-40
  final PriceType priceType;
  final ProductCondition condition;
  final ProductLocation location;
  final List<String>? tags;
  final bool? warranty;
  final bool? guarantee;
  final String? warrantyPeriod;
  final bool inStock;
  final int? stockCount;
  final int views;
  final int likes;
  final ProductStatus status;
  final int? reportedCount;
  final bool? isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Populated fields
  final SellerInfo? seller;
  final double? averageRating;
  final int? reviewCount;

  ProductModel({
    required this.id,
    required this.sellerId,
    required this.title,
    this.description,
    required this.category,
    this.subcategory,
    required this.images,
    this.videos,
    required this.price,
    this.originalPrice,
    this.discount,
    required this.priceType,
    required this.condition,
    required this.location,
    this.tags,
    this.warranty,
    this.guarantee,
    this.warrantyPeriod,
    required this.inStock,
    this.stockCount,
    this.views = 0,
    this.likes = 0,
    required this.status,
    this.reportedCount,
    this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    this.seller,
    this.averageRating,
    this.reviewCount,
  });

  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      sellerId: data['sellerId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'],
      category: data['category'] ?? '',
      subcategory: data['subcategory'],
      images: List<String>.from(data['images'] ?? []),
      videos: data['videos'] != null ? List<String>.from(data['videos']) : null,
      price: (data['price'] ?? 0).toDouble(),
      originalPrice: data['originalPrice']?.toDouble(),
      discount: data['discount'],
      priceType: _parsePriceType(data['priceType']),
      condition: _parseCondition(data['condition']),
      location: ProductLocation.fromMap(data['location'] ?? {}),
      tags: data['tags'] != null ? List<String>.from(data['tags']) : null,
      warranty: data['warranty'],
      guarantee: data['guarantee'],
      warrantyPeriod: data['warrantyPeriod'],
      inStock: data['inStock'] ?? true,
      stockCount: data['stockCount'],
      views: data['views'] ?? 0,
      likes: data['likes'] ?? 0,
      status: _parseStatus(data['status']),
      reportedCount: data['reportedCount'],
      isVerified: data['isVerified'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      seller: data['seller'] != null ? SellerInfo.fromMap(data['seller']) : null,
      averageRating: data['averageRating']?.toDouble(),
      reviewCount: data['reviewCount'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sellerId': sellerId,
      'title': title,
      if (description != null) 'description': description,
      'category': category,
      if (subcategory != null) 'subcategory': subcategory,
      'images': images,
      if (videos != null) 'videos': videos,
      'price': price,
      if (originalPrice != null) 'originalPrice': originalPrice,
      if (discount != null) 'discount': discount,
      'priceType': priceType.name,
      'condition': condition.name,
      'location': location.toMap(),
      if (tags != null) 'tags': tags,
      if (warranty != null) 'warranty': warranty,
      if (guarantee != null) 'guarantee': guarantee,
      if (warrantyPeriod != null) 'warrantyPeriod': warrantyPeriod,
      'inStock': inStock,
      if (stockCount != null) 'stockCount': stockCount,
      'views': views,
      'likes': likes,
      'status': status.name,
      if (reportedCount != null) 'reportedCount': reportedCount,
      if (isVerified != null) 'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static PriceType _parsePriceType(String? value) {
    switch (value) {
      case 'negotiable':
        return PriceType.negotiable;
      case 'discount':
        return PriceType.discount;
      default:
        return PriceType.fixed;
    }
  }

  static ProductCondition _parseCondition(String? value) {
    switch (value) {
      case 'like-new':
        return ProductCondition.likeNew;
      case 'good':
        return ProductCondition.good;
      case 'fair':
        return ProductCondition.fair;
      default:
        return ProductCondition.new_;
    }
  }

  static ProductStatus _parseStatus(String? value) {
    switch (value) {
      case 'sold':
        return ProductStatus.sold;
      case 'removed':
        return ProductStatus.removed;
      case 'pending':
        return ProductStatus.pending;
      default:
        return ProductStatus.active;
    }
  }
}

class ProductLocation {
  final String city;
  final List<double> coordinates; // [lng, lat]

  ProductLocation({
    required this.city,
    required this.coordinates,
  });

  factory ProductLocation.fromMap(Map<String, dynamic> map) {
    return ProductLocation(
      city: map['city'] ?? '',
      coordinates: List<double>.from(map['coordinates'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'coordinates': coordinates,
    };
  }
}

class SellerInfo {
  final String id;
  final String name;
  final String? profileImage;
  final double? rating;

  SellerInfo({
    required this.id,
    required this.name,
    this.profileImage,
    this.rating,
  });

  factory SellerInfo.fromMap(Map<String, dynamic> map) {
    return SellerInfo(
      id: map['_id'] ?? map['id'] ?? '',
      name: map['name'] ?? '',
      profileImage: map['profileImage'],
      rating: map['rating']?.toDouble(),
    );
  }
}

class ProductFilters {
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final ProductCondition? condition;
  final PriceType? priceType;
  final String? city;
  final double? radius; // km
  final List<double>? coordinates;
  final String? search;
  final String? sortBy; // 'price-asc', 'price-desc', 'newest', 'popular', 'distance';

  ProductFilters({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.condition,
    this.priceType,
    this.city,
    this.radius,
    this.coordinates,
    this.search,
    this.sortBy,
  });
}
