// Theme Colors:
// Primary: Color(0xFFFF8F00) - Orange
// Secondary: Color(0xFF795548) - Brown
// Background: Colors.white
// Error: Colors.red

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> toggleFavorite(Map<String, dynamic> recipe) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(recipe['title']);

      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.delete();
      } else {
        await docRef.set({
          ...recipe,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid,
        });
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }

  Stream<bool> isFavoriteStream(String recipeTitle) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(false);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(recipeTitle)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Stream<QuerySnapshot> getFavorites() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
