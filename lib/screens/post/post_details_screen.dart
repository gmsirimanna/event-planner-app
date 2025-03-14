import 'package:event_planner/data/model/comment_model.dart';
import 'package:event_planner/data/model/post_model.dart';
import 'package:event_planner/provider/post_provider.dart';
import 'package:event_planner/utils/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel? post;

  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostProvider>(context, listen: false).loadComments(widget.post!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Post #${widget.post!.id}",
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post Details Section
                Text(
                  widget.post!.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.post!.body,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                const Divider(),

                // Comments Section
                const Text(
                  "Comments",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: ColorResources.primaryColor),
                ),
                const SizedBox(height: 8),

                if (postProvider.isLoading)
                  _buildShimmerComments() // Show shimmer if loading
                else if (postProvider.comments.isNotEmpty)
                  _buildCommentList(postProvider.comments)
                else
                  const Center(child: Text("No comments available", style: TextStyle(color: Colors.grey))),
              ],
            ),
          );
        },
      ),
    );
  }

  /// **Shimmer Loading for Comments**
  Widget _buildShimmerComments() {
    return Column(
      children: List.generate(
        3,
        (index) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 100, color: Colors.white), // Name Placeholder
                const SizedBox(height: 4),
                Container(height: 12, width: double.infinity, color: Colors.white), // Comment Placeholder
                const SizedBox(height: 4),
                Container(height: 12, width: 200, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// **Build Comment List**
  Widget _buildCommentList(List<CommentModel> comments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: comments
          .map(
            (comment) => Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.body,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
