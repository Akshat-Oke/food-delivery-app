import "package:flutter/material.dart";
import 'package:fooddeli/models/login_manager.dart';
import 'package:fooddeli/models/menu_item.dart';
import 'package:fooddeli/utility/firebase_orders.dart';
import 'package:fooddeli/widgets/custom_text_field.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

/// Page where restaurant owner adds new items to menu
class AddItemPage extends StatefulWidget {
  const AddItemPage(this.resOwner, {Key? key}) : super(key: key);
  final ResOwner? resOwner;

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  bool isNonVeg = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEEEE),
      appBar: AppBar(
        title: const Text("Add Item"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            child: Column(
              children: [
                CustomTextField(
                  controller: nameController,
                  onChanged: (value) {
                    if (value
                        .contains(RegExp("chicken", caseSensitive: false))) {
                      setState(() {
                        isNonVeg = true;
                      });
                    }
                  },
                  hint: "Item name",
                ),
                const SizedBox(height: 12),
                CustomTextField(
                    controller: priceController,
                    hint: "Price",
                    type: TextInputType.number),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 30,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: TypeAheadField(
                    noItemsFoundBuilder: (_) {
                      return const SizedBox();
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        hintText: "Category",
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 22, horizontal: 15),
                      ),
                    ),
                    suggestionsCallback: (val) {
                      //distinct
                      return widget.resOwner?.categories.toSet().toList().where(
                              (e) => e.contains(
                                  RegExp(val, caseSensitive: false))) ??
                          [val];
                    },
                    itemBuilder: (context, suggestion) => ListTile(
                      title: Text(suggestion.toString()),
                    ),
                    onSuggestionSelected: (category) {
                      categoryController.text = category.toString().trim();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("This item is"),
                    const SizedBox(width: 8),
                    DropdownButton<bool>(
                        value: isNonVeg,
                        onChanged: (bool? newVal) {
                          setState(() {
                            isNonVeg = newVal ?? false;
                          });
                        },
                        items: const [
                          DropdownMenuItem(value: false, child: Text("Veg")),
                          DropdownMenuItem(value: true, child: Text("Non veg"))
                        ]),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!loading) {
                      _submit();
                    }
                  },
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text("Add Item"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    bool invalid = nameController.text.isEmpty || priceController.text.isEmpty;
    if (invalid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item name and price are required"),
        ),
      );
      return;
    }
    setState(() {
      loading = true;
    });
    String category = categoryController.text;
    if (category.isEmpty) {
      category = "All";
    }
    MenuItem menuItem = MenuItem(
      category: category,
      name: nameController.text,
      price: int.parse(priceController.text),
      isNonVeg: isNonVeg,
      isAvailable: true,
      restaurantId: widget.resOwner?.resId ?? "resId",
      id: "",
    );
    widget.resOwner?.categories.add(category);
    await addItem(menuItem);
    loading = false;
    Navigator.pop(context);
  }
}
