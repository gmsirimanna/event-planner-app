import 'package:event_planner/helper/route_helper.dart';
import 'package:event_planner/utils/color_resources.dart';
import 'package:flutter/material.dart';

class PostTileWidget extends StatelessWidget {
  const PostTileWidget({
    super.key,
    required this.context,
    required this.post,
  });

  final BuildContext context;
  final dynamic post;

  @override
  Widget build(BuildContext context) {
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
