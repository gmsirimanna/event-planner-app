import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostTileShimmerWidget extends StatelessWidget {
  const PostTileShimmerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
}

class CommentShimmerWidget extends StatelessWidget {
  const CommentShimmerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
}
