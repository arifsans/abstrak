import 'package:abstrak/base/api_state.dart';
import 'package:abstrak/main.dart'; // for customTextTheme, courierText, userNotifier
import 'package:abstrak/model/catalog_models.dart';
import 'package:abstrak/notifier/catalog_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen>
    with SingleTickerProviderStateMixin {
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
                      child: CircularProgressIndicator(color: primaryCyan));
                }
                if (state.status == ApiStatus.error) {
                  return Center(
                    child: Text(
                      state.error ?? 'Error loading categories',
                      style:
                          courierText.bodyMedium?.copyWith(color: Colors.red),
                    ),
                  );
                }
                final list = state.data ?? [];
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'No categories found.',
                      style:
                          courierText.bodyMedium?.copyWith(color: Colors.grey),
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
                      child: CircularProgressIndicator(color: primaryCyan));
                }
                if (state.status == ApiStatus.error) {
                  return Center(
                    child: Text(
                      state.error ?? 'Error loading products',
                      style:
                          courierText.bodyMedium?.copyWith(color: Colors.red),
                    ),
                  );
                }
                final list = state.data ?? [];
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'No products found.',
                      style:
                          courierText.bodyMedium?.copyWith(color: Colors.grey),
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
                      subtitle:
                          '${item.categoryName ?? '-'} | \$${item.price ?? 0}',
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
                    child: CircularProgressIndicator(color: primaryCyan));
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
          Container(
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
                  'Start Date:',
                  style: courierText.bodyMedium?.copyWith(color: Colors.white),
                ),
                // Date picker placeholder logic would go here
                const SizedBox(height: 16),
                Text(
                  'End Date:',
                  style: courierText.bodyMedium?.copyWith(color: Colors.white),
                ),
                // Date picker placeholder logic
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
                    onPressed: () {
                      // Implement bulk upload logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Bulk Upload Feature Coming Soon')),
                      );
                    },
                    child: Text(
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
          ),
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
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
            side: const BorderSide(color: Colors.white)),
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
            child: Text('CANCEL', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('SAVE', style: TextStyle(color: primaryCyan)),
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
    // Basic category selection handling inside dialog would require stateful builder or simple ID input for now
    // For simplicity in this iteration, we'll use text input for name and price
    // A dropdown for categories would require passing the categories list to this method

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
              // Category ID input as placeholder for Dropdown
              if (product == null)
                TextField(
                  onChanged: (val) {
                    // Logic to store selected category ID
                  },
                  style: courierText.bodyMedium?.copyWith(color: Colors.white),
                  decoration: _inputDecoration('Category ID (Placeholder)'),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('CANCEL', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('SAVE', style: TextStyle(color: primaryCyan)),
            onPressed: () {
              // Parsing and saving logic
              final price = int.tryParse(priceCtrl.text) ?? 0;
              if (product == null) {
                // Needs category ID. For now we just close or mock.
                // Real implementation needs a DropdownButtonFormField<String> with categories.
                // We will skip actual save implementation here to focus on UI.
                Navigator.pop(context);
              } else {
                _notifier.updateProduct(product.id!, nameCtrl.text, price);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCategory(CategoryModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.white)),
        title: Text('DELETE CATEGORY',
            style: customTextTheme.titleLarge
                ?.copyWith(color: Colors.white, fontFamily: 'Kenzo')),
        content: Text('Are you sure you want to delete ${item.name}?',
            style: courierText.bodyMedium?.copyWith(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('CANCEL', style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              _notifier.deleteCategory(item.id!);
              Navigator.pop(context);
            },
            child: Text('DELETE', style: TextStyle(color: Colors.red)),
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
            side: const BorderSide(color: Colors.white)),
        title: Text('DELETE PRODUCT',
            style: customTextTheme.titleLarge
                ?.copyWith(color: Colors.white, fontFamily: 'Kenzo')),
        content: Text('Are you sure you want to delete ${item.name}?',
            style: courierText.bodyMedium?.copyWith(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('CANCEL', style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              _notifier.deleteProduct(item.id!);
              Navigator.pop(context);
            },
            child: Text('DELETE', style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }
}
