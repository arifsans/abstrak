import 'package:abstrak/base/api_state.dart';
import 'package:abstrak/model/catalog_models.dart';
import 'package:abstrak/repository/catalog_repo.dart';
import 'package:flutter/material.dart';

class CatalogNotifier extends ChangeNotifier {
  final CatalogRepo _repo = CatalogRepo();

  final ValueNotifier<ApiState<List<CategoryModel>>> categories =
      ValueNotifier(ApiState(status: ApiStatus.initial, data: []));
  
  final ValueNotifier<ApiState<List<ProductModel>>> products =
      ValueNotifier(ApiState(status: ApiStatus.initial, data: []));
      
  final ValueNotifier<ApiState<InventoryStatsModel>> stats =
      ValueNotifier(ApiState(status: ApiStatus.initial));

  Future<void> getCategories() async {
    categories.value = ApiState(status: ApiStatus.loading, data: categories.value.data);
    final result = await _repo.getCategories();
    categories.value = ApiState(status: ApiStatus.success, data: result);
  }

  Future<bool> createCategory(String name, String description) async {
    final newCategory = CategoryModel(name: name, description: description);
    bool success = await _repo.createCategory(newCategory);
    if (success) await getCategories();
    return success;
  }

  Future<bool> updateCategory(String id, String name, String description) async {
    final updatedCategory = CategoryModel(id: id, name: name, description: description);
    bool success = await _repo.updateCategory(id, updatedCategory);
    if (success) await getCategories();
    return success;
  }

  Future<bool> deleteCategory(String id) async {
    bool success = await _repo.deleteCategory(id);
    if (success) await getCategories();
    return success;
  }

  Future<void> getProducts() async {
    products.value = ApiState(status: ApiStatus.loading, data: products.value.data);
    final result = await _repo.getProducts();
    products.value = ApiState(status: ApiStatus.success, data: result);
  }

  Future<bool> createProduct(ProductModel product) async {
    bool success = await _repo.createProduct(product);
    if (success) await getProducts();
    return success;
  }

  Future<bool> updateProduct(String id, String name, int price, {String? categoryId}) async {
    final product = ProductModel(id: id, name: name, price: price, categoryId: categoryId);
    bool success = await _repo.updateProduct(id, product);
    if (success) await getProducts();
    return success;
  }

  Future<bool> deleteProduct(String id) async {
    bool success = await _repo.deleteProduct(id);
    if (success) await getProducts();
    return success;
  }

  Future<void> getStats() async {
    stats.value = ApiState(status: ApiStatus.loading);
    final result = await _repo.getStats();
    stats.value = ApiState(status: ApiStatus.success, data: result);
  }

  Future<bool> bulkUpload(int productId, List<String> codes) async {
    // Deduplicate codes before uploading
    final uniqueCodes = codes.toSet().toList();
    bool success = await _repo.bulkUpload(productId, uniqueCodes);
    if (success) {
      await getStats();
      await getInventoryItems(); // Refresh inventory list
    }
    return success;
  }

  // --- Inventory Items with Pagination and Filter ---
  final ValueNotifier<ApiState<List<InventoryItemModel>>> inventoryItems =
      ValueNotifier(ApiState(status: ApiStatus.initial, data: []));
  
  int _inventoryCurrentPage = 1;
  int _inventoryLastPage = 1;
  String? _inventoryProductFilter;
  bool get hasMoreInventoryItems => _inventoryCurrentPage < _inventoryLastPage;

  void setInventoryProductFilter(String? productId) {
    _inventoryProductFilter = productId;
    getInventoryItems();
  }

  Future<void> getInventoryItems() async {
    _inventoryCurrentPage = 1;
    inventoryItems.value = ApiState(status: ApiStatus.loading, data: []);
    
    final result = await _repo.getInventoryItems(page: 1, productId: _inventoryProductFilter);
    if (result != null) {
      final items = (result['data'] as List?)
          ?.map((json) => InventoryItemModel.fromJson(json))
          .toList() ?? [];
      _inventoryLastPage = result['last_page'] ?? 1;
      inventoryItems.value = ApiState(status: ApiStatus.success, data: items);
    } else {
      inventoryItems.value = ApiState(status: ApiStatus.error, error: 'Failed to load inventory');
    }
  }

  Future<void> loadMoreInventoryItems() async {
    if (!hasMoreInventoryItems) return;
    
    _inventoryCurrentPage++;
    final result = await _repo.getInventoryItems(page: _inventoryCurrentPage, productId: _inventoryProductFilter);
    if (result != null) {
      final newItems = (result['data'] as List?)
          ?.map((json) => InventoryItemModel.fromJson(json))
          .toList() ?? [];
      final currentItems = inventoryItems.value.data ?? [];
      inventoryItems.value = ApiState(
        status: ApiStatus.success,
        data: [...currentItems, ...newItems],
      );
    }
  }
}

final catalogNotifier = CatalogNotifier();
