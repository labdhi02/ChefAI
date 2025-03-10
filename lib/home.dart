import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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
  late final GenerativeModel _model;
  final TextEditingController _controller = TextEditingController();
  late Future<void> _apiKeyFuture;

  @override
  void initState() {
    super.initState();
    _apiKeyFuture = _getAPIkey();
  }

  Future<void> _getAPIkey() async {
    // Directly assign the API key
    var apikey = 'AIzaSyDhdSEMxcJQ-PelciGQ9_H-J73kKvQQWmY';

    _model = GenerativeModel(
      model: 'models/gemini-1.5-pro', // Use the Gemini 1.5 Pro model
      apiKey: apikey,
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      ],
    );
  }

  void _generateText() async {
    setState(() {
      isLoading = true;
      generatedText = '';
    });

    try {
      // Step 1: Preprocess the user input
      String preprocessingPrompt =
          "You will be provided text with ingredients from a user that hopes to cook something from this. Please process the text provided by the user and return a list in the following format: Ingredient A, Ingredient B, Ingredient C, .... If no ingredients that can be used to realistically create food are provided, please return 'None'. Please return no additional text apart from this list in your response. Please find the user provided text here: ";

      String preprocessingInput = preprocessingPrompt + _controller.text;
      final preContent = [Content.text(preprocessingInput)];
      final ingredientList = await _model.generateContent(preContent);

      // Step 2: Generate the recipe
      String prompt =
          "You are an expert cook with detailed knowledge of making recipes. Generate a response in this exact format:\n\nRecipe Name:\n[Name]\n\nCooking Time:\n[Time]\n\nComplexity:\n[Easy/Medium/Hard]\n\nIngredients:\n[List]\n\nSteps:\n[Numbered steps]";

      String finalInput = prompt + ingredientList.text!;
      final content = [Content.text(finalInput)];
      final recipe = await _model.generateContent(content);

      setState(() {
        generatedText = recipe.text!;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        generatedText = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A237E), Color(0xFF64B5F6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              AppBar(
                title: Row(
                  children: [
                    Icon(Icons.restaurant_menu, size: 30),
                    SizedBox(width: 10),
                    Text(
                      'ChefAI',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.shopping_basket,
                                  color: Color(0xFF1A237E)),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Enter ingredients (comma separated)',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              FutureBuilder<void>(
                                future: _apiKeyFuture,
                                builder: (context, snapshot) {
                                  return ElevatedButton.icon(
                                    icon: Icon(Icons.restaurant),
                                    label: Text(
                                      snapshot.connectionState ==
                                              ConnectionState.done
                                          ? 'Generate Recipe'
                                          : 'Loading...',
                                    ),
                                    onPressed: snapshot.connectionState ==
                                                ConnectionState.done &&
                                            !isLoading
                                        ? _generateText
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF1A237E),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            child: isLoading
                                ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 16),
                                        Text('Cooking up your recipe...'),
                                      ],
                                    ),
                                  )
                                : SingleChildScrollView(
                                    child: SelectableText(
                                      generatedText,
                                      style: TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
