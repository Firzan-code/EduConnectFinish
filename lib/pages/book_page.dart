import 'package:flutter/material.dart';
import 'package:projek_uts/models/book_model.dart';
import 'package:projek_uts/services/book_service.dart';
// 1. IMPORT FILE DETAIL YANG BARU DIBUAT
import 'package:projek_uts/pages/detail_book_page.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late Future<List<BookModel>> _booksFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _booksFuture = BookService.fetchBooks(query: "programming");
  }

  void _searchBooks() {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _booksFuture = BookService.fetchBooks(query: _searchController.text);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perpustakaan Digital"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // --- SEARCH BAR ---
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari judul buku...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchBooks,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _searchBooks(),
            ),
          ),

          // --- DAFTAR BUKU ---
          Expanded(
            child: FutureBuilder<List<BookModel>>(
              future: _booksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "Buku tidak ditemukan",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final books = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];

                    // 2. BUNGKUS CARD DENGAN INKWELL AGAR BISA DIKLIK
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // NAVIGASI KE HALAMAN DETAIL
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailBookPage(book: book),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Hero(
                                  tag: book.thumbnailUrl, // Animasi hero
                                  child: Image.network(
                                    book.thumbnailUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, error, stack) =>
                                        const Icon(
                                          Icons.broken_image,
                                          size: 50,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    book.author,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
