class BookModel {
  final String title;
  final String author;
  final String description;
  final String thumbnailUrl;

  BookModel({
    required this.title,
    required this.author,
    required this.description,
    required this.thumbnailUrl,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];

    // Gambar default placeholder
    String image = 'https://via.placeholder.com/150';

    if (volumeInfo['imageLinks'] != null &&
        volumeInfo['imageLinks']['thumbnail'] != null) {
      String rawUrl = volumeInfo['imageLinks']['thumbnail'];

      // --- PERBAIKAN DI SINI ---
      // Kita pakai Uri.encodeComponent()
      // Ini wajib agar simbol '&' di link Google tidak merusak link Proxy
      String encodedUrl = Uri.encodeComponent(rawUrl);

      // Gunakan 'wsrv.nl' (versi pendek weserv) agar lebih cepat
      image = 'https://wsrv.nl/?url=$encodedUrl&w=200&output=jpg';
      // -------------------------
    }

    // Handle Author
    String authors = 'Unknown Author';
    if (volumeInfo['authors'] != null) {
      authors = (volumeInfo['authors'] as List).join(", ");
    }

    return BookModel(
      title: volumeInfo['title'] ?? 'No Title',
      author: authors,
      description: volumeInfo['description'] ?? 'No description available.',
      thumbnailUrl: image,
    );
  }
}
