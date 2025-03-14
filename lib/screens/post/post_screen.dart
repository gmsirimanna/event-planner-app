import 'package:event_planner/provider/post_provider.dart';
import 'package:event_planner/screens/post/widgets/post_tile_widget.dart';
import 'package:event_planner/screens/post/widgets/shimmer_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

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
                return PostTileShimmerWidget();
              }

              if (index < postProvider.posts.length) {
                final post = postProvider.posts[index];
                return PostTileWidget(context: context, post: post);
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
}
