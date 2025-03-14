import 'package:dio/dio.dart';
import 'package:event_planner/data/repository/dio/dio_client.dart';

class HomeRepository {
  final DioClient dioClient;
  HomeRepository({required this.dioClient});

  static const String _apiUrl =
      "https://jsonplaceholder.typicode.com/photos?limit=20"; //// SINCE THESE IMAGES ARE NOT WORKING
  static const String _apiUrl2 =
      "https://picsum.photos/v2/list?page=2&limit=10"; // Limited from the URL to 10

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
      throw Exception("Dio Error: $e");
    }
  }

  /// Fetch event organizers list
  Future<List<Map<String, dynamic>>> fetchOrganizers() async {
    try {
      final response = await dioClient.get("https://jsonplaceholder.typicode.com/users");
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw Exception("Failed to load organizers");
    }
  }
}
