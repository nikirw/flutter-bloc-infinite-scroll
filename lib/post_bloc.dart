import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_infinite_scroll/post_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_infinite_scroll/post_model.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter_bloc_infinite_scroll/post_event.dart';
import 'package:flutter_bloc_infinite_scroll/post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {

  final _repository = PostRepository();

  @override
  // TODO: implement initialState
  PostState get initialState => PostUninitialized();

  @override
  Stream<PostState> transform(
    Stream<PostEvent> events,
    Stream<PostState> Function(PostEvent event) next,
  ) {
    return super.transform(
      (events as Observable<PostEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PostUninitialized) {
          final posts = await _repository.fetchPosts(0, 20);
          yield PostLoaded(posts: posts, hasReachedMax: false);
          return;
        }
        if (currentState is PostLoaded) {
          final posts =
              await _repository.fetchPosts((currentState as PostLoaded).posts.length, 20);
          yield posts.isEmpty
              ? (currentState as PostLoaded).copyWith(hasReachedMax: true)
              : PostLoaded(
                  posts: (currentState as PostLoaded).posts + posts,
                  hasReachedMax: false,
                );
        }
      } catch (_) {
        yield PostError();
      }
    }
  }

  bool _hasReachedMax(PostState state) =>
    state is PostLoaded && state.hasReachedMax;

}