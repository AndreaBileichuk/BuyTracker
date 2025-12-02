import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/ShoppingListItem.dart';
import '../models/ShoppingListModel.dart';
import '../repository/ShoppingListRepository.dart';

class ShoppingListsProvider extends ChangeNotifier {
  final ShoppingListRepository _repository = ShoppingListRepository();
  StreamSubscription? _subscription;

  List<ShoppingListModel> _lists = [];
  bool _isLoading = true;
  String? _error;

  List<ShoppingListModel> get lists => _lists;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Ініціалізація: підписуємось на стрім одразу при створенні провайдера
  ShoppingListsProvider() {
    _initSubscription();
  }

  void _initSubscription() {
    _isLoading = true;
    notifyListeners();

    _subscription = _repository.getUserListsStream().listen(
          (data) {
        _lists = data;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Отримати список за ID з локального кешу (швидко) або сервера
  Future<ShoppingListModel?> getListById(String id) async {
    // Спочатку шукаємо в уже завантажених
    try {
      return _lists.firstWhere((list) => list.id == id);
    } catch (e) {
      // Якщо немає - пробуємо тягнути з бази
      return await _repository.getListById(id);
    }
  }

  // Створення списку
  Future<void> createNewList(String title, String emoji, String description, List<ShoppingListItem> initialItems) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final newList = ShoppingListModel(
        id: '', // Firestore створить ID
        ownerId: user.uid,
        title: title,
        emoji: emoji,
        description: description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        items: initialItems,
      );

      await _repository.createList(newList);
      // notifyListeners не потрібен, бо Stream сам оновить список
    } catch (e) {
      _error = "Помилка створення: $e";
      notifyListeners();
    }
  }

  // Оновлення списку (назва/опис)
  Future<void> updateList(String id, String title, String emoji, String description) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final updatedList = ShoppingListModel(
        id: id,
        ownerId: user.uid,
        title: title,
        emoji: emoji,
        description: description,
        createdAt: DateTime.now(), // ігнорується
        updatedAt: DateTime.now()  // ігнорується
    );

    await _repository.updateListMetadata(updatedList);
  }

  // Видалення
  Future<void> deleteList(String listId) async {
    await _repository.deleteList(listId);
  }

  // Додавання товару
  Future<void> addItem(String listId, String name, double quantity, String unit) async {
    final newItem = ShoppingListItem(
      id: '',
      shoppingListId: listId,
      name: name,
      quantity: quantity,
      unit: unit,
      isPurchased: false,
    );
    await _repository.addItem(listId, newItem);
  }

// Метод: Купити товар (з вводом ціни)
  Future<void> markAsPurchased(String listId, String itemId, double price) async {
    // 1. Оптимістичне оновлення UI
    final listIndex = _lists.indexWhere((l) => l.id == listId);
    if (listIndex != -1) {
      final itemIndex = _lists[listIndex].items.indexWhere((i) => i.id == itemId);
      if (itemIndex != -1) {
        final oldItem = _lists[listIndex].items[itemIndex];

        // Створюємо копію з isPurchased = true і новою ціною
        final newItem = ShoppingListItem(
          id: oldItem.id,
          shoppingListId: oldItem.shoppingListId,
          name: oldItem.name,
          quantity: oldItem.quantity,
          unit: oldItem.unit,
          price: price, // <--- Зберігаємо ціну
          isPurchased: true, // <--- Ставимо галочку
        );

        _lists[listIndex].items[itemIndex] = newItem;
        notifyListeners();
      }
    }

    // 2. Запис в базу
    await _repository.updateItemStatusWithPrice(listId, itemId, true, price);
  }

  // Метод: Скасувати покупку (зняти галочку)
  Future<void> unmarkAsPurchased(String listId, String itemId) async {
    // 1. Оптимістичне оновлення UI
    final listIndex = _lists.indexWhere((l) => l.id == listId);
    if (listIndex != -1) {
      final itemIndex = _lists[listIndex].items.indexWhere((i) => i.id == itemId);
      if (itemIndex != -1) {
        final oldItem = _lists[listIndex].items[itemIndex];

        final newItem = ShoppingListItem(
          id: oldItem.id,
          shoppingListId: oldItem.shoppingListId,
          name: oldItem.name,
          quantity: oldItem.quantity,
          unit: oldItem.unit,
          price: 0, // <--- Обнуляємо ціну (опціонально)
          isPurchased: false,
        );

        _lists[listIndex].items[itemIndex] = newItem;
        notifyListeners();
      }
    }

    // 2. Запис в базу
    await _repository.updateItemStatusWithPrice(listId, itemId, false, 0);
  }

  Future<void> updateItem(String listId, String itemId, String name, double quantity, String unit) async {
    final listIndex = _lists.indexWhere((l) => l.id == listId);
    if (listIndex != -1) {
      final itemIndex = _lists[listIndex].items.indexWhere((i) => i.id == itemId);

      if (itemIndex != -1) {
        final oldItem = _lists[listIndex].items[itemIndex];

        final newItem = ShoppingListItem(
          id: oldItem.id,
          shoppingListId: oldItem.shoppingListId,
          name: name,          // Нове ім'я
          quantity: quantity,  // Нова кількість
          unit: unit,          // Новий юніт
          price: oldItem.price,
          isPurchased: oldItem.isPurchased,
        );

        _lists[listIndex].items[itemIndex] = newItem;
        notifyListeners(); // <--- UI оновлюється тут
      }
    }

    await _repository.updateItem(listId, itemId, name, quantity, unit);
  }

  Future<void> deleteItem(String listId, String itemId) async {
    final listIndex = _lists.indexWhere((l) => l.id == listId);
    if (listIndex != -1) {
      _lists[listIndex].items.removeWhere((i) => i.id == itemId);
      notifyListeners();
    }

    await _repository.deleteItem(listId, itemId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}