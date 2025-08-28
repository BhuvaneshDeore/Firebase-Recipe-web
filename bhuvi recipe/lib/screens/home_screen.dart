import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';
import 'add_edit_recipe.dart';
import 'recipe_detail.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final col = FirebaseFirestore.instance.collection('recipes');
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: col.orderBy('title').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading recipes'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No recipes yet. Tap + to add.'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final recipe = Recipe.fromMap(doc.id, doc.data() as Map<String, dynamic>);
              return ListTile(
                title: Text(recipe.title),
                subtitle: Text(recipe.ingredients.join(', '), maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetail(recipeId: recipe.id)));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditRecipe()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}