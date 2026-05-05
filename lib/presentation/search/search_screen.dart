import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive_utils.dart';
import '../../data/models/product_model.dart';
import '../../core/controllers/browse_controller.dart';
import '../shared/product_card.dart';
import '../product_detail/product_detail_screen.dart';
import 'package:get_storage/get_storage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _storage = GetStorage();
  final browseController = Get.find<BrowseController>();
  final FocusNode _searchFocus = FocusNode();

  List<String> _recentSearches = [];
  List<String> _suggestions = [];
  bool _showSuggestions = false;
  RangeValues _priceRange = const RangeValues(0, 500000);
  String? _selectedBrand;
  String? _selectedCondition;
  String _sortBy = 'newest';
  bool _ptaApprovedOnly = false;
  bool _exchangeAvailableOnly = false;

  final List<String> _brands = [
    'iPhone',
    'Samsung',
    'Google Pixel',
    'OnePlus',
    'Xiaomi',
    'Huawei',
    'Oppo',
    'Vivo',
    'Realme',
    'Tecno',
  ];

  final List<String> _conditions = [
    'Like New',
    'Excellent',
    'Good',
    'Fair',
  ];

  final List<Product> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadRecentSearches() {
    final searches = _storage.read<List>('recent_searches');
    if (searches != null) {
      _recentSearches = List<String>.from(searches);
    }
  }

  void _saveRecentSearch(String query) {
    if (query.isEmpty) return;
    _recentSearches.remove(query);
    _recentSearches.insert(0, query);
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.sublist(0, 10);
    }
    _storage.write('recent_searches', _recentSearches);
    setState(() {});
  }

  void _clearRecentSearches() {
    _recentSearches.clear();
    _storage.remove('recent_searches');
    setState(() {});
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    setState(() {
      _suggestions = _brands
          .where((brand) => brand.toLowerCase().contains(query))
          .toList();
      _showSuggestions = true;
    });

    browseController.setSearchQuery(query);
  }

  void _performSearch(String query) {
    _searchController.text = query;
    _saveRecentSearch(query);
    browseController.setSearchQuery(query);
    setState(() {
      _showSuggestions = false;
      _searchFocus.unfocus();
    });
  }

  void _clearFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 500000);
      _selectedBrand = null;
      _selectedCondition = null;
      _sortBy = 'newest';
      _ptaApprovedOnly = false;
      _exchangeAvailableOnly = false;
    });
  }

  List<Product> _getFilteredProducts() {
    var products = browseController.filteredListings.toList();

    if (_selectedBrand != null) {
      products = products
          .where((p) => p.title.toLowerCase().contains(_selectedBrand!.toLowerCase()))
          .toList();
    }

    if (_selectedCondition != null) {
      products = products
          .where((p) => p.condition == _selectedCondition)
          .toList();
    }

    if (_ptaApprovedOnly) {
      products = products.where((p) => p.isPtaApproved).toList();
    }

    if (_exchangeAvailableOnly) {
      products = products.where((p) => p.isExchangeAvailable).toList();
    }

    products = products
        .where((p) => p.priceValue >= _priceRange.start && p.priceValue <= _priceRange.end)
        .toList();

    switch (_sortBy) {
      case 'price_low':
        products.sort((a, b) => a.priceValue.compareTo(b.priceValue));
        break;
      case 'price_high':
        products.sort((a, b) => b.priceValue.compareTo(a.priceValue));
        break;
      case 'newest':
        products.sort((a, b) => b.postedAt.compareTo(a.postedAt));
        break;
    }

    return products;
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimensions.borderRadiusLarge),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppDimensions.padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          _clearFilters();
                        });
                      },
                      child: Text(
                        'Clear All',
                        style: TextStyle(color: AppColors.accent),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price Range',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: AppDimensions.gapMedium),
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 500000,
                        divisions: 50,
                        labels: RangeLabels(
                          'Rs ${_priceRange.start.round()}',
                          'Rs ${_priceRange.end.round()}',
                        ),
                        activeColor: AppColors.accent,
                        onChanged: (values) {
                          setModalState(() {
                            _priceRange = values;
                          });
                          setState(() {});
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rs ${_priceRange.start.round()}',
                              style: TextStyle(color: AppColors.secondary)),
                          Text('Rs ${_priceRange.end.round()}',
                              style: TextStyle(color: AppColors.secondary)),
                        ],
                      ),
                      SizedBox(height: AppDimensions.padding),
                      Text(
                        'Brand',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: AppDimensions.gapMedium),
                      Wrap(
                        spacing: AppDimensions.gapMedium,
                        runSpacing: AppDimensions.gapSmall,
                        children: _brands.map((brand) {
                          final isSelected = _selectedBrand == brand;
                          return FilterChip(
                            label: Text(brand),
                            selected: isSelected,
                            onSelected: (selected) {
                              setModalState(() {
                                _selectedBrand = selected ? brand : null;
                              });
                              setState(() {});
                            },
                            selectedColor: AppColors.accent.withValues(alpha: 0.2),
                            checkmarkColor: AppColors.accent,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: AppDimensions.padding),
                      Text(
                        'Condition',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: AppDimensions.gapMedium),
                      Wrap(
                        spacing: AppDimensions.gapMedium,
                        runSpacing: AppDimensions.gapSmall,
                        children: _conditions.map((condition) {
                          final isSelected = _selectedCondition == condition;
                          return FilterChip(
                            label: Text(condition),
                            selected: isSelected,
                            onSelected: (selected) {
                              setModalState(() {
                                _selectedCondition = selected ? condition : null;
                              });
                              setState(() {});
                            },
                            selectedColor: AppColors.accent.withValues(alpha: 0.2),
                            checkmarkColor: AppColors.accent,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: AppDimensions.padding),
                      Text(
                        'Sort By',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: AppDimensions.gapMedium),
                      Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Newest First'),
                            value: 'newest',
                            groupValue: _sortBy,
                            onChanged: (value) {
                              setModalState(() {
                                _sortBy = value!;
                              });
                              setState(() {});
                            },
                            activeColor: AppColors.accent,
                            contentPadding: EdgeInsets.zero,
                          ),
                          RadioListTile<String>(
                            title: const Text('Price: Low to High'),
                            value: 'price_low',
                            groupValue: _sortBy,
                            onChanged: (value) {
                              setModalState(() {
                                _sortBy = value!;
                              });
                              setState(() {});
                            },
                            activeColor: AppColors.accent,
                            contentPadding: EdgeInsets.zero,
                          ),
                          RadioListTile<String>(
                            title: const Text('Price: High to Low'),
                            value: 'price_high',
                            groupValue: _sortBy,
                            onChanged: (value) {
                              setModalState(() {
                                _sortBy = value!;
                              });
                              setState(() {});
                            },
                            activeColor: AppColors.accent,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.gapMedium),
                      SwitchListTile(
                        title: const Text('PTA Approved Only'),
                        value: _ptaApprovedOnly,
                        onChanged: (value) {
                          setModalState(() {
                            _ptaApprovedOnly = value;
                          });
                          setState(() {});
                        },
                        activeColor: AppColors.accent,
                        contentPadding: EdgeInsets.zero,
                      ),
                      SwitchListTile(
                        title: const Text('Exchange Available'),
                        value: _exchangeAvailableOnly,
                        onChanged: (value) {
                          setModalState(() {
                            _exchangeAvailableOnly = value;
                          });
                          setState(() {});
                        },
                        activeColor: AppColors.accent,
                        contentPadding: EdgeInsets.zero,
                      ),
                      SizedBox(height: AppDimensions.padding),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppDimensions.padding),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            onChanged: (_) {},
            onSubmitted: (value) => _performSearch(value),
            decoration: InputDecoration(
              hintText: 'Search phones, brands...',
              hintStyle: GoogleFonts.inter(
                color: AppColors.secondary,
                fontSize: 14,
              ),
              prefixIcon: Icon(Icons.search, color: AppColors.secondary, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: AppColors.secondary, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        browseController.setSearchQuery('');
                        setState(() {
                          _showSuggestions = false;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.tune, color: AppColors.accent, size: 20),
            ),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_searchController.text.isNotEmpty || _hasActiveFilters())
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.padding,
                vertical: AppDimensions.gapSmall,
              ),
              child: Row(
                children: [
                  Text(
                    '${filteredProducts.length} results found',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.secondary,
                    ),
                  ),
                  const Spacer(),
                  if (_hasActiveFilters())
                    TextButton(
                      onPressed: () {
                        _clearFilters();
                        browseController.setSearchQuery('');
                        _searchController.clear();
                      },
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          if (_showSuggestions && _suggestions.isNotEmpty)
            Container(
              color: AppColors.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _suggestions.map((suggestion) {
                  return ListTile(
                    leading: Icon(Icons.search, color: AppColors.secondary, size: 18),
                    title: Text(
                      suggestion,
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                    onTap: () => _performSearch(suggestion),
                  );
                }).toList(),
              ),
            ),
          if (_showSuggestions && _recentSearches.isNotEmpty && _searchController.text.isEmpty)
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(AppDimensions.padding),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Searches',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      TextButton(
                        onPressed: _clearRecentSearches,
                        child: Text(
                          'Clear',
                          style: TextStyle(color: AppColors.accent, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  ...List.generate(_recentSearches.length, (index) {
                    final search = _recentSearches[index];
                    return ListTile(
                      leading: Icon(Icons.history, color: AppColors.secondary),
                      title: Text(
                        search,
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.north_west, color: AppColors.secondary, size: 16),
                        onPressed: () => _performSearch(search),
                      ),
                      onTap: () => _performSearch(search),
                    );
                  }),
                ],
              ),
            )
          else if (!_showSuggestions || _searchController.text.isEmpty)
            Expanded(
              child: filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.getHorizontalPadding(context),
                      ),
                      child: GridView.builder(
                        padding: EdgeInsets.only(top: AppDimensions.gapMedium),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: ResponsiveUtils.getGridMaxCrossAxisExtent(context),
                          childAspectRatio: ResponsiveUtils.getChildAspectRatioForExtent(context),
                          crossAxisSpacing: AppDimensions.gapMedium,
                          mainAxisSpacing: AppDimensions.gapMedium,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: filteredProducts[index],
                            onTap: () {
                              Get.to(() => ProductDetailScreen(
                                    product: filteredProducts[index],
                                  ));
                            },
                          );
                        },
                      ),
                    ),
            ),
        ],
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedBrand != null ||
        _selectedCondition != null ||
        _ptaApprovedOnly ||
        _exchangeAvailableOnly ||
        _priceRange.start > 0 ||
        _priceRange.end < 500000 ||
        _sortBy != 'newest';
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.padding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: AppColors.secondary.withValues(alpha: 0.3),
            ),
            SizedBox(height: AppDimensions.padding),
            Text(
              'No phones found',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppDimensions.gapMedium),
            Text(
              'Try adjusting your filters or search term',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
