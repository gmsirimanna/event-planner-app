import 'package:event_planner/data/model/comment_model.dart';
import 'package:event_planner/data/model/post_model.dart';
import 'package:event_planner/provider/post_provider.dart';
import 'package:event_planner/screens/post/widgets/comment_list_widget.dart';
import 'package:event_planner/screens/post/widgets/shimmer_widgets.dart';
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
                  CommentShimmerWidget() // Show shimmer if loading
                else if (postProvider.comments.isNotEmpty)
                  CommentListWidget(comments: postProvider.comments)
                else
                  const Center(child: Text("No comments available", style: TextStyle(color: Colors.grey))),
              ],
            ),
          );
        },
      ),
    );
  }
}
