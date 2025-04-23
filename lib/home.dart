import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'pages/favorites_page.dart';
import 'services/favorite_service.dart';
import 'services/recipe_service.dart';
import 'widgets/recipe_form.dart';

class Generator extends StatefulWidget {
  const Generator({super.key});

  @override
  State<StatefulWidget> createState() {
    return GeneratorState();
  }
}

class GeneratorState extends State<Generator> {
  String generatedText = '';
  bool isLoading = false;
  final TextEditingController _controller = TextEditingController();
  final FavoriteService _favoriteService = FavoriteService();
  final RecipeService _recipeService = RecipeService();
  Map<String, dynamic>? _currentRecipe;

  String selectedComplexity = 'Any';
  String selectedTime = 'Any';

  final List<String> complexityLevels = ['Any', 'Easy', 'Medium', 'Hard'];
  final List<String> timeRanges = [
    'Any',
    '15 minutes',
    '30 minutes',
    '45 minutes',
    '1 hour',
    '1+ hour'
  ];

  late FocusNode _ingredientsFocusNode;

  @override
  void initState() {
    super.initState();
    _recipeService.initialize();
    _ingredientsFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _ingredientsFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _generateText() async {
    setState(() {
      isLoading = true;
      generatedText = '';
    });

    try {
      _currentRecipe = await _recipeService.generateRecipe(
        _controller.text,
        selectedComplexity,
        selectedTime,
      );

      setState(() {
        generatedText = _formatRecipeText(_currentRecipe!);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        generatedText = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  String _formatRecipeText(Map<String, dynamic> recipe) {
    final StringBuffer buffer = StringBuffer();

    // Title is displayed separately in the UI

    buffer.writeln('🕒 Cooking Time:');
    buffer.writeln(recipe['cookingTime']);
    buffer.writeln();

    buffer.writeln('📊 Complexity:');
    buffer.writeln(recipe['complexity']);
    buffer.writeln();

    buffer.writeln('🥘 Ingredients:');
    for (String ingredient in recipe['ingredients']) {
      buffer.writeln('• $ingredient');
    }
    buffer.writeln();

    buffer.writeln('📝 Instructions:');
    buffer.writeln(recipe['instructions']);

    if (recipe['tips']?.isNotEmpty ?? false) {
      buffer.writeln();
      buffer.writeln('💡 Tips:');
      buffer.writeln(recipe['tips']);
    }

    return buffer.toString();
  }

  Widget _buildRecipeDisplay() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_currentRecipe != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    _currentRecipe!['title'] ?? '',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StreamBuilder<bool>(
                  stream: _favoriteService
                      .isFavoriteStream(_currentRecipe!['title']),
                  builder: (context, snapshot) {
                    final isFavorite = snapshot.data ?? false;
                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () =>
                          _favoriteService.toggleFavorite(_currentRecipe!),
                    );
                  },
                ),
              ],
            ),
          SelectableText(
            generatedText,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: const [
              Icon(Icons.restaurant_menu, size: 30, color: Color(0xFFFF8F00)),
              SizedBox(width: 10),
              Text(
                'Chef AI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Color(0xFF795548),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          iconTheme: const IconThemeData(color: Color(0xFF795548)),
          actions: [
            if (_currentRecipe != null)
              StreamBuilder<bool>(
                stream:
                    _favoriteService.isFavoriteStream(_currentRecipe!['title']),
                builder: (context, snapshot) {
                  final isFavorite = snapshot.data ?? false;
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Color(0xFF795548),
                    ),
                    onPressed: () {
                      _favoriteService.toggleFavorite(_currentRecipe!);
                    },
                  );
                },
              ),
            IconButton(
              icon: const Icon(Icons.logout, color: Color(0xFF795548)),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFFFF8F00)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.restaurant_rounded,
                          size: 60, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        'Chef AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDrawerItem(
                    Icons.home, 'Home', () => Navigator.pop(context)),
                _buildDrawerItem(
                  Icons.favorite,
                  'Favorites',
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavoritesPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  Icons.logout,
                  'Logout',
                  () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Focus(
                    child: RecipeForm(
                      controller: _controller,
                      selectedComplexity: selectedComplexity,
                      selectedTime: selectedTime,
                      complexityLevels: complexityLevels,
                      timeRanges: timeRanges,
                      onComplexityChanged: (value) =>
                          setState(() => selectedComplexity = value),
                      onTimeChanged: (value) =>
                          setState(() => selectedTime = value),
                      onSubmit: _generateText,
                      isLoading: isLoading,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: isLoading
                            ? const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFFF8F00),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Cooking up your recipe...',
                                      style: TextStyle(
                                        color: Color(0xFF795548),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : _buildRecipeDisplay(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF795548)),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF795548),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
