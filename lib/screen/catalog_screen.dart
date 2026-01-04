import 'package:abstrak/base/api_state.dart';
import 'package:abstrak/main.dart'; // for customTextTheme, courierText, userNotifier
import 'package:abstrak/model/catalog_models.dart';
import 'package:abstrak/notifier/catalog_notifier.dart';
import 'package:abstrak/helper/rupiah_formatter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CatalogNotifier _notifier = CatalogNotifier();

  // Theme Constants
  static const Color primaryCyan = Color(0xFF00bcd5);
  static const Color darkBackground = Color(0xFF1a1a1a);
  static const Color cardBackground = Colors.black;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _notifier.getCategories();
    _notifier.getProducts();
    _notifier.getStats();
    _notifier.getInventoryItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.goNamed('home'),
        ),
        title: Text(
          'CATALOG MANAGEMENT',
          style: customTextTheme.headlineSmall?.copyWith(
            fontFamily: 'Kenzo',
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: primaryCyan),
            onPressed: () {
              _notifier.getCategories();
              _notifier.getProducts();
              _notifier.getStats();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryCyan,
          labelColor: primaryCyan,
          unselectedLabelColor: Colors.grey,
          labelStyle: customTextTheme.titleMedium?.copyWith(
            fontFamily: 'Kenzo',
          ),
          unselectedLabelStyle: customTextTheme.titleMedium?.copyWith(
            fontFamily: 'Kenzo',
          ),
          tabs: const [
            Tab(text: 'CATEGORIES'),
            Tab(text: 'PRODUCTS'),
            Tab(text: 'INVENTORY'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCategoriesTab(),
          _buildProductsTab(),
          _buildInventoryTab(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CATEGORIES TAB
  // ---------------------------------------------------------------------------
  Widget _buildCategoriesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildActionHeader(
            title: 'ALL CATEGORIES',
            buttonText: 'ADD CATEGORY',
            onPressed: () => _showCategoryDialog(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ValueListenableBuilder<ApiState<List<CategoryModel>>>(
              valueListenable: _notifier.categories,
              builder: (context, state, _) {
                if (state.status == ApiStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryCyan,
                    ),
                  );
                }
                if (state.status == ApiStatus.error) {
                  return Center(
                    child: Text(
                      state.error ?? 'Error loading categories',
                      style: courierText.bodyMedium?.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                final list = state.data ?? [];
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'No categories found.',
                      style: courierText.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return _buildListItem(
                      title: item.name ?? '-',
                      subtitle: item.description ?? '',
                      onEdit: () => _showCategoryDialog(category: item),
                      onDelete: () => _confirmDeleteCategory(item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PRODUCTS TAB
  // ---------------------------------------------------------------------------
  Widget _buildProductsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildActionHeader(
            title: 'ALL PRODUCTS',
            buttonText: 'ADD PRODUCT',
            onPressed: () => _showProductDialog(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ValueListenableBuilder<ApiState<List<ProductModel>>>(
              valueListenable: _notifier.products,
              builder: (context, state, _) {
                if (state.status == ApiStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryCyan,
                    ),
                  );
                }
                if (state.status == ApiStatus.error) {
                  return Center(
                    child: Text(
                      state.error ?? 'Error loading products',
                      style: courierText.bodyMedium?.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                final list = state.data ?? [];
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'No products found.',
                      style: courierText.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return _buildListItem(
                      title: item.name ?? '-',
                      subtitle: '${item.categoryName ?? '-'} | ${RupiahFormatter.rupiahFormatter(item.price?.toString())}',
                      onEdit: () => _showProductDialog(product: item),
                      onDelete: () => _confirmDeleteProduct(item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INVENTORY TAB
  // ---------------------------------------------------------------------------
  Widget _buildInventoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVENTORY STATISTICS',
            style: customTextTheme.titleLarge?.copyWith(
              fontFamily: 'Kenzo',
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<ApiState<InventoryStatsModel>>(
            valueListenable: _notifier.stats,
            builder: (context, state, _) {
              if (state.status == ApiStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryCyan,
                  ),
                );
              }
              final stats = state.data;
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('TOTAL ITEMS', '${stats?.total ?? 0}'),
                    const SizedBox(height: 12),
                    _buildInfoRow('AVAILABLE', '${stats?.available ?? 0}'),
                    const SizedBox(height: 12),
                    _buildInfoRow('SOLD', '${stats?.sold ?? 0}'),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Text(
            'BULK ACTIONS',
            style: customTextTheme.titleLarge?.copyWith(
              fontFamily: 'Kenzo',
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          _BulkUploadSection(
            notifier: _notifier,
            inputDecoration: _inputDecoration,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ALL CODES',
                style: customTextTheme.titleLarge?.copyWith(
                  fontFamily: 'Kenzo',
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: primaryCyan),
                onPressed: () => _notifier.getInventoryItems(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InventoryProductFilter(
            notifier: _notifier,
            inputDecoration: _inputDecoration,
          ),
          const SizedBox(height: 16),
          _InventoryItemsList(notifier: _notifier),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SHARED WIDGETS
  // ---------------------------------------------------------------------------
  Widget _buildListItem({
    required String title,
    required String subtitle,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: customTextTheme.titleMedium?.copyWith(
                    fontFamily: 'Kenzo',
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: courierText.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: primaryCyan, size: 20),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildActionHeader({
    required String title,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: customTextTheme.titleLarge?.copyWith(
            fontFamily: 'Kenzo',
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryCyan,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: customTextTheme.labelLarge?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: courierText.bodyMedium?.copyWith(
            color: Colors.grey[400],
          ),
        ),
        Text(
          value,
          style: courierText.bodyMedium?.copyWith(
            color: primaryCyan,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: courierText.bodyMedium?.copyWith(color: Colors.grey),
      filled: true,
      fillColor: Colors.black,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryCyan),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DIALOGS
  // ---------------------------------------------------------------------------
  void _showCategoryDialog({CategoryModel? category}) {
    final nameCtrl = TextEditingController(text: category?.name);
    final descCtrl = TextEditingController(text: category?.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Colors.white,
          ),
        ),
        title: Text(
          category == null ? 'ADD CATEGORY' : 'EDIT CATEGORY',
          style: customTextTheme.titleLarge?.copyWith(
            fontFamily: 'Kenzo',
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: courierText.bodyMedium?.copyWith(color: Colors.white),
              decoration: _inputDecoration('Category Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descCtrl,
              style: courierText.bodyMedium?.copyWith(color: Colors.white),
              decoration: _inputDecoration('Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(
              'SAVE',
              style: TextStyle(
                color: primaryCyan,
              ),
            ),
            onPressed: () {
              if (category == null) {
                _notifier.createCategory(nameCtrl.text, descCtrl.text);
              } else {
                _notifier.updateCategory(
                  category.id!,
                  nameCtrl.text,
                  descCtrl.text,
                );
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showProductDialog({ProductModel? product}) {
    final nameCtrl = TextEditingController(text: product?.name);
    final priceCtrl = TextEditingController(text: product?.price?.toString());
    
    String? selectedCategoryId = product?.categoryId;
    final categories = _notifier.categories.value.data ?? [];
    
    // Ensure the ID exists in the current list of categories
    if (selectedCategoryId != null &&
        !categories.any((c) => c.id == selectedCategoryId)) {
      selectedCategoryId = null; 
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: cardBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(
                  color: Colors.white,
                ),
              ),
              title: Text(
                product == null ? 'ADD PRODUCT' : 'EDIT PRODUCT',
                style: customTextTheme.titleLarge?.copyWith(
                  fontFamily: 'Kenzo',
                  color: Colors.white,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      style: courierText.bodyMedium?.copyWith(color: Colors.white),
                      decoration: _inputDecoration('Product Name'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: priceCtrl,
                      style: courierText.bodyMedium?.copyWith(color: Colors.white),
                      decoration: _inputDecoration('Price'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategoryId,
                      dropdownColor: cardBackground,
                      style: courierText.bodyMedium?.copyWith(color: Colors.white),
                      decoration: _inputDecoration('Category'),
                      items: categories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat.id,
                          child: Text(
                            cat.name ?? '-',
                            style: courierText.bodyMedium?.copyWith(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedCategoryId = val;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a category' : null,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      color: primaryCyan,
                    ),
                  ),
                  onPressed: () {
                    final price = int.tryParse(priceCtrl.text) ?? 0;
                    if (selectedCategoryId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a category')),
                      );
                      return;
                    }

                    if (product == null) {
                      final newProduct = ProductModel(
                        name: nameCtrl.text,
                        price: price,
                        categoryId: selectedCategoryId,
                      );
                      _notifier.createProduct(newProduct);
                    } else {
                      _notifier.updateProduct(
                        product.id!,
                        nameCtrl.text,
                        price,
                        categoryId: selectedCategoryId,
                      );
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteCategory(CategoryModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Colors.white,
          ),
        ),
        title: Text(
          'DELETE CATEGORY',
          style: customTextTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontFamily: 'Kenzo',
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${item.name}?',
          style: courierText.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _notifier.deleteCategory(item.id!);
              Navigator.pop(context);
            },
            child: Text(
              'DELETE',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _confirmDeleteProduct(ProductModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Colors.white,
          ),
        ),
        title: Text(
          'DELETE PRODUCT',
          style: customTextTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontFamily: 'Kenzo',
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${item.name}?',
          style: courierText.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _notifier.deleteProduct(item.id!);
              Navigator.pop(context);
            },
            child: Text(
              'DELETE',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// BULK UPLOAD SECTION (Stateful for local state management)
// ---------------------------------------------------------------------------
class _BulkUploadSection extends StatefulWidget {
  final CatalogNotifier notifier;
  final InputDecoration Function(String label) inputDecoration;

  const _BulkUploadSection({
    required this.notifier,
    required this.inputDecoration,
  });

  @override
  State<_BulkUploadSection> createState() => _BulkUploadSectionState();
}

class _BulkUploadSectionState extends State<_BulkUploadSection> {
  static const Color primaryCyan = Color(0xFF00bcd5);
  static const Color cardBackground = Colors.black;

  String? _selectedProductId;
  final TextEditingController _codesController = TextEditingController();
  bool _isUploading = false;

  @override
  void dispose() {
    _codesController.dispose();
    super.dispose();
  }

  Future<void> _handleUpload() async {
    if (_selectedProductId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product')),
      );
      return;
    }

    final codesText = _codesController.text.trim();
    if (codesText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one code')),
      );
      return;
    }

    // Split codes by newline, comma, or semicolon
    final codes = codesText
        .split(RegExp(r'[\n,;]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (codes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No valid codes found')),
      );
      return;
    }

    setState(() => _isUploading = true);

    final productId = int.tryParse(_selectedProductId!) ?? 0;
    final success = await widget.notifier.bulkUpload(productId, codes);

    setState(() => _isUploading = false);

    if (success) {
      _codesController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully uploaded ${codes.length} codes')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload codes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Product:',
            style: courierText.bodyMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<ApiState<List<ProductModel>>>(
            valueListenable: widget.notifier.products,
            builder: (context, state, _) {
              final products = state.data ?? [];
              return DropdownButtonFormField<String>(
                value: _selectedProductId,
                dropdownColor: cardBackground,
                style: courierText.bodyMedium?.copyWith(color: Colors.white),
                decoration: widget.inputDecoration('Product'),
                items: products.map((product) {
                  return DropdownMenuItem<String>(
                    value: product.id,
                    child: Text(
                      product.name ?? '-',
                      style: courierText.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedProductId = val;
                  });
                },
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Inventory Codes (one per line, or comma/semicolon separated):',
            style: courierText.bodyMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _codesController,
            style: courierText.bodyMedium?.copyWith(color: Colors.white),
            decoration: widget.inputDecoration('Enter codes...'),
            maxLines: 5,
            minLines: 3,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryCyan,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _isUploading ? null : _handleUpload,
              child: _isUploading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : Text(
                      'UPLOAD INVENTORY',
                      style: customTextTheme.titleMedium?.copyWith(
                        fontFamily: 'Kenzo',
                        color: Colors.black,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// INVENTORY ITEMS LIST (with Load More)
// ---------------------------------------------------------------------------
class _InventoryItemsList extends StatelessWidget {
  final CatalogNotifier notifier;
  
  static const Color primaryCyan = Color(0xFF00bcd5);
  static const Color cardBackground = Colors.black;

  const _InventoryItemsList({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ApiState<List<InventoryItemModel>>>(
      valueListenable: notifier.inventoryItems,
      builder: (context, state, _) {
        if (state.status == ApiStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: primaryCyan),
          );
        }
        if (state.status == ApiStatus.error) {
          return Center(
            child: Text(
              state.error ?? 'Error loading inventory',
              style: courierText.bodyMedium?.copyWith(color: Colors.red),
            ),
          );
        }
        final items = state.data ?? [];
        if (items.isEmpty) {
          return Center(
            child: Text(
              'No inventory items found.',
              style: courierText.bodyMedium?.copyWith(color: Colors.grey),
            ),
          );
        }
        return Column(
          children: [
            ...items.map((item) => _buildInventoryItemTile(item)),
            if (notifier.hasMoreInventoryItems)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryCyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => notifier.loadMoreInventoryItems(),
                  child: Text(
                    'LOAD MORE',
                    style: customTextTheme.labelLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildInventoryItemTile(InventoryItemModel item) {
    final isAvailable = item.status == 'available';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAvailable ? primaryCyan.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.secretCode ?? '-',
                  style: courierText.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.productName ?? '-',
                  style: courierText.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isAvailable ? primaryCyan.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              (item.status ?? 'unknown').toUpperCase(),
              style: courierText.labelSmall?.copyWith(
                color: isAvailable ? primaryCyan : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// INVENTORY PRODUCT FILTER
// ---------------------------------------------------------------------------
class _InventoryProductFilter extends StatefulWidget {
  final CatalogNotifier notifier;
  final InputDecoration Function(String label) inputDecoration;

  const _InventoryProductFilter({
    required this.notifier,
    required this.inputDecoration,
  });

  @override
  State<_InventoryProductFilter> createState() => _InventoryProductFilterState();
}

class _InventoryProductFilterState extends State<_InventoryProductFilter> {
  static const Color cardBackground = Colors.black;
  
  String? _selectedProductId;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ApiState<List<ProductModel>>>(
      valueListenable: widget.notifier.products,
      builder: (context, state, _) {
        final products = state.data ?? [];
        return DropdownButtonFormField<String>(
          value: _selectedProductId,
          dropdownColor: cardBackground,
          style: courierText.bodyMedium?.copyWith(color: Colors.white),
          decoration: widget.inputDecoration('Filter by Product'),
          hint: Text(
            'All Products',
            style: courierText.bodyMedium?.copyWith(color: Colors.grey),
          ),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(
                'All Products',
                style: courierText.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
            ...products.map((product) {
              return DropdownMenuItem<String>(
                value: product.id,
                child: Text(
                  product.name ?? '-',
                  style: courierText.bodyMedium?.copyWith(color: Colors.white),
                ),
              );
            }),
          ],
          onChanged: (val) {
            setState(() {
              _selectedProductId = val;
            });
            widget.notifier.setInventoryProductFilter(val);
          },
        );
      },
    );
  }
}
