import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_planner/data/base/api_response.dart';
import 'package:event_planner/data/model/event_user_model.dart.dart';
import 'package:event_planner/data/model/image_model.dart';
import 'package:event_planner/data/repository/dio/dio_client.dart';
import 'package:event_planner/data/repository/exception/api_error_handler.dart';
import 'package:flutter/services.dart';

class HomeRepository {
  final DioClient dioClient;
  HomeRepository({required this.dioClient});

  static const String GET_IMAGES_WITH_DES = "https://jsonplaceholder.typicode.com/photos?_limit=10";
  static const String _apiUrl2 =
      "https://picsum.photos/v2/list?page=2&limit=10"; // Limited from the URL to 10 (IMAGE URL)

  static const String GET_USERS = "https://jsonplaceholder.typicode.com/users?limit=10";

  Future<List<String>> fetchTopImages() async {
    try {
      final response = await dioClient.get(_apiUrl2);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data; // Ensure it's a list

        if (data.isNotEmpty) {
          List<String> images = data.map((photo) => photo["download_url"].toString()).toList();
          return images;
        } else {
          throw Exception("No images found");
        }
      } else {
        throw Exception("Failed to load images: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(ApiErrorHandler.getMessage(e));
    }
  }

  /// **Fetch event organizers from API**
  Future<List<EventUser>> loadOrganizers() async {
    try {
      final response = await dioClient.get(GET_USERS);

      if (response.statusCode == 200) {
        return (response.data as List).map((user) => EventUser.fromJson(user)).toList();
      } else {
        throw Exception("Failed to load users");
      }
    } catch (e) {
      throw Exception(ApiErrorHandler.getMessage(e));
    }
  }

  /// Fetch images from API and merge with predefined descriptions
  Future<List<ImageModel>> fetchImagesWithDes() async {
    try {
      // Fetch images from API
      final response = await dioClient.get(GET_IMAGES_WITH_DES);

      if (response.statusCode == 200) {
        List<dynamic> imageData = response.data;

        // Read predefined nature descriptions from local JSON file
        String jsonString = await rootBundle.loadString("assets/json/description.json");
        List<dynamic> descriptionsData = json.decode(jsonString);

        // Take the first 10 images from API
        List<dynamic> selectedImages = imageData.toList();

        // Merge images with descriptions
        List<ImageModel> imagesWithDescriptions = selectedImages.asMap().entries.map((entry) {
          int index = entry.key;
          var image = entry.value;
          var description = descriptionsData[index]; // Use the same index to assign a description

          return ImageModel(
            id: image["id"],
            albumId: image["albumId"],
            title: description["title"], // Overwrite title with custom one
            description: description["description"], // Add description
            imageUrl: image["url"],
            thumbnailUrl: image["thumbnailUrl"],
          );
        }).toList();

        return imagesWithDescriptions;
      } else {
        throw Exception("Failed to load images");
      }
    } catch (e) {
      throw Exception(ApiErrorHandler.getMessage(e));
    }
  }
}
