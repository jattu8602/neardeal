import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get products with filters and pagination
  Stream<List<ProductModel>> getProducts({
    ProductFilters? filters,
    int limit = 20,
  }) {
    Query query = _firestore.collection('products');

    // Apply filters
    if (filters?.category != null) {
      query = query.where('category', isEqualTo: filters!.category);
    }
    if (filters?.minPrice != null) {
      query = query.where('price', isGreaterThanOrEqualTo: filters!.minPrice);
    }
    if (filters?.maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: filters!.maxPrice);
    }
    if (filters?.condition != null) {
      query = query.where('condition', isEqualTo: filters!.condition!.name);
    }
    if (filters?.city != null) {
      query = query.where('location.city', isEqualTo: filters!.city);
    }

    // Always filter by active status
    query = query.where('status', isEqualTo: ProductStatus.active.name);

    // Apply sorting
    if (filters?.sortBy != null) {
      switch (filters!.sortBy) {
        case 'price-asc':
          query = query.orderBy('price', descending: false);
          break;
        case 'price-desc':
          query = query.orderBy('price', descending: true);
          break;
        case 'newest':
          query = query.orderBy('createdAt', descending: true);
          break;
        case 'popular':
          query = query.orderBy('likes', descending: true);
          break;
        default:
          query = query.orderBy('createdAt', descending: true);
      }
    } else {
      query = query.orderBy('createdAt', descending: true);
    }

    query = query.limit(limit);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  // Get single product
  Future<ProductModel?> getProduct(String productId) async {
    final doc = await _firestore.collection('products').doc(productId).get();
    if (!doc.exists) return null;
    return ProductModel.fromFirestore(doc.data()!, doc.id);
  }

  // Search products
  Stream<List<ProductModel>> searchProducts(String query) {
    return _firestore
        .collection('products')
        .where('status', isEqualTo: ProductStatus.active.name)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: '$query\uf8ff')
        .orderBy('title')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  // Create product
  Future<String> createProduct(ProductModel product) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final productData = product.toFirestore();
    productData['sellerId'] = user.uid;

    final docRef =
        await _firestore.collection('products').add(productData);
    return docRef.id;
  }

  // Update product
  Future<void> updateProduct(String productId, Map<String, dynamic> updates) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Verify ownership
    final product = await getProduct(productId);
    if (product?.sellerId != user.uid) {
      throw Exception('Not authorized to update this product');
    }

    await _firestore.collection('products').doc(productId).update(updates);
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Verify ownership
    final product = await getProduct(productId);
    if (product?.sellerId != user.uid) {
      throw Exception('Not authorized to delete this product');
    }

    await _firestore.collection('products').doc(productId).update({
      'status': ProductStatus.removed.name,
    });
  }

  // Toggle favorite
  Future<void> toggleFavorite(String productId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final favorites = List<String>.from(userDoc.data()?['favorites'] ?? []);

    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }

    await _firestore.collection('users').doc(user.uid).update({
      'favorites': favorites,
    });
  }

  // Get user's products
  Stream<List<ProductModel>> getUserProducts(String userId) {
    return _firestore
        .collection('products')
        .where('sellerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  // Get categories
  Future<List<String>> getCategories() async {
    // This could be stored in a separate collection or hardcoded
    return [
      'Electronics',
      'Clothing',
      'Books',
      'Furniture',
      'Sports',
      'Vehicles',
      'Other',
    ];
  }

  // Increment views
  Future<void> incrementViews(String productId) async {
    await _firestore.collection('products').doc(productId).update({
      'views': FieldValue.increment(1),
    });
  }

  // Increment likes
  Future<void> incrementLikes(String productId) async {
    await _firestore.collection('products').doc(productId).update({
      'likes': FieldValue.increment(1),
    });
  }
}
