import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingListItem {
  final String id;
  final String shoppingListId;
  final String name;
  final double quantity;
  final String unit;
  final double? price;
  final bool isPurchased;

  ShoppingListItem({
    required this.id,
    required this.shoppingListId,
    required this.name,
    required this.quantity,
    required this.unit,
    this.price,
    required this.isPurchased,
  });

  factory ShoppingListItem.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShoppingListItem(
      id: doc.id,
      shoppingListId: data['shoppingListId'] ?? '',
      name: data['name'] ?? '',
      quantity: (data['quantity'] as num).toDouble(),
      unit: data['unit'] ?? 'шт',
      price: (data['price'] as num?)?.toDouble(),
      isPurchased: data['isPurchased'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shoppingListId': shoppingListId,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'price': price,
      'isPurchased': isPurchased,
    };
  }

  double get totalPrice => (price ?? 0) * quantity;
}