class Recipe {
  const Recipe({
    required this.title,
    required this.description,
    required this.ingredients,
  });

  final String title;
  final String description;
  final List<String> ingredients;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'] as String,
      description: json['description'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((ingredient) => ingredient as String)
          .toList(growable: false),
    );
  }
}
