class Recipe {
  final String id;
  final String title;
  final List<String> ingredients;
  final String instructions;
  final String imageUrl;

  Recipe({required this.id, required this.title, required this.ingredients, required this.instructions, required this.imageUrl});

  factory Recipe.fromMap(String id, Map<String, dynamic> data) {
    return Recipe(
      id: id,
      title: data['title'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      instructions: data['instructions'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'imageUrl': imageUrl,
    };
  }
}