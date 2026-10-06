import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/sparepart.dart';

class ApiService {
  // Auto detect platform: Web/Desktop pakai 127.0.0.1, Emulator Android pakai 10.0.2.2
  static String baseUrl = kIsWeb ? 'http://127.0.0.1:8000/api' : 'http://10.0.2.2:8000/api';

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // GET: Fetch all spareparts (with optional search or category)
  static Future<List<Sparepart>> getSpareparts({String? search, String? category}) async {
    Uri uri = Uri.parse('$baseUrl/spareparts');
    
    Map<String, String> queryParams = {};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (category != null && category.isNotEmpty && category != 'Semua') queryParams['category'] = category;

    if (queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];
      return data.map((item) => Sparepart.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data sparepart: ${response.statusCode}');
    }
  }

  // GET: Fetch single sparepart by ID
  static Future<Sparepart> getSparepartById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/spareparts/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return Sparepart.fromJson(body['data']);
    } else {
      throw Exception('Sparepart tidak ditemukan (HTTP ${response.statusCode})');
    }
  }

  // POST: Create new sparepart
  static Future<Sparepart> createSparepart(Sparepart part) async {
    final response = await http.post(
      Uri.parse('$baseUrl/spareparts'),
      headers: _headers,
      body: jsonEncode(part.toJson()),
    );

    if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return Sparepart.fromJson(body['data']);
    } else if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      final errors = body['errors'];
      String errorMsg = 'Validasi gagal: ';
      if (errors != null && errors is Map) {
        errorMsg += errors.values.map((e) => (e as List).join(', ')).join('; ');
      }
      throw Exception(errorMsg);
    } else {
      throw Exception('Gagal menambahkan sparepart: ${response.body}');
    }
  }

  // PUT: Update existing sparepart
  static Future<Sparepart> updateSparepart(int id, Sparepart part) async {
    final response = await http.put(
      Uri.parse('$baseUrl/spareparts/$id'),
      headers: _headers,
      body: jsonEncode(part.toJson()),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return Sparepart.fromJson(body['data']);
    } else if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      final errors = body['errors'];
      String errorMsg = 'Validasi gagal: ';
      if (errors != null && errors is Map) {
        errorMsg += errors.values.map((e) => (e as List).join(', ')).join('; ');
      }
      throw Exception(errorMsg);
    } else {
      throw Exception('Gagal memperbarui sparepart: ${response.body}');
    }
  }

  // DELETE: Remove sparepart
  static Future<bool> deleteSparepart(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/spareparts/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal menghapus sparepart (HTTP ${response.statusCode})');
    }
  }
}
