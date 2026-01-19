import 'package:flutter/material.dart';

class QuickSortChips extends StatelessWidget {
  final List<Map<String, String>> sortOptions;
  final String? selectedSort;
  final ValueChanged<String?> onSortChanged;

  const QuickSortChips({
    super.key,
    required this.sortOptions,
    this.selectedSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: sortOptions.length,
        itemBuilder: (context, index) {
          final sort = sortOptions[index];
          final isActive = selectedSort == sort['key'];
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: _SortChip(
              key: ValueKey('sort_${sort['key']}'),
              label: sort['label']!,
              isSelected: isActive,
              onTap: () => onSortChanged(isActive ? null : sort['key']),
            ),
          );
        },
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortChip({
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
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.deepPurple : Colors.white,
              borderRadius: BorderRadius.circular(20),
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
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
