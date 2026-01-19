import 'package:flutter/material.dart';
import '../common/enhanced_text_field.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback onFilterTap;
  final bool hasActiveFilters;
  final int activeFilterCount;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.onSubmitted,
    required this.onFilterTap,
    this.hasActiveFilters = false,
    this.activeFilterCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: EnhancedTextField(
              controller: controller,
              hintText: 'Search product...',
              onSubmitted: onSubmitted,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade600,
                size: 22,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildFilterButton(context),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: hasActiveFilters
                ? LinearGradient(
                    colors: [
                      Colors.deepPurple,
                      Colors.deepPurple.shade700,
                    ],
                  )
                : null,
            color: hasActiveFilters ? null : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: hasActiveFilters
                    ? Colors.deepPurple.withOpacity(0.3)
                    : Colors.black.withOpacity(0.08),
                blurRadius: hasActiveFilters ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(14),
              child: Center(
                child: Icon(
                  Icons.tune_rounded,
                  color: hasActiveFilters ? Colors.white : Colors.black87,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        if (hasActiveFilters)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$activeFilterCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
