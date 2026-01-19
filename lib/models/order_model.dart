import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { pending, confirmed, completed, cancelled }

class OrderModel {
  final String id;
  final String buyerId;
  final String sellerId;
  final String productId;
  final int quantity;
  final double totalPrice;
  final OrderStatus status;
  final String? deliveryMethod;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.productId,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    this.deliveryMethod,
    this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> data, String id) {
    return OrderModel(
      id: id,
      buyerId: data['buyerId'] ?? '',
      sellerId: data['sellerId'] ?? '',
      productId: data['productId'] ?? '',
      quantity: data['quantity'] ?? 1,
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: _parseStatus(data['status']),
      deliveryMethod: data['deliveryMethod'],
      address: data['address'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'buyerId': buyerId,
      'sellerId': sellerId,
      'productId': productId,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'status': status.name,
      if (deliveryMethod != null) 'deliveryMethod': deliveryMethod,
      if (address != null) 'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static OrderStatus _parseStatus(String? value) {
    switch (value) {
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}
