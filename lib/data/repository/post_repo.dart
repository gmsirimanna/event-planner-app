import 'package:dio/dio.dart';
import 'package:event_planner/data/model/comment_model.dart';
import 'package:event_planner/data/model/post_model.dart';
import 'package:event_planner/data/repository/dio/dio_client.dart';

class PostRepository {
  final DioClient dioClient;
  PostRepository({required this.dioClient});
  static const String baseUrl = "https://jsonplaceholder.typicode.com/posts";

  /// Fetch posts with pagination
  Future<List<PostModel>> fetchPosts(int page, {int limit = 10}) async {
    // Example approach: fetch all posts, then slice.
    // Real APIs often support query params like ?_page=page&_limit=limit
    final response = await dioClient.get(baseUrl);
    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      // Start index for pagination
      int startIndex = (page - 1) * limit;
      int endIndex = startIndex + limit;
      if (startIndex >= data.length) return []; // No more data
      if (endIndex > data.length) endIndex = data.length;

      // Convert sliced data to PostModel
      return data.sublist(startIndex, endIndex).map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load posts");
    }
  }

  /// Fetch total post count
  Future<int> fetchPostCount() async {
    final response = await dioClient.get(baseUrl);
    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.length;
    } else {
      throw Exception("Failed to load post count");
    }
  }

  static const String COMMENTS_URL = "https://jsonplaceholder.typicode.com/comments";

  /// Fetch comments for a specific post
  Future<List<CommentModel>> fetchComments(int postId) async {
    final response = await dioClient.get(COMMENTS_URL);
    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      // Filter comments by postId
      List<dynamic> filtered = data.where((item) => item['postId'] == postId).toList();
      return filtered.map((json) => CommentModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load comments");
    }
  }
}
