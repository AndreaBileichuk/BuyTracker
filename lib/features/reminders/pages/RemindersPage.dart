import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/RemindersProvider.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
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
                  child: const Text("🔔", style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Нагадування",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<RemindersProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text('Помилка: ${provider.error}'));
          }

          if (provider.reminders.isEmpty) {
            return Center(
              child: Text(
                'У вас немає запланованих нагадувань',
                style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6)),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.reminders.length,
            itemBuilder: (context, index) {
              final reminder = provider.reminders[index];
              final isPast = reminder.scheduledTime.isBefore(DateTime.now());

              return ListTile(
                leading: Icon(Icons.alarm, color: Theme.of(context).colorScheme.primary),
                title: Text(reminder.listTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reminder.message),
                    Text(
                      DateFormat('dd.MM.yyyy HH:mm').format(reminder.scheduledTime),
                      style: TextStyle(
                        color: isPast ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => provider.deleteReminder(reminder),
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(32),
            onTap: () => context.go('/reminders/create'),
            child: const Icon(Icons.add, size: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
