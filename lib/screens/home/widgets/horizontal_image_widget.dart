import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_planner/screens/home/widgets/shimmer_widgets.dart';
import 'package:flutter/material.dart';

class HorizontalImageTileWidget extends StatelessWidget {
  const HorizontalImageTileWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  final String imageUrl;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Colors.grey.shade300, width: 0.5), // Left border
          top: BorderSide(color: Colors.grey.shade300, width: 1), // Top border
          bottom: BorderSide(color: Colors.grey.shade300, width: 1), // Bottom border
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => ShimmerImageWidget(),
              errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 50),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          // Des
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
