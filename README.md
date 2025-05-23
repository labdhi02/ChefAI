# 🍴 ChefAI

ChefAI is a Flutter-based application designed to make cooking easier and more enjoyable. Using AI, the app generates recipes based on available ingredients or user preferences. It's your smart kitchen assistant, combining innovation with simplicity. 🧑‍🍳✨

## 🚀 Getting Started

This project is a starting point for ChefAI, a Flutter application.

## 🌟 Features

- 🤖 **AI-Generated Recipes**: Get recipes instantly based on ingredients you have.  
- 🔍 **Ingredient Search**: Enter ingredients, and ChefAI suggests recipes.  
- 🗂️ **Categories**: Explore recipes by time-level and difficulty.  
- 📜 **Step-by-Step Instructions**: Easy-to-follow directions for each recipe.  
- ❤️ **Favorites**: Save your favorite recipes for quick access.  

## ⚙️ Installation

### Prerequisites

- 🛠️ Flutter SDK installed ([Installation Guide](https://docs.flutter.dev/get-started/install))  
- 🧰 Dart installed  
- 💻 Code editor (e.g., Visual Studio Code or Android Studio)  

## 📸 Screenshots  

<table>
  <tr>
    <td><strong>Login screen</strong></td>
    <td><strong>Craete account Screen</strong></td>
    <td><strong>Recipe by Ingredients</strong></td>
    <td><strong>Favourites recipes</strong></td>
  </tr>
  <tr>
    <td><img src="https://github.com/labdhi02/ChefAI/blob/main/Screenshot%202025-04-23%20104837.png" alt="Home Screen" width="200"/></td>
    <td><img src="https://github.com/labdhi02/ChefAI/blob/main/Screenshot%202025-04-23%20104953.png" alt="Craete account Screen" width="200"/></td>
    <td><img src="https://github.com/labdhi02/ChefAI/blob/main/Screenshot%202025-04-23%20105320.png" alt="Recipe by Ingredients" width="200"/></td>
    <td><img src="https://github.com/labdhi02/ChefAI/blob/main/Screenshot%202025-04-23%20105341.png" alt="Favourites recipes" width="200"/></td>
  </tr>
</table>

## 🧑‍🍳 Usage

1. Launch the app on your device or emulator.  
2. Use the **Ingredient Search** feature to input your ingredients.  
3. Browse recipes generated by ChefAI.  
4. Follow step-by-step instructions to cook delicious meals. 🥗🍛  
5. Explore different recipe categories and save your favorites for easy access later. ❤️  

## 💻 Tech Stack

- 🐦 **Flutter**: Framework for building natively compiled applications.  
- 🎯 **Dart**: Programming language for Flutter.  
- 🌐 **API Integration**: To fetch recipe data and ingredients.  
- 🧩 **State Management**: Provider (or another state management solution of your choice).  

## 🌐 API Integration

ChefAI integrates with external APIs to fetch recipes and ingredient data. To configure your API key:

1. Get an API key from your chosen recipe API provider.  
2. Add the key to your project in a constants file:  
   ```dart
   const String API_KEY = 'your_api_key_here';
