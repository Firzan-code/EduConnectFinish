import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/quote_model.dart';
import '../services/api_service.dart';
import '../services/quote_service.dart';
import '../main.dart';
import 'study_page.dart';
import 'book_page.dart'; // Pastikan nama file sesuai

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UserModel> _futureUser;
  late Future<QuoteModel> _futureQuote;

  @override
  void initState() {
    super.initState();
    _futureUser = ApiService.fetchUser();
    _futureQuote = QuoteService.fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UIN Malang'),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () {
              Navigator.of(context).push(createRoute(const StudyPage()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // * USER CARD
              FutureBuilder<UserModel>(
                future: _futureUser,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const _ShimmerCard();
                  } else if (snap.hasError) {
                    return Text('Error: ${snap.error}');
                  } else {
                    final user = snap.data!;
                    return _UserCard(user: user);
                  }
                },
              ),

              const SizedBox(height: 16),

              // * QUOTES CARD
              FutureBuilder<QuoteModel>(
                future: _futureQuote,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const _ShimmerCard();
                  } else if (snap.hasError) {
                    return Text('Error: ${snap.error}');
                  } else {
                    final quote = snap.data!;
                    return _QuoteCard(quote: quote);
                  }
                },
              ),

              const SizedBox(height: 18),

              // * GRID MENU
              const Expanded(child: _InfoGrid()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: accentColor,
        onPressed: () {
          setState(() {
            _futureUser = ApiService.fetchUser();
            _futureQuote = QuoteService.fetchQuote();
          });
        },
        label: const Text('Segarkan'),
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}

// ======================================================
// WIDGETS
// ======================================================

// USER CARD
class _UserCard extends StatelessWidget {
  final UserModel user;
  const _UserCard({required this.user});
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo-hero',
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: primaryColor,
                child: Text(
                  user.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      user.program,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Chip(label: Text('${user.sks} SKS')),
                        const SizedBox(width: 8),
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(user.gpa.toStringAsFixed(2)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// QUOTE CARD
class _QuoteCard extends StatelessWidget {
  final QuoteModel quote;
  const _QuoteCard({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote, size: 30, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '"${quote.text}"\n\n— ${quote.author}',
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// SHIMMER
class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      height: 92,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [Colors.grey.shade300, Colors.grey.shade200],
        ),
      ),
    );
  }
}

// GRID MENU
class _InfoGrid extends StatelessWidget {
  const _InfoGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Kaldik', Icons.calendar_month),
      ('Rektor', Icons.place),
      ('Nilai', Icons.stacked_bar_chart),
      ('Presensi', Icons.check_circle_outline),
      ('Cat PA', Icons.note_alt),
      ('Buku', Icons.book), // <--- Ini target kita
      ('LPBA', Icons.upload_file),
      ('Lainnya', Icons.more_horiz),
    ];

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, i) {
        final (title, icon) = items[i];

        return InkWell(
          borderRadius: BorderRadius.circular(12),

          // --- UBAH BAGIAN ONTAP DI SINI ---
          onTap: () {
            if (title == 'Buku') {
              // Jika yang diklik adalah 'Buku', pindah ke BookPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookPage()),
              );
            } else {
              // Jika menu lain, tetap tampilkan BottomSheet seperti biasa
              showModalBottomSheet(
                context: context,
                builder: (_) => SizedBox(
                  height: 160,
                  child: Center(
                    child: Text(
                      '$title — fitur demo',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
            }
          },

          // ----------------------------------
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: primaryColor.withOpacity(0.12),
                  child: Icon(icon, color: primaryColor),
                ),
                const SizedBox(height: 8),
                Text(title, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }
}
