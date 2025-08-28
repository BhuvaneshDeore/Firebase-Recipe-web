import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class AddEditRecipe extends StatefulWidget {
  final String? recipeId;
  const AddEditRecipe({super.key, this.recipeId});

  @override
  State<AddEditRecipe> createState() => _AddEditRecipeState();
}

class _AddEditRecipeState extends State<AddEditRecipe> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _ingredients = TextEditingController();
  final _instructions = TextEditingController();
  final _imageUrl = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.recipeId != null) _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    setState(() => _loading = true);
    final doc = await FirebaseFirestore.instance.collection('recipes').doc(widget.recipeId).get();
    final data = doc.data();
    if (data != null) {
      _title.text = data['title'] ?? '';
      _ingredients.text = (data['ingredients'] as List<dynamic>?).map((e) => e.toString()).join(', ');
      _instructions.text = data['instructions'] ?? '';
      _imageUrl.text = data['imageUrl'] ?? '';
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ingredientsList = _ingredients.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    final data = {
      'title': _title.text.trim(),
      'ingredients': ingredientsList,
      'instructions': _instructions.text.trim(),
      'imageUrl': _imageUrl.text.trim(),
    };
    final col = FirebaseFirestore.instance.collection('recipes');
    setState(() => _loading = true);
    if (widget.recipeId == null) {
      await col.add(data);
    } else {
      await col.doc(widget.recipeId).update(data);
    }
    setState(() => _loading = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recipeId == null ? 'Add Recipe' : 'Edit Recipe')),
      body: _loading ? const Center(child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _title, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => (v==null||v.isEmpty)?'Enter title':null),
              const SizedBox(height: 8),
              TextFormField(controller: _ingredients, decoration: const InputDecoration(labelText: 'Ingredients (comma separated)'), maxLines: 2),
              const SizedBox(height: 8),
              TextFormField(controller: _instructions, decoration: const InputDecoration(labelText: 'Instructions'), maxLines: 6),
              const SizedBox(height: 8),
              TextFormField(controller: _imageUrl, decoration: const InputDecoration(labelText: 'Image URL (optional)')),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}