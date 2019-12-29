import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_infinite_scroll/post_model.dart';
import 'package:http/http.dart' show Client;

class PostApi {
  Client client = Client();

  Future<List<Post>> fetchPosts(int startIndex, int limit) async {
    final _url = 'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit';
    final response = await client.get(_url);
    if (response.statusCode == 200) {
      return compute(postFromJson, response.body);
    } else {
      throw Exception('error fetching posts');
    }
  }
}