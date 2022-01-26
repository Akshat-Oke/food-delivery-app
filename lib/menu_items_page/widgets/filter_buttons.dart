import "package:flutter/material.dart";
import 'package:fooddeli/models/menu_items_provider.dart';
import 'package:provider/provider.dart';

class FilterButtons extends StatefulWidget {
  const FilterButtons({Key? key}) : super(key: key);

  @override
  _FilterButtonsState createState() => _FilterButtonsState();
}

class _FilterButtonsState extends State<FilterButtons> {
  void filter(BuildContext context, String category) {
    context.read<MenuItemsProvider>().setCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        Provider.of<MenuItemsProvider>(context).rModel.categories;
    return SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      floating: true,
      backgroundColor: Colors.transparent,
      title: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SizedBox(
          height: 55,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return FilterChip(
                    category: "All",
                    onSelected: (_, __) =>
                        context.read<MenuItemsProvider>().clearFilters());
              }
              return FilterChip(
                  category: categories[index - 1], onSelected: filter);
            },
          ),
        ),
      ),
    );
  }
}

class FilterChip extends StatelessWidget {
  FilterChip({required this.category, required this.onSelected});
  final String category;
  final void Function(BuildContext, String) onSelected;
  @override
  Widget build(BuildContext context) {
    final currentCategory = context.watch<MenuItemsProvider>().category;
    return GestureDetector(
      onTap: () {
        onSelected(context, category);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: category == currentCategory
              ? Colors.deepOrange
              : Colors.blueGrey.shade300,
        ),
        child: Center(
            child: Text(category,
                style: const TextStyle(
                    fontWeight: FontWeight.w400, fontSize: 16))),
      ),
    );
  }
}
