import 'package:who_gets_this/models/inventory_details_model.dart';

class InventoryModel {
  final String id;
  final String title;
  final DateTime date;
  final String city;
  final String state;
  final String street;
  final String zip;
  final int total;
  final List<InventoryDetailModel> list;

  InventoryModel(
      {this.id,
      this.title,
      this.date,
      this.city,
      this.state,
      this.street,
      this.zip,
      this.total,
      this.list});
}
