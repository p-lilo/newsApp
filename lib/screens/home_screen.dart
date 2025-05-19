import 'package:flutter/material.dart';

import '../models/news_model.dart';
import '../services/api_service.dart';
import 'news_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Article>> articlesFuture;

  @override
  void initState() {
    super.initState();
    final newsService = NewsService();
    articlesFuture = newsService.fetchNews().then(
          (newsResponse) => newsResponse.articles,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 32,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              hintText: "search",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              suffixIcon: Icon(Icons.search, color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFF0F1FA)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.deepPurple, width: 2),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(0xFFFF3A44),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.notifications, color: Colors.white),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Article>>(
        future: articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error loading news"));
          }
          final articles = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text("Latest News", style: TextStyle(fontSize: 18)),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: TextButton(
                          onPressed: () {
                            NewsService();
                          },
                          child: Row(children: [
                            Text(
                              "See all",
                              style: TextStyle(
                                  color: Color(0xFF0080FF), fontSize: 16),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: (Color(0xFF0080FF)),
                              size: 15,
                            )
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: articles
                          .take(5)
                          .map((article) => newsCard(article))
                          .toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ["Healthy", "Technology", "Finance", "Arts"]
                          .map(
                            (category) => Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: SizedBox(
                                width: 120,
                                height: 40,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: category == "Healthy"
                                        ? Color(0xFFFF3A44)
                                        : Colors.white,
                                    foregroundColor: category == "Healthy"
                                        ? Colors.white
                                        : Colors.black,
                                    side: BorderSide(
                                      color: category == "Healthy"
                                          ? Colors.transparent
                                          : Color(0xffF0F1FA),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        16,
                                      ),
                                    ),
                                    textStyle: TextStyle(fontSize: 14),
                                  ),
                                  child: Text(category),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: articles
                        .take(3)
                        .map((article) => secCards(article))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.red,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget newsCard(Article article) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetails(article: article),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 321,
            height: 240,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    article.urlToImage ?? '',
                    width: 321,
                    height: 240,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey,
                      width: 321,
                      height: 240,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 321,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Text(
                        "by ${article.author ?? 'Unknown'}",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      SizedBox(height: 10),
                      Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        article.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget secCards(Article article) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetails(article: article),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 345,
            height: 128,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    article.urlToImage ?? '',
                    width: 345,
                    height: 128,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey,
                      width: 345,
                      height: 128,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 345,
                  height: 128,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            article.author ?? "Unknown",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            article.publishedAt,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
