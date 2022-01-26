import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddeli/models/menu_item.dart';
import 'package:fooddeli/models/restaurant_model.dart';

class MenuItemsProvider with ChangeNotifier {
  MenuItemsProvider(this.rModel);
  RestaurantModel rModel;
  List<MenuItem> origMenu = [];
  bool isLoading = false;
  bool hasError = false;
  List<MenuItem> menuVegOrNon = [];
  List<MenuItem> filteredMenu = [];
  String? category;
  Future<void> getMenu() async {
    isLoading = true;
    notifyListeners();
    try {
      CollectionReference items = FirebaseFirestore.instance
          .collection("restaurants/${rModel.docId}/items");
      final snapshot = await items.get();
      final docs = snapshot.docs;
      origMenu = docs.map((e) {
        final json = e.data() as Map<String, dynamic>;
        json["restaurantId"] = rModel.docId;
        return MenuItem.fromJSON(json, e.id);
      }).toList();
      filteredMenu = origMenu;
      menuVegOrNon = origMenu;
      category = "All";
    } catch (e) {
      hasError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String c) {
    category = c;
    _filterByCategory(c);
  }

  void clearFilters() {
    category = "All";
    filteredMenu = [...menuVegOrNon];
    notifyListeners();
  }

  void clearVegPreference() {
    menuVegOrNon = [...origMenu];
    _filterByCategory(category);
  }

  void _filterByCategory(String? category) {
    // print("filter $category");
    if (category == null || category == "All") {
      clearFilters();
      return;
    }
    filteredMenu = [...menuVegOrNon].where((menu) {
      // print(menu.category);
      return (menu.category == category);
    }).toList();
    // print(filteredMenu);
    notifyListeners();
  }

  /// If `isVeg` is true, only Veg items.
  /// If false, only non veg items
  void applyOnlyVegFilter(bool isVeg) {
    if (!isVeg) {
      menuVegOrNon = [...origMenu];
    } else {
      menuVegOrNon = [...origMenu].where((item) {
        return (!item.isNonVeg);
      }).toList();
    }
    _filterByCategory(category);
  }
}
