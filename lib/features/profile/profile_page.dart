import 'package:buy_tracker/core/providers/AuthProvider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:buy_tracker/l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AppAuthProvider>();
    final user = authProvider.currentUser;
    final l10n = AppLocalizations.of(context)!;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, user),

            _buildSectionTitle(context, l10n.profileInfo),
            _buildInfoCard(
              context,
              children: [
                _buildInfoRow(context, l10n.profileName, user.displayName ?? 'User'),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildInfoRow(context, "Email", user.email ?? ''),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildInfoRow(
                  context,
                  l10n.profileRegDate,
                  user.metadata.creationTime != null
                      ? "${user.metadata.creationTime!.day}.${user.metadata.creationTime!.month}.${user.metadata.creationTime!.year}"
                      : l10n.profileUnknownDate,
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildSectionTitle(context, l10n.profileActions),
            _buildInfoCard(
              context,
              children: [
                _buildActionRow(context, Icons.notifications_none, l10n.profileReminders, () => context.go('/reminders')),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildActionRow(context, Icons.settings_outlined, l10n.profileSettings, () => context.push('/settings')),
              ],
            ),

            const SizedBox(height: 24),

            _buildLogoutButton(context, authProvider.signOut),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, User user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 25, bottom: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.go("/"),
              ),
            ),
          ),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withOpacity(0.3),
            backgroundImage: user.photoURL != null && user.photoURL!.isNotEmpty
                ? NetworkImage(user.photoURL!)
                : null,
            child: user.photoURL == null || user.photoURL!.isEmpty
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            user.displayName ?? 'User',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6))),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6)),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6)),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context, VoidCallback onLogout) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF85D6A),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: onLogout,
        child: Text(
          l10n.profileLogout,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}