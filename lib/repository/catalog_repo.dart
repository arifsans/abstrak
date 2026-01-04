import 'dart:convert';
import 'package:abstrak/base/api.dart';
import 'package:abstrak/model/catalog_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatalogRepo {
  Future<Map<String, String>> _getHeaders() async {
    var prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('token') ?? '';
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
  }

  // --- Categories ---
  Future<List<CategoryModel>> getCategories() async {
    try {
      var res = await ApiConnection().apiCall(
        method: ApiMethod.GET,
        path: 'categories',
        headers: await _getHeaders(),
      );

      if (res != null && res.statusCode == 200) {
        var data = jsonDecode(res.body)['data'] as List;
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error getting categories: $e');
    }
    return [];
  }

  Future<bool> createCategory(CategoryModel category) async {
    try {
      var res = await ApiConnection().apiCall(
        method: ApiMethod.POST,
        path: 'categories',
        headers: await _getHeaders(),
        body: category.toJson(),
      );
      return res != null && res.statusCode == 201;
    } catch (e) {
      print('Error creating category: $e');
      return false;
    }
  }

  Future<bool> updateCategory(String id, CategoryModel category) async {
    try {
      var res = await ApiConnection().apiCall(
        method: ApiMethod.PUT,
        path: 'categories/$id',
        headers: await _getHeaders(),
        body: category.toJson(),
      );
      return res != null && res.statusCode == 200;
    } catch (e) {
      print('Error updating category: $e');
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      var res = await ApiConnection().apiCall(
        method: ApiMethod.DELETE,
        path: 'categories/$id',
        headers: await _getHeaders(),
      );
      return res != null && res.statusCode == 200;
    } catch (e) {
      print('Error deleting category: $e');
      return false;
    }
  }

  // --- Products ---
  Future<List<ProductModel>> getProducts() async {
    try {
      var res = await ApiConnection().apiCall(
        method: ApiMethod.GET,
        path: 'products',
        headers: await _getHeaders(),
      );

      if (res != null && res.statusCode == 200) {
        var data = jsonDecode(res.body)['data'] as List;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error getting products: $e');
    }
    return [];
  }

  Future<bool> createProduct(ProductModel product) async {
    try {
      var res = await ApiConnection().apiCall(
        method: ApiMethod.POST,
        path: 'products',
        headers: await _getHeaders(),
        body: product.toJson(),
      );
      return res != null && res.statusCode == 201;
    } catch (e) {
      print('Error creating product: $e');
      return false;
    }
  }

  Future<bool> updateProduct(String id, ProductModel product) async {
    try {
      var res = await ApiConnection().apiCall(
        method: ApiMethod.PUT,
        path: 'products/$id',
        headers: await _getHeaders(),
        body: product.toJson(),
      );
      return res != null && res.statusCode == 200;
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      var res = await ApiConnection().apiCall(
        method: ApiMethod.DELETE,
        path: 'products/$id',
        headers: await _getHeaders(),
      );
      return res != null && res.statusCode == 200;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }

  // --- Inventory ---
  Future<InventoryStatsModel?> getStats() async {
    try {
      var res = await ApiConnection().apiCall(
        method: ApiMethod.GET,
        path: 'inventory/stats',
        headers: await _getHeaders(),
      );

      if (res != null && res.statusCode == 200) {
        return InventoryStatsModel.fromJson(jsonDecode(res.body));
      }
    } catch (e) {
      print('Error getting stats: $e');
    }
    return null;
  }

  Future<bool> bulkUpload(int productId, List<String> codes) async {
    try {
      var res = await ApiConnection().apiCall(
        method: ApiMethod.POST,
        path: 'inventory/bulk-upload',
        headers: await _getHeaders(),
        body: {
          'product_id': productId,
          'codes': codes, // ApiConnection POST uses jsonEncode, so List<String> is fine
        },
      );
      return res != null && res.statusCode == 201;
    } catch (e) {
      print('Error uploading inventory: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getInventoryItems({int page = 1, int perPage = 20, String? productId}) async {
    try {
      String path = 'inventory?page=$page&per_page=$perPage';
      if (productId != null && productId.isNotEmpty) {
        path += '&product_id=$productId';
      }
      var res = await ApiConnection().apiCall(
        method: ApiMethod.GET,
        path: path,
        headers: await _getHeaders(),
      );

      if (res != null && res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      print('Error getting inventory items: $e');
    }
    return null;
  }
}
