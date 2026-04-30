import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/settings_cubit.dart';
import '../l10n/app_localizations.dart';
import '../models/post_model.dart';
import '../services/local_storage_service.dart';
import '../services/post_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final localStorageService = LocalStorageService();
  final postService = PostService();

  String username = 'User';

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  Future<void> loadUsername() async {
    final name = await localStorageService.getUsername();

    if (!mounted) return;

    setState(() {
      username = name;
    });
  }

  Future<void> editUsername() async {
    final controller = TextEditingController(text: username);

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit username'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text.trim());
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      await localStorageService.saveUsername(result);

      if (!mounted) return;

      setState(() {
        username = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(username),
              subtitle: Text(user?.email ?? ''),
              trailing: IconButton(
                onPressed: editUsername,
                icon: const Icon(Icons.edit),
              ),
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return SwitchListTile(
                title: Text(lang.text('darkMode')),
                value: state.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  context.read<SettingsCubit>().changeTheme(value);
                },
              );
            },
          ),
          ListTile(
            title: Text(lang.text('language')),
            trailing: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return DropdownButton<String>(
                  value: state.locale.languageCode,
                  items: const [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'ru',
                      child: Text('Русский'),
                    ),
                    DropdownMenuItem(
                      value: 'kk',
                      child: Text('Қазақша'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<SettingsCubit>().changeLanguage(value);
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                context.read<AuthCubit>().logout();
              },
              icon: const Icon(Icons.logout),
              label: Text(lang.text('logout')),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            lang.text('userPosts'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (user != null)
            StreamBuilder<List<PostModel>>(
              stream: postService.getUserPosts(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final posts = snapshot.data ?? [];

                if (posts.isEmpty) {
                  return Text(lang.text('noPosts'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];

                    return Card(
                      child: ListTile(
                        title: Text(post.content),
                        subtitle: Text('${post.likesCount} ${lang.text('likes')}'),
                      ),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}