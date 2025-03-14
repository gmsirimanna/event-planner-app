import 'package:event_planner/data/model/comment_model.dart';
import 'package:event_planner/data/model/post_model.dart';
import 'package:event_planner/data/repository/exception/api_error_handler.dart';
import 'package:event_planner/data/repository/post_repo.dart';
import 'package:flutter/material.dart';

class PostProvider with ChangeNotifier {
  final PostRepository postRepository;
  PostProvider({required this.postRepository});

  int _postCount = 0;
  int get postCount => _postCount;

  bool _isLoadingCount = false;
  bool get isLoadingCount => _isLoadingCount;

  // Pagination
  List<PostModel> _posts = [];
  bool _isLoadingPosts = false;
  int _currentPage = 1;
  bool _hasMore = true; // Indicates if more data is available

  List<PostModel> get posts => _posts;
  bool get isLoadingPosts => _isLoadingPosts;
  bool get hasMore => _hasMore;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<CommentModel> _comments = [];
  bool _isLoading = false;

  List<CommentModel> get comments => _comments;
  bool get isLoading => _isLoading;

  /// Load post count for display on Home Screen
  Future<void> loadPostCount() async {
    try {
      _isLoadingCount = true;
      notifyListeners();

      _postCount = await postRepository.fetchPostCount();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = ApiErrorHandler.getMessage(e);
    } finally {
      _isLoadingCount = false;
      notifyListeners();
    }
  }

  /// Load initial posts
  Future<void> loadPosts({bool refresh = false}) async {
    if (refresh) {
      _posts.clear();
      _currentPage = 1;
      _hasMore = true;
    }
    if (!_hasMore) return;

    try {
      _isLoadingPosts = _currentPage == 1 ? true : false;
      notifyListeners();

      List<PostModel> newPosts = await postRepository.fetchPosts(_currentPage, limit: 10);
      if (newPosts.isEmpty) {
        _hasMore = false;
      } else {
        _currentPage++;
        _posts.addAll(newPosts);
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = ApiErrorHandler.getMessage(e);
    } finally {
      _isLoadingPosts = false;
      notifyListeners();
    }
  }

  Future<void> loadComments(int postId) async {
    try {
      _comments.clear();
      _isLoading = true;
      notifyListeners();
      _comments = await postRepository.fetchComments(postId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = ApiErrorHandler.getMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
