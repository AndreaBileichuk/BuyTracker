import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/ShoppingListItem.dart';
import '../../../core/models/ShoppingListModel.dart';
import '../../../core/providers/ShoppingListsProvider.dart';
import 'package:buy_tracker/l10n/app_localizations.dart';

class ShoppingListDetailsPage extends StatefulWidget {
  final String listId;

  const ShoppingListDetailsPage({super.key, required this.listId});

  @override
  State<ShoppingListDetailsPage> createState() => _ShoppingListDetailsPageState();
}

class _ShoppingListDetailsPageState extends State<ShoppingListDetailsPage> {
  // Контролери для додавання/редагування
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  // Контролер для ціни
  final TextEditingController _priceInputController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _priceInputController.dispose();
    super.dispose();
  }

  // --- ЛОГІКА КЛІКУ ПО ТОВАРУ ---
  void _onItemTap(ShoppingListsProvider provider, String listId, ShoppingListItem item) {
    if (item.isPurchased) {
      // Якщо вже куплено -> просто знімаємо галочку
      provider.unmarkAsPurchased(listId, item.id);
    } else {
      // Якщо НЕ куплено -> показуємо вікно вводу ціни
      _showPriceDialog(context, provider, listId, item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<ShoppingListsProvider>(
        builder: (context, provider, child) {
          ShoppingListModel? list;
          try {
            list = provider.lists.firstWhere((l) => l.id == widget.listId);
          } catch (e) {
            list = null;
          }

          if (list == null) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && context.canPop()) context.pop();
            });
            return const SizedBox.shrink();
          }

          final totalItems = list.items.length;
          final purchasedItems = list.items.where((i) => i.isPurchased).length;

          final totalPrice = list.items
              .where((i) => i.isPurchased)
              .fold(0.0, (sum, item) => sum + (item.price ?? 0)); // Тут сумуємо просто ціну (або item.price * quantity якщо ціна за одиницю)

          final progress = totalItems == 0 ? 0.0 : (purchasedItems / totalItems);

          return Column(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => context.pop(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onPressed: () => _showListOptions(context, provider, list!.id),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(list.emoji, style: const TextStyle(fontSize: 24)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                list.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${l10n.createdAt}${list.createdAt.day}.${list.createdAt.month}.${list.createdAt.year}",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                              if (list.description.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  list.description,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard("$purchasedItems/$totalItems", l10n.purchased),
                        _buildStatCard("${totalPrice.toStringAsFixed(0)}₴", l10n.spent),
                        _buildStatCard("${(progress * 100).toInt()}%", l10n.progress),
                      ],
                    ),
                  ],
                ),
              ),

              // ===== Actions =====
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(Icons.add, l10n.add, () => _showAddItemModal(context, provider, list!.id)),
                    _buildActionButton(Icons.person_add_alt_1, l10n.share, () {
                      context.go('/lists/${list!.id}/share');
                    }),
                    _buildActionButton(Icons.notifications_active, l10n.remindBtn, () {
                      context.push('/reminders/create?listId=${list!.id}');
                    }),
                  ],
                ),
              ),

              // ===== List Items =====
              Expanded(
                child: list.items.isEmpty
                    ? Center(child: Text(l10n.listEmptyAddSomething))
                    : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: list.items.length,
                    itemBuilder: (context, index) {
                      final item = list!.items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

                          // === ОСНОВНА ЗМІНА ТУТ ===
                          onTap: () => _onItemTap(provider, list!.id, item),

                          leading: Container(
                            width: 24, height: 24,
                            decoration: BoxDecoration(
                              color: item.isPurchased ? const Color(0xFF8B9DFF) : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: item.isPurchased ? const Color(0xFF8B9DFF) : Colors.grey.shade300, width: 2),
                            ),
                            child: item.isPurchased ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                          ),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: item.isPurchased ? TextDecoration.lineThrough : null,
                              color: item.isPurchased ? Colors.grey : Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${item.quantity} ${item.unit}.", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6))),
                              // Якщо куплено і є ціна, показуємо її
                              if (item.isPurchased && item.price != null && item.price! > 0)
                                Text(
                                  "${l10n.priceLabel}${item.price!.toStringAsFixed(2)} ₴",
                                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
                                )
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.amber, size: 20),
                                onPressed: () => _showEditItemModal(context, provider, list!.id, item),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outline, color: Colors.grey[400], size: 20),
                                onPressed: () {
                                  provider.deleteItem(list!.id, item.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ===== НОВЕ ВІКНО ВВОДУ ЦІНИ =====
  void _showPriceDialog(BuildContext context, ShoppingListsProvider provider, String listId, ShoppingListItem item) {
    _priceInputController.clear();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: Text(
            "${l10n.howMuchDidItCost}${item.name}?",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _priceInputController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: l10n.enterAmount,
                  suffixText: "₴",
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final price = double.tryParse(_priceInputController.text.replaceAll(',', '.')) ?? 0.0;

                // Викликаємо новий метод провайдера
                provider.markAsPurchased(listId, item.id, price);

                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(l10n.confirm, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  // ... (Тут залишаються твої старі методи: _showAddItemModal, _showEditItemModal, _showListOptions, _buildStatCard) ...
  // Щоб не дублювати код, я їх не вставляв, але вони повинні бути тут.

  void _showAddItemModal(BuildContext context, ShoppingListsProvider provider, String listId) {
    _nameController.clear();
    _qtyController.clear();
    final l10n = AppLocalizations.of(context)!;
    String selectedUnit = l10n.unitPcs;
    final List<String> units = [l10n.unitPcs, l10n.unitKg, l10n.unitG, l10n.unitL, l10n.unitMl, l10n.unitPack, l10n.unitCan];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: const EdgeInsets.all(20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: const Icon(Icons.close, size: 20, color: Colors.grey),
                    ),
                  ),
                  Text(l10n.addItemTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: l10n.itemNameHint,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _qtyController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: l10n.qtyShort,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedUnit,
                              isExpanded: true,
                              items: units.map((String value) {
                                return DropdownMenuItem<String>(value: value, child: Text(value));
                              }).toList(),
                              onChanged: (newValue) => setState(() => selectedUnit = newValue!),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.isNotEmpty) {
                          provider.addItem(
                            listId,
                            _nameController.text,
                            double.tryParse(_qtyController.text.replaceAll(',', '.')) ?? 1.0,
                            selectedUnit,
                          );
                          Navigator.pop(ctx);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(l10n.add, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  void _showEditItemModal(BuildContext context, ShoppingListsProvider provider, String listId, ShoppingListItem item) {
    // ... твій код модалки редагування ...
    _nameController.text = item.name;
    _qtyController.text = item.quantity.toString();
    String selectedUnit = item.unit;
    final l10n = AppLocalizations.of(context)!;
    final List<String> units = [l10n.unitPcs, l10n.unitKg, l10n.unitG, l10n.unitL, l10n.unitMl, l10n.unitPack, l10n.unitCan];

    if (!units.contains(selectedUnit)) units.add(selectedUnit);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: const EdgeInsets.all(20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: const Icon(Icons.close, size: 20, color: Colors.grey),
                    ),
                  ),
                  Text(l10n.editItemTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: l10n.itemNameHint,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _qtyController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: l10n.qtyShort,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedUnit,
                              isExpanded: true,
                              items: units.map((String value) {
                                return DropdownMenuItem<String>(value: value, child: Text(value));
                              }).toList(),
                              onChanged: (newValue) => setState(() => selectedUnit = newValue!),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.isNotEmpty) {
                          provider.updateItem(
                            listId,
                            item.id,
                            _nameController.text,
                            double.tryParse(_qtyController.text.replaceAll(',', '.')) ?? 1.0,
                            selectedUnit,
                          );
                          Navigator.pop(ctx);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(l10n.save, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  void _showListOptions(BuildContext context, ShoppingListsProvider provider, String listId) {
    // ... твій код опцій списку ...
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.only(top: 60, right: 20, left: 200),
        alignment: Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMenuOption(l10n.delete, () {
                provider.deleteList(listId);
                Navigator.pop(ctx);
                context.pop();
              }),
              Container(height: 1, color: Colors.white.withOpacity(0.3)),
              _buildMenuOption(l10n.edit, () {
                Navigator.pop(ctx);
                context.push('/lists/$listId/edit');
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}