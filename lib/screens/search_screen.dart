import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../widgets/search/search_header.dart';
import '../widgets/search/search_bar_widget.dart';
import '../widgets/search/quick_suggestions.dart';
import '../widgets/search/quick_sort_chips.dart';
import '../widgets/search/active_filters_bar.dart';
import '../widgets/search/products_list_view.dart';
import '../widgets/search/filter_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductService _productService = ProductService();

  String _searchQuery = '';
  ProductFilters _filters = ProductFilters();
  List<ProductModel> _products = [];
  bool _isLoading = false;

  final List<String> _quickSuggestions = [
    'Laptop stand',
    'City cycle',
    'Desk lamp',
    'Gaming chair',
    'Textbooks',
  ];

  final List<Map<String, String>> _quickSorts = [
    {'key': 'newest', 'label': 'Newest'},
    {'key': 'popular', 'label': 'Trending'},
    {'key': 'price-asc', 'label': 'Price ↑'},
    {'key': 'price-desc', 'label': 'Price ↓'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _performSearch();
  }

  void _performSearch() {
    if (_searchQuery.isEmpty && !_hasActiveFilters()) {
      setState(() {
        _products = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _productService.searchProducts(_searchQuery).listen((products) {
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    });
  }

  bool _hasActiveFilters() {
    return _filters.category != null ||
        _filters.minPrice != null ||
        _filters.maxPrice != null ||
        _filters.condition != null ||
        _filters.priceType != null ||
        _filters.sortBy != null;
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_filters.category != null) count++;
    if (_filters.minPrice != null || _filters.maxPrice != null) count++;
    if (_filters.condition != null) count++;
    if (_filters.priceType != null) count++;
    if (_filters.sortBy != null) count++;
    return count;
  }

  void _applyFilter(String key, dynamic value) {
    setState(() {
      switch (key) {
        case 'category':
          _filters = ProductFilters(
            category: _filters.category == value ? null : value,
            minPrice: _filters.minPrice,
            maxPrice: _filters.maxPrice,
            condition: _filters.condition,
            priceType: _filters.priceType,
            sortBy: _filters.sortBy,
          );
          break;
        case 'condition':
          _filters = ProductFilters(
            category: _filters.category,
            minPrice: _filters.minPrice,
            maxPrice: _filters.maxPrice,
            condition: _filters.condition == value ? null : value,
            priceType: _filters.priceType,
            sortBy: _filters.sortBy,
          );
          break;
        case 'priceType':
          _filters = ProductFilters(
            category: _filters.category,
            minPrice: _filters.minPrice,
            maxPrice: _filters.maxPrice,
            condition: _filters.condition,
            priceType: _filters.priceType == value ? null : value,
            sortBy: _filters.sortBy,
          );
          break;
        case 'sortBy':
          _filters = ProductFilters(
            category: _filters.category,
            minPrice: _filters.minPrice,
            maxPrice: _filters.maxPrice,
            condition: _filters.condition,
            priceType: _filters.priceType,
            sortBy: _filters.sortBy == value ? null : value,
          );
          break;
      }
    });
    _performSearch();
  }

  void _clearFilters() {
    setState(() {
      _filters = ProductFilters();
    });
    _performSearch();
  }

  void _onFiltersChanged(ProductFilters newFilters) {
    setState(() {
      _filters = newFilters;
    });
    _performSearch();
  }

  void _onRemoveFilter(String key) {
    switch (key) {
      case 'category':
        _applyFilter('category', null);
        break;
      case 'condition':
        _applyFilter('condition', null);
        break;
      case 'priceType':
        _applyFilter('priceType', null);
        break;
      case 'price':
        setState(() {
          _filters = ProductFilters(
            category: _filters.category,
            condition: _filters.condition,
            priceType: _filters.priceType,
            sortBy: _filters.sortBy,
          );
        });
        _performSearch();
        break;
    }
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterSheet(
        initialFilters: _filters,
        onFiltersChanged: _onFiltersChanged,
        onClearFilters: _clearFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            SearchHeader(onFilterTap: _showFilterModal),
            SearchBarWidget(
              controller: _searchController,
              onSubmitted: (_) => _performSearch(),
              onFilterTap: _showFilterModal,
              hasActiveFilters: _hasActiveFilters(),
              activeFilterCount: _getActiveFilterCount(),
            ),
            QuickSuggestions(
              suggestions: _quickSuggestions,
              onSuggestionTap: (suggestion) {
                _searchController.text = suggestion;
                _performSearch();
              },
            ),
            QuickSortChips(
              sortOptions: _quickSorts,
              selectedSort: _filters.sortBy,
              onSortChanged: (sort) => _applyFilter('sortBy', sort),
            ),
            if (_hasActiveFilters())
              ActiveFiltersBar(
                filters: _filters,
                onRemoveFilter: _onRemoveFilter,
              ),
            Expanded(
              child: ProductsListView(
                products: _products,
                isLoading: _isLoading,
                hasSearchQuery: _searchQuery.isNotEmpty,
                hasActiveFilters: _hasActiveFilters(),
                onOpenFilters: _showFilterModal,
                onProductTap: (product) {
                  // Navigate to product detail
                },
                onFavoriteTap: (product) {
                  // Toggle favorite
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
