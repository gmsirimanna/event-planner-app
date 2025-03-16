import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_planner/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OrganizerTileWidget extends StatelessWidget {
  const OrganizerTileWidget({
    super.key,
    required this.name,
    required this.email,
    required this.index,
  });

  final String name;
  final String email;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4),
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: "https://i.pravatar.cc/150?img=${index + 1}", // Random profile image
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.grey),
          ),
        ),
      ),
      title: Text(
        name,
        style: poppinsMedium.copyWith(fontSize: 16),
      ),
      subtitle: Text(
        email,
        style: const TextStyle(color: Colors.black54, fontSize: 14),
      ),
      trailing: const Icon(Icons.chat_bubble_outline, color: Colors.black),
      onTap: () {
        // Open Chat (if needed)
      },
    );
  }
}
