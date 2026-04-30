import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/post_cubit.dart';
import '../l10n/app_localizations.dart';
import '../services/local_storage_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final localStorageService = LocalStorageService();

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  Future<void> createPost() async {
    if (!formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final username = await localStorageService.getUsername();

    if (!mounted) return;

    await context.read<PostCubit>().createPost(
          userId: user.uid,
          username: username,
          content: contentController.text.trim(),
        );

    contentController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post created')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.text('createPost'),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: contentController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: lang.text('postHint'),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Post cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: createPost,
                icon: const Icon(Icons.send),
                label: Text(lang.text('post')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}