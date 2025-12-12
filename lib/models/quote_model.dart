class QuoteModel {
  final String
  text; // Perhatikan: saya pakai nama variabel 'text' biar konsisten
  final String author;

  QuoteModel({required this.text, required this.author});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      // API DummyJSON pakai key 'quote', ZenQuotes pakai 'q'
      // Kita pakai logika '??' biar aman untuk keduanya
      text:
          json['quote'] ??
          json['q'] ??
          json['content'] ??
          'Quote tidak ditemukan',

      // API DummyJSON pakai key 'author', ZenQuotes pakai 'a'
      author: json['author'] ?? json['a'] ?? 'Unknown',
    );
  }
}
