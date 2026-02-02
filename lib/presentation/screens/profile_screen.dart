import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ecomservics/presentation/blocs/profile_bloc.dart';
import 'package:ecomservics/presentation/blocs/theme_bloc.dart';
import 'package:ecomservics/presentation/blocs/language_bloc.dart';
import 'package:ecomservics/presentation/blocs/auth_bloc.dart';
import 'package:ecomservics/generated/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<ProfileBloc>()..add(LoadProfile()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(state.avatarUrl),
                        onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 50),
                      ),
                      const SizedBox(height: 16),
                      Text(state.name, style: Theme.of(context).textTheme.headlineSmall),
                      Text(state.email, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Settings List
                ListTile(
                  leading: const Icon(Icons.article_outlined),
                  title: const Text('My Blogs'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.language),
                  trailing: BlocBuilder<LanguageBloc, LanguageState>(
                    builder: (context, langState) {
                      return DropdownButton<Locale>(
                        value: langState.locale,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: Locale('en'), child: Text('English')),
                          DropdownMenuItem(value: Locale('fr'), child: Text('Français')),
                          DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
                        ],
                        onChanged: (Locale? value) {
                          if (value != null) {
                            context.read<LanguageBloc>().add(ChangeLanguage(value));
                          }
                        },
                      );
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: const Text('Currency'),
                  trailing: const Text('USD'), // Static for now
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.policy_outlined),
                  title: const Text('Refund Policy'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms & Services'),
                  onTap: () {},
                ),
                 ListTile(
                  leading: const Icon(Icons.brightness_6),
                  title: Text(l10n.theme),
                  trailing: BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, themeState) {
                      return Switch(
                        value: themeState.themeMode == ThemeMode.dark,
                        onChanged: (value) {
                          context.read<ThemeBloc>().add(ChangeTheme(value ? ThemeMode.dark : ThemeMode.light));
                        },
                      );
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(l10n.settings),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
                  onTap: () {
                     context.read<AuthBloc>().add(LogoutEvent());
                     // Navigate to login handled by listener or explicitly
                     // In main app logic, AuthBloc state change should redirect.
                     // For now, static logout logic.
                  },
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
