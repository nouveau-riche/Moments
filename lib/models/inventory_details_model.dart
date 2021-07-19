import 'package:flutter/services.dart';

class InventoryDetailModel {
  final String id;
  final String imageUrl;
  final String gift;
  final String history;
  final String description;
  final String relationship;
  final ByteData byteData;

  InventoryDetailModel(
      {this.id,
      this.imageUrl,
      this.gift,
      this.description,
      this.history,
      this.relationship,
      this.byteData});
}
