import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_browser/screen/web_view_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _newsHeadlines = [];
  final String _apiKey = 'e65104bfc9a54080866957d724a2519c';

  @override
  void initState() {
    super.initState();
    _fetchNewsHeadlines();
  }

  Future<void> _fetchNewsHeadlines() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://newsapi.org/v2/top-headlines?country=us&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _newsHeadlines = List<String>.from(
              data['articles'].map((article) => article['title']));
        });
      } else {
        print('Failed to load news: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching news: $e');
    }
  }

  void _performSearch() {
    if (_searchController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewScreen(
            url: 'https://www.google.com/search?q=${_searchController.text}',
          ),
        ),
      );
    }
  }

  void _openUrl(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Browser'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  'https://www.google.com/images/branding/googlelogo/2x/googlelogo_light_color_92x30dp.png',
                  height: 50,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search with Google',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onSubmitted: (value) => _performSearch(),
              ),
              const SizedBox(height: 20),
              const Text('Default Links',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                children: [
                  _buildLinkIcon(
                      'Google', 'https://www.google.com', Icons.search),
                  _buildLinkIcon(
                      'Facebook', 'https://www.facebook.com', Icons.facebook),
                  _buildLinkIcon('YouTube', 'https://www.youtube.com',
                      Icons.video_library),
                  _buildLinkIcon(
                      'Twitter', 'https://www.twitter.com', Icons.share),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Discover',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ..._newsHeadlines.map((headline) => ListTile(
                    title: Text(headline),
                    onTap: () => _openUrl(
                        'https://news.google.com/search?q=${Uri.encodeComponent(headline)}'),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkIcon(String title, String url, IconData icon) {
    return GestureDetector(
      onTap: () => _openUrl(url),
      child: Column(
        children: [
          CircleAvatar(
            child: Icon(icon),
          ),
          const SizedBox(height: 4),
          Text(title),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
