import 'package:flutter/material.dart';

import 'package:shopping_list/models/grocery_item.dart';

class GroceryTile extends StatelessWidget {
  const GroceryTile({
    super.key, 
    required this.item,
    required this.removeFunction
  });

  final GroceryItem item;
  final void Function(GroceryItem item) removeFunction;
  
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      onDismissed: (direction) {
        removeFunction(item);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Row(
              children: [
                Icon(
                  Icons.square,
                  color: item.category.color,
                ),
                const SizedBox(width: 14),
                Text(item.name)
              ],
            ),
            const Spacer(),
            Text(item.quantity.toString())
          ],
        ),
      ),
    );
  }
}