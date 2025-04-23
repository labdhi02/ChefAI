import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/favorite_service.dart';
import '../widgets/login_widgets.dart';

class FavoritesPage extends StatelessWidget {
  final FavoriteService _favoriteService = FavoriteService();

  FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
        backgroundColor: ThemeColors.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange[50]!, Colors.brown[50]!],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _favoriteService.getFavorites(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No favorite recipes yet'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final recipe =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: ThemeColors.primary,
                      child: Icon(Icons.restaurant_menu, color: Colors.white),
                    ),
                    title: Text(
                      recipe['title'] ?? 'Untitled Recipe',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(Icons.timer, size: 16),
                        SizedBox(width: 4),
                        Text(recipe['cookingTime'] ?? 'Time not specified'),
                        SizedBox(width: 16),
                        Icon(Icons.bar_chart, size: 16),
                        SizedBox(width: 4),
                        Text(recipe['complexity'] ?? 'Not specified'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => _favoriteService.toggleFavorite(recipe),
                    ),
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSection('Ingredients',
                                recipe['ingredients'] as List<dynamic>?),
                            SizedBox(height: 16),
                            _buildSection(
                                'Instructions', recipe['instructions']),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(String title, dynamic content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ThemeColors.primaryDark,
          ),
        ),
        SizedBox(height: 8),
        if (content is List)
          ...content.map((item) => Padding(
                padding: EdgeInsets.only(left: 16, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(child: Text(item.toString())),
                  ],
                ),
              ))
        else if (content is String)
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(content),
          ),
      ],
    );
  }
}
