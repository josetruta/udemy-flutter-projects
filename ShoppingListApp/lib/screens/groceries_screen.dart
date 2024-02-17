import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';

import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';
import 'package:shopping_list/widgets/grocery_tile.dart';

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({super.key});

  @override
  State<GroceriesScreen> createState() {
    return _GroceriesScreenState();
  }
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  List<GroceryItem> _activeGroceries = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }
  
  void _loadItems() async {
    
    final url = Uri.https(
        'flutter-shoppinglist-c7035-default-rtdb.firebaseio.com', 
        'shopping-list.json'
    );
    final response = await http.get(url); 

    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to fetch data. Please, try again later.';
      });
    }

    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final category = 
        categories.entries.firstWhere(
          (catItem) => catItem.value.name == item.value['category']
        ).value;
      loadedItems.add(
        GroceryItem(
          id: item.key, 
          name: item.value['name'], 
          quantity: item.value['quantity'], 
          category: category)
      );
    }

    setState(() {
      _activeGroceries = loadedItems;
      _isLoading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItemScreen()
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _activeGroceries.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _activeGroceries.indexOf(item);
    
    setState(() {
      _activeGroceries.remove(item);
    });
    
    final url = Uri.https(
        'flutter-shoppinglist-c7035-default-rtdb.firebaseio.com', 
        'shopping-list/${item.id}.json'
    );

    final response = await http.delete(url);
    
    if (response.statusCode >= 400) {
      setState(() {
        _activeGroceries.insert(index, item);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to delete item.'),
            action: SnackBarAction(
            label: 'Close', 
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              }
            ),
          ),
        );
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nothing here!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),),
            SizedBox(height: 8),
            Text('Add some new groceries.')
          ],
        ),
      );
    
    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      content = Center(child: Text(_error!));
    }

    if (_activeGroceries.isNotEmpty) {
      content = ListView(
          children: [
            for (final item in _activeGroceries)
              GroceryTile(
                item: item,
                removeFunction: _removeItem,
              ),
          ],
        );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem, 
            icon: const Icon(Icons.add)
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: content
      ),
    );
  }
}