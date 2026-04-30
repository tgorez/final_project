import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/post_cubit.dart';
import '../l10n/app_localizations.dart';
import '../models/post_model.dart';

class FeedTab extends StatefulWidget {
  const FeedTab({super.key});

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PostError) {
          return Center(child: Text(state.message));
        }

        if (state is PostLoaded) {
          if (state.posts.isEmpty) {
            return Center(child: Text(lang.text('noPosts')));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];

              return AnimatedOpacity(
                duration: Duration(milliseconds: 300 + index * 80),
                opacity: 1,
                child: PostCard(post: post),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0.8,
      upperBound: 1.2,
    );

    scaleAnimation = controller;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void likePost() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await controller.forward();
    await controller.reverse();

    if (!mounted) return;

    context.read<PostCubit>().toggleLike(
          post: widget.post,
          userId: user.uid,
        );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isLiked = user != null && widget.post.likedBy.contains(user.uid);
    final lang = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.post.content,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                ScaleTransition(
                  scale: scaleAnimation,
                  child: IconButton(
                    onPressed: likePost,
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.pink : null,
                    ),
                  ),
                ),
                Text('${widget.post.likesCount} ${lang.text('likes')}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}