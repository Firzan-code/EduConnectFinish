import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek_uts/models/quote_model.dart';

class QuoteService {
  static Future<QuoteModel> fetchQuote() async {
    // 1. Ganti ke API DummyJSON (Aman untuk Chrome/Web)
    final url = Uri.parse("https://dummyjson.com/quotes/random");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // 2. API ini mengembalikan OBJECT {}, bukan LIST []
        // Jadi langsung decode saja tanpa [0]
        final data = jsonDecode(response.body);

        return QuoteModel.fromJson(data);
      } else {
        throw Exception("Gagal mengambil quote");
      }
    } catch (e) {
      // Fallback jika internet mati, biar aplikasi tetap cantik
      return QuoteModel(
        text: "Keep pushing code, errors are just stepping stones.",
        author: "Developer Semangat",
      );
    }
  }
}
