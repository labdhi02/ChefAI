import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class RecipeService {
  late final GenerativeModel _model;

  Future<void> initialize() async {
    var apikey = 'AIzaSyDrPSbQ3ks0MlbUNl8Xutk-KvnV_Ujli2Q';
    _model = GenerativeModel(
      model: 'models/gemini-1.5-pro',
      apiKey: apikey,
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      ],
    );
  }

  Future<Map<String, dynamic>> generateRecipe(String ingredients,
      String selectedComplexity, String selectedTime) async {
    if (ingredients.trim().isEmpty) {
      throw Exception('Please enter some ingredients');
    }

    try {
      String preprocessingPrompt = """
You are an expert chef. Process these ingredients and return only a clean comma-separated list.
If the ingredients can't make a realistic dish, return 'None'.
Ingredients: $ingredients
""";

      final preContent = [Content.text(preprocessingPrompt)];
      final ingredientList = await _model.generateContent(preContent);

      if (ingredientList.text?.toLowerCase().contains('none') ?? false) {
        throw Exception('Cannot generate a recipe with these ingredients');
      }

      String complexityConstraint = selectedComplexity != 'Any'
          ? "The recipe must be ${selectedComplexity.toLowerCase()} complexity. "
          : "";
      String timeConstraint = selectedTime != 'Any'
          ? "The cooking time should be around $selectedTime. "
          : "";

      String prompt = """
You are an expert Indian chef. Create a vegetarian recipe with these requirements:
$complexityConstraint$timeConstraint
Use these ingredients: ${ingredientList.text}

Return the recipe in exactly this format:

Recipe Name:
[Creative and appealing name]

Cooking Time:
[Realistic time estimate]

Complexity:
[Easy/Medium/Hard]

Ingredients:
[Detailed list with quantities]

Steps:
[Numbered, clear cooking instructions]

Additional Tips:
[Optional cooking tips and variations]
""";

      final content = [Content.text(prompt)];
      final recipe = await _model.generateContent(content);

      if (recipe.text == null || recipe.text!.isEmpty) {
        throw Exception('Failed to generate recipe');
      }

      return _parseRecipeText(recipe.text!);
    } catch (e) {
      throw Exception('Failed to generate recipe: ${e.toString()}');
    }
  }

  Map<String, dynamic> _parseRecipeText(String text) {
    final Map<String, dynamic> recipe = {
      'title': '',
      'cookingTime': '',
      'complexity': '',
      'ingredients': <String>[],
      'instructions': '',
      'tips': '',
      'timestamp': FieldValue.serverTimestamp(),
      'userId': FirebaseAuth.instance.currentUser?.uid,
    };

    final sections = text.split('\n\n');
    String currentSection = '';

    for (var section in sections) {
      section = section.trim();
      if (section.isEmpty) continue;

      if (section.startsWith('Recipe Name:')) {
        recipe['title'] = _extractContent(section);
      } else if (section.startsWith('Cooking Time:')) {
        recipe['cookingTime'] = _extractContent(section);
      } else if (section.startsWith('Complexity:')) {
        recipe['complexity'] = _extractContent(section);
      } else if (section.startsWith('Ingredients:')) {
        recipe['ingredients'] = _extractList(section);
      } else if (section.startsWith('Steps:')) {
        recipe['instructions'] = _formatInstructions(section);
      } else if (section.startsWith('Additional Tips:')) {
        recipe['tips'] = _extractContent(section);
      }
    }

    return recipe;
  }

  String _extractContent(String section) {
    final lines = section.split('\n');
    if (lines.length < 2) return '';
    return lines.sublist(1).join('\n').trim();
  }

  List<String> _extractList(String section) {
    final lines = section.split('\n');
    if (lines.length < 2) return [];
    return lines
        .sublist(1)
        .where((line) => line.trim().isNotEmpty)
        .map((line) => line.trim())
        .toList();
  }

  String _formatInstructions(String section) {
    final lines = section.split('\n');
    if (lines.length < 2) return '';

    return lines
        .sublist(1)
        .where((line) => line.trim().isNotEmpty)
        .map((line) => line.trim())
        .join('\n\n');
  }
}
