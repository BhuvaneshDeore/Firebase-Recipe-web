import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_edit_recipe.dart';

class RecipeDetail extends StatelessWidget {
  final String recipeId;
  const RecipeDetail({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance.collection('recipes').doc(recipeId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe'),
        actions: [
          IconButton(onPressed: () async {
            final data = (await docRef.get()).data();
            if (data != null) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditRecipe(recipeId: recipeId)));
            }
          }, icon: const Icon(Icons.edit)),
          IconButton(onPressed: () async {
            final confirm = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
              title: const Text('Delete?'),
              content: const Text('Are you sure you want to delete this recipe?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
              ],
            ));
            if (confirm == true) {
              await docRef.delete();
              if (context.mounted) Navigator.pop(context);
            }
          }, icon: const Icon(Icons.delete)),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: docRef.get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading recipe'));
          if (!snapshot.hasData || !snapshot.data!.exists) return const Center(child: Text('Recipe not found'));
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final title = data['title'] ?? '';
          final ingredients = List<String>.from(data['ingredients'] ?? []);
          final instructions = data['instructions'] ?? '';
          final imageUrl = data['imageUrl'] ?? '';
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl.isNotEmpty) Image.network(imageUrl, height: 220, width: double.infinity, fit: BoxFit.cover),
                const SizedBox(height: 12),
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Ingredients', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                ...ingredients.map((i) => Text('• $i')).toList(),
                const SizedBox(height: 12),
                Text('Instructions', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(instructions),
              ],
            ),
          );
        },
      ),
    );
  }
}