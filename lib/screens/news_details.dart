import 'package:flutter/material.dart';
import '../models/news_model.dart';

class NewsDetails extends StatelessWidget {
  final Article article;

  const NewsDetails({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.all(20),
              children: [
                Image.network(
                  article.urlToImage ?? '',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.publishedAt,
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      SizedBox(height: 5),
                      Text(
                        article.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Published by ${article.author ?? "Unknown"}",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  article.content ?? "No content available.",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            Positioned(
              left: 20,
              top: 20,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
