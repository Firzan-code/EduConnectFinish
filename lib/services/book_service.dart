import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek_uts/models/book_model.dart';

class BookService {
  // Hapus variabel _baseUrl static constant yang lama

  // Tambahkan parameter {String query}
  static Future<List<BookModel>> fetchBooks({
    String query = "technology",
  }) async {
    try {
      // Encode query agar spasi atau karakter khusus aman (misal: "harry potter")
      final encodedQuery = Uri.encodeComponent(query);

      final url = Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=$encodedQuery',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Cek jika 'items' null (tidak ada buku ditemukan)
        if (data['items'] == null) {
          return [];
        }

        final List<dynamic> items = data['items'];

        return items.map((json) => BookModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }
}
