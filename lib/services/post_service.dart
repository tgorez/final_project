import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _postsCollection => _firestore.collection('posts');

  Stream<List<PostModel>> getPosts() {
    return _postsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
    });
  }

  Future<void> createPost({
    required String userId,
    required String username,
    required String content,
  }) async {
    final docRef = _postsCollection.doc();

    final post = PostModel(
      postId: docRef.id,
      userId: userId,
      username: username,
      content: content,
      createdAt: DateTime.now(),
      likesCount: 0,
      likedBy: [],
    );

    await docRef.set(post.toMap());
  }

  Future<void> toggleLike({
    required PostModel post,
    required String userId,
  }) async {
    final postRef = _postsCollection.doc(post.postId);
    final alreadyLiked = post.likedBy.contains(userId);

    if (alreadyLiked) {
      await postRef.update({
        'likesCount': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([userId]),
      });
    } else {
      await postRef.update({
        'likesCount': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Stream<List<PostModel>> getUserPosts(String userId) {
    return _postsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
    });
  }
}