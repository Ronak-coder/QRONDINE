import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/language_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/helpers.dart';
import '../../config/theme.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
              child: Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: auth.user?.avatar != null
                            ? ClipOval(
                                child: Image.network(
                                  auth.user!.avatar!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 50,
                                color: AppTheme.primaryColor,
                              ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        auth.user?.name ?? 'Guest User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        auth.user?.email ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Account Section
              _buildSectionHeader(context, AppLocalizations.of(context).translate('account_section')),
              _buildMenuItem(
                context,
                icon: Icons.edit,
                title: AppLocalizations.of(context).editProfile,
                onTap: () {
                  Helpers.showSnackBar(context, 'Coming soon!');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.location_on,
                title: AppLocalizations.of(context).translate('manage_addresses'),
                onTap: () {
                  Helpers.showSnackBar(context, 'Coming soon!');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.favorite,
                title: AppLocalizations.of(context).translate('wishlist'),
                onTap: () {
                  Helpers.showSnackBar(context, 'Coming soon!');
                },
              ),
              const SizedBox(height: 24),

              // Preferences Section
              _buildSectionHeader(context, AppLocalizations.of(context).translate('preferences')),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return _buildSwitchMenuItem(
                    context,
                    icon: Icons.dark_mode,
                    title: AppLocalizations.of(context).darkMode,
                    value: userProvider.isDarkMode,
                    onChanged: (value) {
                      userProvider.toggleTheme();
                    },
                  );
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.notifications,
                title: AppLocalizations.of(context).notifications,
                onTap: () {
                  Helpers.showSnackBar(context, 'Coming soon!');
                },
              ),
              Consumer<LanguageProvider>(
                builder: (context, languageProvider, child) {
                  return _buildMenuItem(
                    context,
                    icon: Icons.language,
                    title: AppLocalizations.of(context).language,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          languageProvider.languageName,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () {
                      _showLanguageDialog(context, languageProvider);
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // Support Section
              _buildSectionHeader(context, AppLocalizations.of(context).translate('support')),
              _buildMenuItem(
                context,
                icon: Icons.help,
                title: AppLocalizations.of(context).translate('help_support'),
                onTap: () {
                  Helpers.showSnackBar(context, 'Coming soon!');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.privacy_tip,
                title: AppLocalizations.of(context).translate('privacy_policy'),
                onTap: () {
                  Helpers.showSnackBar(context, 'Coming soon!');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.description,
                title: AppLocalizations.of(context).translate('terms_conditions'),
                onTap: () {
                  Helpers.showSnackBar(context, 'Coming soon!');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.info,
                title: AppLocalizations.of(context).translate('about'),
                onTap: () {
                  Helpers.showSnackBar(context, 'FurnitureHub v1.0.0');
                },
              ),
              const SizedBox(height: 24),

              // Logout Button
              Consumer<AuthProvider>(
                builder: (context, auth, child) {
                  return Card(
                    color: Colors.red.withOpacity(0.1),
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        AppLocalizations.of(context).logout,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(AppLocalizations.of(context).logout),
                            content: Text(AppLocalizations.of(context).translate('logout_confirmation')),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(AppLocalizations.of(context).cancel),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await auth.logout();
                                  if (context.mounted) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                },
                                child: const Text(
                                  'Logout',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Row(
                children: [
                  Text('🇬🇧'),
                  SizedBox(width: 12),
                  Text('English'),
                ],
              ),
              value: 'en',
              groupValue: languageProvider.locale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  languageProvider.changeLanguage(value);
                  Navigator.pop(context);
                  Helpers.showSnackBar(context, 'Language changed to English');
                }
              },
            ),
            RadioListTile<String>(
              title: const Row(
                children: [
                  Text('🇮🇳'),
                  SizedBox(width: 12),
                  Text('हिंदी (Hindi)'),
                ],
              ),
              value: 'hi',
              groupValue: languageProvider.locale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  languageProvider.changeLanguage(value);
                  Navigator.pop(context);
                  Helpers.showSnackBar(context, 'भाषा हिंदी में बदल गई');
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
