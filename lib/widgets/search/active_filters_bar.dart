import 'package:flutter/material.dart';
import '../../models/product_model.dart';

class ActiveFiltersBar extends StatelessWidget {
  final ProductFilters filters;
  final ValueChanged<String> onRemoveFilter;

  const ActiveFiltersBar({
    super.key,
    required this.filters,
    required this.onRemoveFilter,
  });

  @override
  Widget build(BuildContext context) {
    final activeFilters = _getActiveFilters();

    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 52,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: activeFilters.length,
        itemBuilder: (context, index) {
          final filter = activeFilters[index];
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: _ActiveFilterTag(
              label: filter['label']!,
              onRemove: () => onRemoveFilter(filter['key']!),
            ),
          );
        },
      ),
    );
  }

  List<Map<String, String>> _getActiveFilters() {
    final List<Map<String, String>> active = [];

    if (filters.category != null) {
      active.add({
        'key': 'category',
        'label': filters.category!,
      });
    }

    if (filters.condition != null) {
      active.add({
        'key': 'condition',
        'label': _formatCondition(filters.condition!.name),
      });
    }

    if (filters.priceType != null) {
      active.add({
        'key': 'priceType',
        'label': _formatPriceType(filters.priceType!.name),
      });
    }

    if (filters.minPrice != null || filters.maxPrice != null) {
      active.add({
        'key': 'price',
        'label': '₹${filters.minPrice?.toStringAsFixed(0) ?? '0'} - ₹${filters.maxPrice?.toStringAsFixed(0) ?? '∞'}',
      });
    }

    return active;
  }

  String _formatCondition(String value) {
    return value.split('-').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  String _formatPriceType(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }
}

class _ActiveFilterTag extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _ActiveFilterTag({
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.withOpacity(0.15),
            Colors.deepPurple.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.deepPurple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
