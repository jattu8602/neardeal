import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../common/enhanced_button.dart';
import '../common/enhanced_text_field.dart';

class FilterSheet extends StatefulWidget {
  final ProductFilters initialFilters;
  final ValueChanged<ProductFilters> onFiltersChanged;
  final VoidCallback onClearFilters;

  const FilterSheet({
    super.key,
    required this.initialFilters,
    required this.onFiltersChanged,
    required this.onClearFilters,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late ProductFilters _filters;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  static const List<String> _categories = [
    'Electronics',
    'Books',
    'Clothing',
    'Furniture',
    'Sports',
    'Accessories',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
    _minPriceController.text = _filters.minPrice?.toStringAsFixed(0) ?? '';
    _maxPriceController.text = _filters.maxPrice?.toStringAsFixed(0) ?? '';
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _applyFilter(String key, dynamic value) {
    ProductFilters newFilters;
    switch (key) {
      case 'category':
        newFilters = ProductFilters(
          category: _filters.category == value ? null : value,
          minPrice: _filters.minPrice,
          maxPrice: _filters.maxPrice,
          condition: _filters.condition,
          priceType: _filters.priceType,
          sortBy: _filters.sortBy,
        );
        break;
      case 'condition':
        newFilters = ProductFilters(
          category: _filters.category,
          minPrice: _filters.minPrice,
          maxPrice: _filters.maxPrice,
          condition: _filters.condition == value ? null : value,
          priceType: _filters.priceType,
          sortBy: _filters.sortBy,
        );
        break;
      case 'priceType':
        newFilters = ProductFilters(
          category: _filters.category,
          minPrice: _filters.minPrice,
          maxPrice: _filters.maxPrice,
          condition: _filters.condition,
          priceType: _filters.priceType == value ? null : value,
          sortBy: _filters.sortBy,
        );
        break;
      case 'sortBy':
        newFilters = ProductFilters(
          category: _filters.category,
          minPrice: _filters.minPrice,
          maxPrice: _filters.maxPrice,
          condition: _filters.condition,
          priceType: _filters.priceType,
          sortBy: _filters.sortBy == value ? null : value,
        );
        break;
      default:
        return;
    }

    if (mounted) {
      setState(() {
        _filters = newFilters;
      });
    }
  }

  void _updatePriceFilter() {
    if (!mounted) return;

    setState(() {
      _filters = ProductFilters(
        category: _filters.category,
        minPrice: _minPriceController.text.isNotEmpty
            ? double.tryParse(_minPriceController.text)
            : null,
        maxPrice: _maxPriceController.text.isNotEmpty
            ? double.tryParse(_maxPriceController.text)
            : null,
        condition: _filters.condition,
        priceType: _filters.priceType,
        sortBy: _filters.sortBy,
      );
    });
  }

  void _clearFilters() {
    if (!mounted) return;

    setState(() {
      _filters = ProductFilters();
      _minPriceController.clear();
      _maxPriceController.clear();
    });
    widget.onClearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FilterSection(
                    title: 'Category',
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _categories.map((cat) {
                        final isSelected = _filters.category == cat;
                        return _FilterChip(
                          key: ValueKey('category_$cat'),
                          label: cat,
                          isSelected: isSelected,
                          onTap: () => _applyFilter('category', isSelected ? null : cat),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _FilterSection(
                    title: 'Price Range',
                    child: Row(
                      children: [
                        Expanded(
                          child: EnhancedTextField(
                            controller: _minPriceController,
                            labelText: 'Min Price',
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _updatePriceFilter(),
                            prefixIcon: const Icon(Icons.currency_rupee, size: 20),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'to',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: EnhancedTextField(
                            controller: _maxPriceController,
                            labelText: 'Max Price',
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _updatePriceFilter(),
                            prefixIcon: const Icon(Icons.currency_rupee, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  _FilterSection(
                    title: 'Condition',
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        'new',
                        'like-new',
                        'good',
                        'fair',
                      ].map((cond) {
                        final condition = _parseCondition(cond);
                        final isSelected = _filters.condition == condition;
                        return _FilterChip(
                          key: ValueKey('condition_$cond'),
                          label: _formatCondition(cond),
                          isSelected: isSelected,
                          onTap: () => _applyFilter('condition', isSelected ? null : condition),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _FilterSection(
                    title: 'Price Type',
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        'fixed',
                        'negotiable',
                        'discount',
                      ].map((type) {
                        final priceType = _parsePriceType(type);
                        final isSelected = _filters.priceType == priceType;
                        return _FilterChip(
                          key: ValueKey('priceType_$type'),
                          label: _formatPriceType(type),
                          isSelected: isSelected,
                          onTap: () => _applyFilter('priceType', isSelected ? null : priceType),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _FilterSection(
                    title: 'Sort By',
                    child: Column(
                      children: [
                        'newest',
                        'popular',
                        'price-asc',
                        'price-desc',
                      ].map((sort) {
                        final isSelected = _filters.sortBy == sort;
                        return _SortOption(
                          key: ValueKey('sort_$sort'),
                          label: _formatSortBy(sort),
                          isSelected: isSelected,
                          onTap: () => _applyFilter('sortBy', isSelected ? null : sort),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Filters',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 20),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: EnhancedButton(
              label: 'Clear All',
              variant: ButtonVariant.outline,
              onPressed: _clearFilters,
              height: 52,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: EnhancedButton(
              label: 'Apply Filters',
              variant: ButtonVariant.primary,
              onPressed: () {
                widget.onFiltersChanged(_filters);
                Navigator.pop(context);
              },
              height: 52,
            ),
          ),
        ],
      ),
    );
  }

  ProductCondition? _parseCondition(String value) {
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

  String _formatCondition(String value) {
    return value.split('-').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  PriceType? _parsePriceType(String value) {
    switch (value) {
      case 'negotiable':
        return PriceType.negotiable;
      case 'discount':
        return PriceType.discount;
      default:
        return PriceType.fixed;
    }
  }

  String _formatPriceType(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }

  String _formatSortBy(String value) {
    switch (value) {
      case 'price-asc':
        return 'Price: Low to High';
      case 'price-desc':
        return 'Price: High to Low';
      case 'newest':
        return 'Newest';
      case 'popular':
        return 'Most Popular';
      default:
        return value;
    }
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.deepPurple : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
                width: isSelected ? 0 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.deepPurple.withOpacity(0.1)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.deepPurple : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.deepPurple : Colors.black87,
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.deepPurple,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
