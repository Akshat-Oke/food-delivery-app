import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddeli/models/menu_item.dart';

/// A restaurant.
///
/// Must be constructed from JSON, using
/// [RestaurantModel.fromJSON]
class RestaurantModel {
  /// Private constructor
  RestaurantModel._({
    required this.name,
    // this.isOpen = true,
    required this.fromTime,
    required this.toTime,
    required this.docId,
    required this.categories,
  });
  final String name;

  /// The Firebase id for this restaurant
  final String docId;
  // final bool isOpen;
  /// Categories in the menu
  final List<dynamic> categories;

  /// Opening and closing times
  final Timestamp fromTime, toTime;

  /// Whether this restaurant is open depending on
  /// opening and closing times
  bool get isOpen {
    final now = toDouble(TimeOfDay.now());
    final fromTime = toDouble(this.fromTime.toTimeOfDay());
    final toTime = toDouble(this.toTime.toTimeOfDay());
    return fromTime < now && now < toTime;
    // return fromTime.compareTo(now) < 0 && toTime.compareTo(now) > 0;
  }

  /// Menu items
  List<MenuItem>? items;

  /// Get the opening and closing times for display
  /// Ex. 10:00 AM - 3:00 PM
  String times(context) {
    DateTime date = fromTime.toDate();
    TimeOfDay fTime = TimeOfDay(hour: date.hour, minute: date.minute);
    date = toTime.toDate();
    TimeOfDay tTime = TimeOfDay(hour: date.hour, minute: date.minute);
    return ("${fTime.format(context)} - ${tTime.format(context)}");
  }

  /// Construct a [RestaurantModel] from JSON.
  ///
  /// [json] must have a Firebase _id_
  factory RestaurantModel.fromJSON(Map<String, dynamic> json) {
    return RestaurantModel._(
      name: json["name"] ?? "Restaurant",
      // isOpen: json["isOpen"] ?? false,
      fromTime: json["fromTime"],
      toTime: json["toTime"],
      docId: json["id"],
      categories: (json["categories"]) ?? [],
    );
  }
}

double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

extension TimeOfTimestamp on Timestamp {
  TimeOfDay toTimeOfDay() {
    final date = toDate();
    return TimeOfDay.fromDateTime(date);
  }
}
