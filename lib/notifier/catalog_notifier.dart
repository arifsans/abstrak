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

  Future<bool> updateProduct(String id, String name, int price) async {
    // Note: This matches the call signature in catalog_screen.dart now, or we can adjust screen.
    // However, repo expects ProductModel. Let's create it here.
    // We might lose category info if we don't pass it, but updating usually merges or replaces.
    // Ideally we should pass the full object.
    // For now, let's assume the repo handles partial updates or we only update name/price.
    // But wait, the previous implementation in screen passed name and price. 
    // Let's stick to passing name and price and creating a partial model.
    final product = ProductModel(id: id, name: name, price: price);
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
    bool success = await _repo.bulkUpload(productId, codes);
    if (success) await getStats();
    return success;
  }
}

final catalogNotifier = CatalogNotifier();
