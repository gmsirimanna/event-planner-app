import 'package:event_planner/helper/route_helper.dart';
import 'package:event_planner/provider/post_provider.dart';
import 'package:event_planner/screens/post/post_details_screen.dart';
import 'package:event_planner/utils/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      postProvider.loadPosts(refresh: true);
    });

    // Infinite scrolling for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        postProvider.loadPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  postProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            itemCount: postProvider.isLoadingPosts
                ? 4 // Show shimmer effect for first-time loading
                : postProvider.posts.length + (postProvider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (postProvider.isLoadingPosts) {
                return _buildShimmerPostTile();
              }

              if (index < postProvider.posts.length) {
                final post = postProvider.posts[index];
                return _buildPostTile(post);
              } else {
                // Loader at bottom for pagination
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
        },
      ),
    );
  }

  /// **Shimmer Placeholder**
  Widget _buildShimmerPostTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(18),
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// **Post Tile**
  Widget _buildPostTile(post) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteHelper.getPostDetailRoute(post),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Post #${post.id}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: ColorResources.primaryColor),
                  ),
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    post.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 18, color: ColorResources.primaryColor),
          ],
        ),
      ),
    );
  }
}
