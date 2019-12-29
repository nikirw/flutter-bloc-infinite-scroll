import 'dart:async';
import 'package:flutter_bloc_infinite_scroll/post_api.dart';
import 'package:flutter_bloc_infinite_scroll/post_model.dart';

class PostRepository {
  final postApi = PostApi();

  Future<List<Post>> fetchPosts(int startIndex, int limit) => postApi.fetchPosts(startIndex, limit);
}