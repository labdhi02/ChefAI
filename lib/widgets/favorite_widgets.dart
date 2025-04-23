import 'package:flutter/material.dart';
import 'login_widgets.dart';

class FavoriteWidgets {
  static AppBar buildAppBar(String title) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: ThemeColors.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: ThemeColors.primary),
    );
  }

  static Widget buildFavoriteCard(
      Map<String, dynamic> recipe, VoidCallback onTap) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          recipe['title'] ?? '',
          style: const TextStyle(
            color: ThemeColors.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          recipe['description'] ?? '',
          style: TextStyle(
            color: ThemeColors.secondary.withOpacity(0.7),
          ),
        ),
        trailing: Icon(
          Icons.favorite,
          color: ThemeColors.primary,
        ),
        onTap: onTap,
      ),
    );
  }

  static Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: ThemeColors.primary,
          ),
          SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: TextStyle(
              color: ThemeColors.secondary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start adding recipes to your favorites',
            style: TextStyle(
              color: ThemeColors.secondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
