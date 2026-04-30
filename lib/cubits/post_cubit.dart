import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<PostModel> posts;

  PostLoaded(this.posts);
}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}

class PostCubit extends Cubit<PostState> {
  final PostService postService;
  StreamSubscription<List<PostModel>>? _postsSubscription;

  PostCubit({required this.postService}) : super(PostInitial());

  void loadPosts() {
    emit(PostLoading());

    _postsSubscription?.cancel();

    _postsSubscription = postService.getPosts().listen(
      (posts) {
        emit(PostLoaded(posts));
      },
      onError: (error) {
        emit(PostError(error.toString()));
      },
    );
  }

  Future<void> createPost({
    required String userId,
    required String username,
    required String content,
  }) async {
    try {
      await postService.createPost(
        userId: userId,
        username: username,
        content: content,
      );
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> toggleLike({
    required PostModel post,
    required String userId,
  }) async {
    try {
      await postService.toggleLike(
        post: post,
        userId: userId,
      );
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}