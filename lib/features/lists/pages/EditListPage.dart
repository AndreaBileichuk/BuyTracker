import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/ShoppingListsProvider.dart';

class EditListPage extends StatefulWidget {
  final String listId;

  const EditListPage({super.key, required this.listId});

  @override
  State<EditListPage> createState() => _EditListPageState();
}

class _EditListPageState extends State<EditListPage> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;

  String _selectedEmoji = "🛒";
  final List<String> _emojis = ["🛒", "🎉", "💊", "🏠", "🎂", "🍕", "🥩", "🥦"];

  bool _isLoading = true; // Для показу лоадера поки вантажаться дані

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _noteController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadListData();
    });
  }

  // 2. Асинхронне завантаження даних списку
  Future<void> _loadListData() async {
    final provider = context.read<ShoppingListsProvider>();
    // Оскільки getListById тепер Future (може тягнути з бази)
    final list = await provider.getListById(widget.listId);

    if (list != null) {
      if (mounted) {
        setState(() {
          _titleController.text = list.title;
          _noteController.text = list.description;
          _selectedEmoji = list.emoji;
          _isLoading = false;
        });
      }
    } else {
      // Якщо список не знайдено (видалений)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Список не знайдено')),
        );
        context.pop();
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введіть назву списку')),
      );
      return;
    }

    // 3. Виклик оновлення (Тільки метадані, без items)
    await context.read<ShoppingListsProvider>().updateList(
      widget.listId,
      _titleController.text,
      _selectedEmoji,
      _noteController.text,
    );

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                    child: const Icon(Icons.edit, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Редагувати список",
                    style: TextStyle(
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
                  const Text("Назва списку", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "Наприклад: Продукти на тиждень",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== Вибір іконки =====
                  const Text("Виберіть іконку", style: TextStyle(fontWeight: FontWeight.bold)),
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
                  const Text("Нотатки (необов'язково)", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Додайте нотатки до списку...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ===== Кнопка збереження =====
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
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
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
                        "Зберегти зміни",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),

                  // Кнопка видалення списку (опціонально)
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        // Тут можна додати діалог підтвердження і виклик provider.deleteList
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text("Видалити список", style: TextStyle(color: Colors.red)),
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