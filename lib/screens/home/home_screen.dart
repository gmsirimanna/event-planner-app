// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:event_planner/helper/route_helper.dart';
import 'package:event_planner/provider/home_provider.dart';
import 'package:event_planner/provider/post_provider.dart';
import 'package:event_planner/screens/home/widgets/horizontal_image_widget.dart';
import 'package:event_planner/screens/home/widgets/organizer_tile_widget.dart';
import 'package:event_planner/screens/home/widgets/shimmer_widgets.dart';
import 'package:event_planner/screens/post/post_screen.dart';
import 'package:event_planner/utils/color_resources.dart';
import 'package:event_planner/utils/dimensions.dart';
import 'package:event_planner/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initCall();
    });
  }

  Future<void> initCall() async {
    await Provider.of<HomeProvider>(context, listen: false).loadTopImages();
    await Provider.of<HomeProvider>(context, listen: false).loadOrganizers();
    await Provider.of<HomeProvider>(context, listen: false).fetchImagesWithDes();
    await Provider.of<PostProvider>(context, listen: false).loadPostCount();
  }

  /// **Function to refresh data**
  Future<void> _refreshData() async {
    initCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Slider with Shimmer Effect
                  if (homeProvider.isLoading)
                    ShimmerSliderWidget()
                  else if (homeProvider.errorMessage != null)
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 250,
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          textAlign: TextAlign.center,
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
                              placeholder: (context, url) => ShimmerImageWidget(),
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
                      children: [
                        const Text(
                          "Photography Event 2025",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "56 O’Mally Road, ST LEONARDS, 2065, NSW",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 40),
                        // **Organizers Section**
                        const Text(
                          "Organizers",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        homeProvider.isLoadingUsers
                            ? ShimmerOrganizersWidget()
                            : homeProvider.errorMessage != null
                                ? Center(
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      height: 120,
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        homeProvider.errorMessage!,
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: homeProvider.users.length,
                                    separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
                                    itemBuilder: (context, index) {
                                      final user = homeProvider.users[index];
                                      return OrganizerTileWidget(
                                          name: user.name, email: user.email, index: index);
                                    },
                                  ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Images",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteHelper.getAllPhotosRoute(homeProvider.imageUrls, homeProvider.images),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "All Photos",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorResources.primaryColor, // Custom reddish-brown color
                                ),
                              ),
                              const SizedBox(width: 4), // Spacing between text and icon
                              const Icon(
                                Icons.arrow_forward,
                                size: 18,
                                color: ColorResources.primaryColor, // Matching text color
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  // Image List with Shimmer Effect
                  Container(
                    height: 220,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: homeProvider.isLoadingImages
                        ? ShimmerListWidget()
                        : homeProvider.errorMessage != null
                            ? Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 120,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    homeProvider.errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: homeProvider.imageUrls.length,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  try {
                                    final imageWithDes = homeProvider.images[index];
                                    final image = homeProvider.imageUrls[index];
                                    return HorizontalImageTileWidget(
                                        imageUrl: image,
                                        title: imageWithDes.title,
                                        description: imageWithDes.description);
                                  } catch (e) {
                                    return SizedBox();
                                  }
                                },
                              ),
                  ),

                  Consumer<PostProvider>(builder: (context, postProvider, child) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteHelper.post, arguments: PostListScreen());
                      },
                      child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: postProvider.isLoadingCount
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                children: [
                                  Text(
                                    "${postProvider.postCount}",
                                    style: const TextStyle(
                                        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                                  ),
                                  const Text(
                                    "Posts",
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                      ),
                    );
                  }),

                  Divider(),
                  SizedBox(height: 20)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
