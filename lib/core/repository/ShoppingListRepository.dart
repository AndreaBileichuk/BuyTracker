import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/ShoppingListItem.dart';
import '../models/ShoppingListModel.dart';

class ShoppingListRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<ShoppingListModel>> getUserListsStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _db
        .collection('shopping_lists')
        .where('ownerId', isEqualTo: user.uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<ShoppingListModel> fullLists = [];

      for (var doc in snapshot.docs) {
        final itemsSnapshot = await doc.reference.collection('items').get();
        final items = itemsSnapshot.docs
            .map((itemDoc) => ShoppingListItem.fromSnapshot(itemDoc))
            .toList();

        fullLists.add(ShoppingListModel.fromSnapshot(doc, items));
      }
      return fullLists;
    });
  }

  Future<ShoppingListModel?> getListById(String listId) async {
    try {
      final doc = await _db.collection('shopping_lists').doc(listId).get();
      if (!doc.exists) return null;

      final itemsSnapshot = await doc.reference.collection('items').get();
      final items = itemsSnapshot.docs
          .map((itemDoc) => ShoppingListItem.fromSnapshot(itemDoc))
          .toList();

      return ShoppingListModel.fromSnapshot(doc, items);
    } catch (e) {
      print("Error getting list: $e");
      return null;
    }
  }

  Future<void> createList(ShoppingListModel list) async {
    DocumentReference docRef = await _db.collection('shopping_lists').add(list.toMap());

    for (var item in list.items) {
      final itemMap = item.toMap();
      itemMap['shoppingListId'] = docRef.id;
      await docRef.collection('items').add(itemMap);
    }
  }

  Future<void> updateListMetadata(ShoppingListModel list) async {
    await _db.collection('shopping_lists').doc(list.id).update({
      'title': list.title,
      'emoji': list.emoji,
      'description': list.description,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> deleteList(String listId) async {
    await _db.collection('shopping_lists').doc(listId).delete();
  }

  // --- Методи для товарів ---
  Future<void> addItem(String listId, ShoppingListItem item) async {
    await _db.collection('shopping_lists').doc(listId).collection('items').add(item.toMap());
    _updateTimestamp(listId);
  }

  Future<void> updateItemStatusWithPrice(String listId, String itemId, bool isPurchased, double? price) async {
    await _db
        .collection('shopping_lists')
        .doc(listId)
        .collection('items')
        .doc(itemId)
        .update({
      'isPurchased': isPurchased,
      'price': price,
    });
  }

  Future<void> updateItem(String listId, String itemId, String name, double quantity, String unit) async {
    await _db
        .collection('shopping_lists')
        .doc(listId)
        .collection('items')
        .doc(itemId)
        .update({
      'name': name,
      'quantity': quantity,
      'unit': unit,
    });
  }

  Future<void> deleteItem(String listId, String itemId) async {
    await _db.collection('shopping_lists').doc(listId).collection('items').doc(itemId).delete();
    _updateTimestamp(listId);
  }

  Future<void> _updateTimestamp(String listId) async {
    await _db.collection('shopping_lists').doc(listId).update({'updatedAt': Timestamp.now()});
  }
}