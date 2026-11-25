import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/recipe.dart';

void main() {
  runApp(const RecipeFetcherApp());
}

class RecipeFetcherApp extends StatelessWidget {
  const RecipeFetcherApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF287A5A);

    return MaterialApp(
      title: 'Recipe Book',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          surface: const Color(0xFFF7F8F5),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8F5),
      ),
      home: const RecipeListPage(),
    );
  }
}

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  late final Future<List<Recipe>> _recipesFuture = _loadRecipes();

  Future<List<Recipe>> _loadRecipes() async {
    final jsonString = await rootBundle.loadString('assets/recipes.json');
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final recipesJson = json['recipes'] as List<dynamic>;

    return recipesJson
        .map((recipe) => Recipe.fromJson(recipe as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recipe Book',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find your next favorite',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Simple ideas for something delicious.',
                    style: TextStyle(fontSize: 15, color: Color(0xFF68736D)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Recipe>>(
                future: _recipesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Could not load recipes: ${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final recipes = snapshot.data!;
                  return ListView.separated(
                    key: const ValueKey('recipe-list'),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: recipes.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return Card(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: const BorderSide(color: Color(0xFFE9EDE8)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAF4EE),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  _iconForRecipe(index),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.title,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      recipe.description,
                                      style: const TextStyle(
                                        height: 1.4,
                                        color: Color(0xFF68736D),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: recipe.ingredients
                                          .map(
                                            (ingredient) => DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF2F5F1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 9,
                                                      vertical: 5,
                                                    ),
                                                child: Text(
                                                  ingredient,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF526159),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForRecipe(int index) {
    const icons = [
      Icons.ramen_dining,
      Icons.eco_outlined,
      Icons.local_drink_outlined,
      Icons.set_meal_outlined,
      Icons.dinner_dining,
      Icons.soup_kitchen_outlined,
      Icons.icecream_outlined,
    ];

    return icons[index % icons.length];
  }
}
