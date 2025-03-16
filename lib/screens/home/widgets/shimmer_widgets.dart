import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerOrganizersWidget extends StatelessWidget {
  const ShimmerOrganizersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3, // Show shimmer for 3 placeholder organizers
      itemBuilder: (context, index) {
        return ListTile(
          leading: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: const CircleAvatar(radius: 25, backgroundColor: Colors.white),
          ),
          title: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(height: 14, width: 100, color: Colors.white),
          ),
          subtitle: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(height: 12, width: 150, color: Colors.white),
          ),
          trailing: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          ),
        );
      },
    );
  }
}

class ShimmerListWidget extends StatelessWidget {
  const ShimmerListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          width: 150,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 12,
                  width: 100,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ShimmerImageWidget extends StatelessWidget {
  const ShimmerImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 250,
        width: double.infinity,
        color: Colors.white,
      ),
    );
  }
}

class ShimmerSliderWidget extends StatelessWidget {
  const ShimmerSliderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 250,
        width: double.infinity,
        color: Colors.white,
      ),
    );
  }
}
