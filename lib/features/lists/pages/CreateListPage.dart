import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/ShoppingListItem.dart';
import '../../../core/providers/ShoppingListsProvider.dart';
import 'package:buy_tracker/l10n/app_localizations.dart';

class CreateListPage extends StatefulWidget {
  const CreateListPage({super.key});

  @override
  State<CreateListPage> createState() => _CreateListPageState();
}

class _CreateListPageState extends State<CreateListPage> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  final _itemNameController = TextEditingController();
  final _itemQtyController = TextEditingController();

  String _selectedEmoji = "🛒";
  final List<String> _emojis = ["🛒", "🎉", "💊", "🏠", "🎂", "🍕", "🥩", "🥦"];

  final List<ShoppingListItem> _tempItems = [];
  bool _isCreating = false; // Стан завантаження

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _itemNameController.dispose();
    _itemQtyController.dispose();
    super.dispose();
  }

  void _addItem() {
    if (_itemNameController.text.isEmpty) return;

    setState(() {
      _tempItems.add(ShoppingListItem(
        // Тимчасовий ID як String (для UI, потім в базі він зміниться або залишиться унікальним)
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        shoppingListId: "", // Поки що пустий, репозиторій сам прив'яже до нового списку
        name: _itemNameController.text,
        quantity: double.tryParse(_itemQtyController.text) ?? 1,
        unit: 'шт',
        isPurchased: false,
      ));

      _itemNameController.clear();
      _itemQtyController.clear();
    });
  }

  void _removeItem(int index) {
    setState(() {
      _tempItems.removeAt(index);
    });
  }

  Future<void> _saveList() async {
    final l10n = AppLocalizations.of(context)!;
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterListNameWarning)),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      // Викликаємо метод провайдера і чекаємо завершення запису в базу
      await context.read<ShoppingListsProvider>().createNewList(
        _titleController.text,
        _selectedEmoji,
        _noteController.text,
        _tempItems,
      );

      if (mounted) {
        context.pop(); // Повертаємось назад тільки після успішного створення
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.creationError}$e')),
        );
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Header =====
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text("📋", style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    l10n.createList,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Назва списку =====
                  Text(l10n.listName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: l10n.listNameHintExample,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== Вибір іконки =====
                  Text(l10n.chooseIcon, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 60,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _emojis.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final emoji = _emojis[index];
                        final isSelected = _selectedEmoji == emoji;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedEmoji = emoji),
                          child: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected ? null : Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(emoji, style: const TextStyle(fontSize: 24)),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== Нотатки =====
                  Text(l10n.notesOptional, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: l10n.notesHint,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ===== Секція Товари =====
                  Row(
                    children: [
                      const Text("📝 ", style: TextStyle(fontSize: 18)),
                      Text(l10n.items, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Форма додавання товару
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _itemNameController,
                          decoration: InputDecoration(
                            hintText: l10n.itemNameHint,
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _itemQtyController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: l10n.quantityHint,
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _addItem,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              ),
                              child: const Text("Додати", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== Список доданих товарів =====
                  if (_tempItems.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _tempItems.length,
                      itemBuilder: (context, index) {
                        final item = _tempItems[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text("${item.quantity} ${l10n.pcs}.", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outline, color: Colors.grey[400], size: 20),
                                onPressed: () => _removeItem(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 40),

                  // ===== Кнопка створення =====
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isCreating
                            ? [Colors.grey, Colors.grey] // Сірий колір при завантаженні
                            : [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isCreating ? null : _saveList, // Блокуємо кнопку
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        // Зберігаємо стиль disabled
                        disabledBackgroundColor: Colors.transparent,
                        disabledForegroundColor: Colors.white.withOpacity(0.7),
                      ),
                      child: _isCreating
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                        l10n.createList,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}