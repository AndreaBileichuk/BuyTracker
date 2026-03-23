import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/ShoppingListsProvider.dart';
import '../../../core/providers/AuthProvider.dart';
import '../widgets/shopping_list_item_card.dart';
import 'package:buy_tracker/l10n/app_localizations.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context);

    if (authProvider.currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Consumer<ShoppingListsProvider>(
      key: ValueKey(authProvider.currentUser?.uid),

      builder: (context, provider, child) {
        final l10n = AppLocalizations.of(context)!;
        return Stack(
          children: [
            Column(
              children: [
                // --- ГАРНИЙ ХЕДЕР ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              "📋",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.allLists,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.yourShoppingLists,
                                style: const TextStyle(fontSize: 18, color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.white70, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              l10n.searchList,
                              style: const TextStyle(fontSize: 18, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // --- ЗАГОЛОВОК СПИСКУ ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.lists,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // --- ЛОГІКА ВІДОБРАЖЕННЯ ---
                if (provider.isLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (provider.error != null)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                          const SizedBox(height: 16),
                          Text(
                            l10n.oopsSomethingWentWrong,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Text(
                              provider.error!, // Тут виводиться текст помилки
                              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // Можна додати кнопку "Оновити"
                          TextButton(
                              onPressed: () {
                                // Якщо у провайдера є метод refresh або fetchLists
                                // provider.fetchLists();
                              },
                              child: Text(l10n.tryAgain)
                          )
                        ],
                      ),
                    ),
                  )
                else if (provider.lists.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          l10n.noListsFoundCreateFirst,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 16),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: provider.lists.length,
                        itemBuilder: (context, index) {
                          final list = provider.lists[index];
                          return ShoppingListItemCard(list: list);
                        },
                      ),
                    ),
              ],
            ),

            // --- FAB ---
            Positioned(
              bottom: 12,
              right: 24,
              child: Container(
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
                    onTap: () => {context.go('/lists/create')},
                    child: const Icon(Icons.add, size: 32, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}