import 'package:flutter/material.dart';
import 'package:projek_uts/models/book_model.dart';

class DetailBookPage extends StatelessWidget {
  final BookModel book;

  // Kita mewajibkan data 'book' dikirim saat halaman ini dibuka
  const DetailBookPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Buku"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. BAGIAN HEADER GAMBAR BESAR
            Container(
              height: 250, // Tinggi header gambar
              decoration: BoxDecoration(
                color: Colors.grey[200], // Background abu-abu
              ),
              child: Center(
                child: Hero(
                  tag: book.thumbnailUrl, // Efek animasi transisi gambar
                  child: Image.network(
                    book.thumbnailUrl,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, error, stack) => const Icon(
                      Icons.broken_image,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),

            // 2. BAGIAN INFORMASI BUKU
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Penulis
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.indigo, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          book.author,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(), // Garis pemisah
                  const SizedBox(height: 16),

                  // Label Deskripsi
                  const Text(
                    "Sinopsis / Deskripsi",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Isi Deskripsi
                  Text(
                    book.description,
                    textAlign: TextAlign.justify, // Teks rata kanan-kiri
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6, // Jarak antar baris biar enak dibaca
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
