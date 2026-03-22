import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/ShoppingListsProvider.dart';
import '../providers/RemindersProvider.dart';

class CreateReminderPage extends StatefulWidget {
  final String? preselectedListId;
  const CreateReminderPage({super.key, this.preselectedListId});

  @override
  State<CreateReminderPage> createState() => _CreateReminderPageState();
}

class _CreateReminderPageState extends State<CreateReminderPage> {
  final _messageController = TextEditingController();
  DateTime? _selectedTime;
  String? _selectedListId;
  String? _selectedListTitle;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedListId = widget.preselectedListId;
    if (_selectedListId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final listsProvider = context.read<ShoppingListsProvider>();
        try {
          final list = listsProvider.lists.firstWhere((l) => l.id == _selectedListId);
          if (mounted) {
            setState(() {
              _selectedListTitle = list.title;
            });
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _selectedListId = null;
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _selectedTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _saveReminder() async {
    if (_selectedTime == null || _selectedListId == null || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введіть текст, оберіть час і список')),
      );
      return;
    }

    if (_selectedTime!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Час нагадування має бути в майбутньому')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await context.read<RemindersProvider>().addReminder(
        listId: _selectedListId!,
        listTitle: _selectedListTitle!,
        message: _messageController.text,
        scheduledTime: _selectedTime!,
      );
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listsProvider = context.watch<ShoppingListsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Створити нагадування'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Список покупок',
                border: OutlineInputBorder(),
              ),
              value: _selectedListId,
              items: listsProvider.lists.map((list) {
                return DropdownMenuItem(
                  value: list.id,
                  child: Text('${list.emoji} ${list.title}'),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedListId = val;
                    _selectedListTitle = listsProvider.lists.firstWhere((l) => l.id == val).title;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Текст нагадування',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                _selectedTime != null
                    ? 'Заплановано на: ${DateFormat('dd.MM.yyyy HH:mm').format(_selectedTime!)}'
                    : 'Час не вибрано',
              ),
              trailing: ElevatedButton(
                onPressed: _pickDateTime,
                child: const Text('Вибрати час'),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveReminder,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667EEA),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Зберегти', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
