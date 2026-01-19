import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../product_card.dart';

class ProductsListView extends StatelessWidget {
  final List<ProductModel> products;
  final bool isLoading;
  final bool hasSearchQuery;
  final bool hasActiveFilters;
  final VoidCallback? onOpenFilters;
  final ValueChanged<ProductModel>? onProductTap;
  final ValueChanged<ProductModel>? onFavoriteTap;

  const ProductsListView({
    super.key,
    required this.products,
    this.isLoading = false,
    this.hasSearchQuery = false,
    this.hasActiveFilters = false,
    this.onOpenFilters,
    this.onProductTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && products.isEmpty) {
      return _buildLoadingState();
    }

    if (products.isEmpty && (hasSearchQuery || hasActiveFilters)) {
      return _buildEmptyResultsState(context);
    }

    if (products.isEmpty) {
      return _buildInitialState(context);
    }

    return _buildProductsList();
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 6,
      cacheExtent: 200,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          child: Container(
            key: ValueKey('loading_$index'),
            height: 220,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyResultsState(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search_off_rounded,
                    size: 40,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No products found',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Try adjusting your search or filters',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: onOpenFilters ?? () {},
                  icon: const Icon(Icons.tune),
                  label: const Text('Open filters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    size: 40,
                    color: Colors.deepPurple.shade300,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Start searching',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Enter a search term or use filters\nto find products',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: onOpenFilters ?? () {},
                  icon: const Icon(Icons.explore),
                  label: const Text('Explore categories'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                    side: const BorderSide(
                      color: Colors.deepPurple,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Text(
                '${products.length} result${products.length == 1 ? '' : 's'}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: products.length,
            cacheExtent: 500,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: true,
            itemBuilder: (context, index) {
              final product = products[index];
              return RepaintBoundary(
                key: ValueKey('product_${product.id}_$index'),
                child: ProductCard(
                  key: ValueKey('product_card_${product.id}'),
                  product: product,
                  onTap: () => onProductTap?.call(product),
                  onFavoriteTap: () => onFavoriteTap?.call(product),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
