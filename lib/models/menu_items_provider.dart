import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddeli/models/menu_item.dart';
import 'package:fooddeli/models/restaurant_model.dart';

class MenuItemsProvider with ChangeNotifier {
  /// This will fetch menu items given a restaurant
  MenuItemsProvider(this.rModel);
  RestaurantModel rModel;

  /// The whole menu from database
  List<MenuItem> _origMenu = [];
  bool isLoading = false;
  bool hasError = false;

  /// The menu with a vegetarian filter applied.
  List<MenuItem> _menuVegOrNon = [];

  /// Filtered menu using categories + veg preference
  ///
  /// Used for displaying the menu items
  List<MenuItem> filteredMenu = [];

  /// The current category selected.
  ///
  /// Used for filtering menu after changing veg preference
  String? category;

  /// Get the menu item details from Firebase
  Future<void> getMenu() async {
    isLoading = true;
    notifyListeners();
    try {
      CollectionReference items = FirebaseFirestore.instance
          .collection("restaurants/${rModel.docId}/items");
      final snapshot = await items.get();
      final docs = snapshot.docs;
      _origMenu = docs.map((e) {
        final json = e.data() as Map<String, dynamic>;
        json["restaurantId"] = rModel.docId;
        return MenuItem.fromJSON(json, e.id);
      }).toList();
      filteredMenu = _origMenu;
      _menuVegOrNon = _origMenu;
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
    filteredMenu = [..._menuVegOrNon];
    notifyListeners();
  }

  void clearVegPreference() {
    _menuVegOrNon = [..._origMenu];
    _filterByCategory(category);
  }

  void _filterByCategory(String? category) {
    // print("filter $category");
    if (category == null || category == "All") {
      clearFilters();
      return;
    }
    filteredMenu = [..._menuVegOrNon].where((menu) {
      // print(menu.category);
      return (menu.category == category);
    }).toList();
    // print(filteredMenu);
    notifyListeners();
  }

  /// If `isVeg` is true, only Veg items.
  /// If false, all items
  void applyOnlyVegFilter(bool isVeg) {
    if (!isVeg) {
      _menuVegOrNon = [..._origMenu];
    } else {
      _menuVegOrNon = [..._origMenu].where((item) {
        return (!item.isNonVeg);
      }).toList();
    }
    _filterByCategory(category);
  }
}
