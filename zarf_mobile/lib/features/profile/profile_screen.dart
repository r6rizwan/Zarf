import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations_extensions.dart';
import '../../core/l10n/locale_controller.dart';
import '../../data/models/user.dart';
import '../../data/services/api_service.dart';
import '../../l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await ApiService.instance.getCurrentUser();
    if (mounted) setState(() => _user = user);
  }

  Future<void> _logout() async {
    await ApiService.instance.clearTokens();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final l10n = AppLocalizations.of(context)!;
    final initials =
        _user!.name.isNotEmpty ? _user!.name[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 24),
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _user!.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            _user!.email,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                l10n.roleName(_user!.role).toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.language),
            trailing: DropdownButton<String>(
              value: LocaleController.instance.languageCode,
              items: [
                DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                DropdownMenuItem(value: 'ar', child: Text(l10n.arabic)),
              ],
              onChanged: (value) async {
                if (value != null) {
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    await LocaleController.instance.setLanguageCode(value);
                  } catch (error) {
                    debugPrint('Failed to save language preference: $error');
                    if (mounted) {
                      messenger.showSnackBar(
                        SnackBar(content: Text(l10n.failedToSaveLanguage)),
                      );
                    }
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _logout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red,
            ),
            icon: const Icon(Icons.logout),
            label: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}
