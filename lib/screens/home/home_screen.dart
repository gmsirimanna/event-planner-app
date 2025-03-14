import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:event_planner/provider/home_provider.dart';
import 'package:event_planner/utils/dimensions.dart';
import 'package:event_planner/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).loadTopImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Slider with Shimmer Effect
              if (homeProvider.isLoading)
                _buildShimmerSlider()
              else if (homeProvider.errorMessage != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      homeProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
              else if (homeProvider.imageUrls.isNotEmpty)
                Stack(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 250.0,
                        autoPlay: true,
                        viewportFraction: 1.0,
                        onPageChanged: (index, reason) {
                          homeProvider.updateImageIndex(index);
                        },
                        // enlargeCenterPage: false,
                      ),
                      items: homeProvider.imageUrls.map((imageUrl) {
                        return CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => _buildShimmerImage(),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image_not_supported_rounded,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      }).toList(),
                    ),
                    // Image count indicator
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "${homeProvider.currentImageIndex} / ${homeProvider.imageUrls.length}", // Updates dynamically
                          textAlign: TextAlign.center,
                          style: poppinsMedium.copyWith(
                              color: Colors.black, fontSize: Dimensions.FONT_SIZE_DEFAULT),
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 16),

              // Event Title & Address
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Tech Conference 2025",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "56 O’Mally Road, ST LEONARDS, 2065, NSW",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// **Shimmer Effect for Image Loading**
  Widget _buildShimmerImage() {
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

  /// **Shimmer for Entire Slider**
  Widget _buildShimmerSlider() {
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
