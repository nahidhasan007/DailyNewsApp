import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class CategoryTabs extends StatelessWidget {
  final Function(String) onCategorySelected;
  final RxString selectedCategory;

  const CategoryTabs({
    Key? key,
    required this.onCategorySelected,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'General', 'value': ''},
      {'name': 'Business', 'value': 'business'},
      {'name': 'Technology', 'value': 'technology'},
      {'name': 'Science', 'value': 'science'},
      {'name': 'Health', 'value': 'health'},
      {'name': 'Sports', 'value': 'sports'},
      {'name': 'Entertainment', 'value': 'entertainment'},
    ];

    return Container(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: Obx(() {
              final isSelected = selectedCategory.value == category['value'];
              return ChoiceChip(
                label: Text(category['name']!),
                selected: isSelected,
                onSelected: (_) => onCategorySelected(category['value']!),
              );
            }),
          );
        },
      ),
    );
  }
}
