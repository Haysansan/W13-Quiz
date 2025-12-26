import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key, required this.showSearch});

  final bool showSearch;

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  String _searchQuery = ''; ///State management

  void onCreate() async {
    Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );

    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    } ///Validation
  }

  List<Grocery> get _filteredGroceries {
    if (_searchQuery.isEmpty) return dummyGroceryItems; ///Default Search Tab View

    return dummyGroceryItems
        .where(
          (grocery) =>
          grocery.name.toLowerCase().contains(_searchQuery.toLowerCase()),
    ) /// Returnn input name
        .toList();
  }

  Widget _buildList(List<Grocery> groceries) {
    if (groceries.isEmpty) {
      return const Center(child: Text('No items in list found.'));
    }

    return ListView.builder(
      itemCount: groceries.length,
      itemBuilder: (context, index) =>
          GroceryTile(grocery: groceries[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: widget.showSearch
          ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(child: _buildList(_filteredGroceries)),
        ],
      )
          : _buildList(dummyGroceryItems),
    );
  }
}

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 15,
        height: 15,
        color: grocery.category.color,
      ),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}

