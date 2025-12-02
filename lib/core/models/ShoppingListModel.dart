import 'package:cloud_firestore/cloud_firestore.dart';
import 'ShoppingListItem.dart';

class ShoppingListModel {
  final String id;
  final String ownerId;
  final String title;
  final String emoji;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ShoppingListItem> items;

  ShoppingListModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.emoji,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.items = const [],
  });

  // Фабрика для створення з Firebase
  factory ShoppingListModel.fromSnapshot(DocumentSnapshot doc, List<ShoppingListItem> items) {
    final data = doc.data() as Map<String, dynamic>;
    return ShoppingListModel(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      title: data['title'] ?? '',
      emoji: data['emoji'] ?? '📝',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      items: items,
    );
  }

  // Конвертація в Map для запису в Firebase
  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'title': title,
      'emoji': emoji,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  int get totalItems => items.length;
  int get purchasedItems => items.where((item) => item.isPurchased).length;
  double get totalBudget => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get spentAmount => items.where((item) => item.isPurchased).fold(0.0, (sum, item) => sum + item.totalPrice);

  double get progressPercentage {
    if (totalItems == 0) return 0;
    return (purchasedItems / totalItems) * 100;
  }
}
