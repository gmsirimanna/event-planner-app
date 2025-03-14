import 'package:event_planner/data/model/event_user_model.dart.dart';
import 'package:event_planner/data/model/image_model.dart';
import 'package:event_planner/data/repository/home_repo.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  final HomeRepository homeRepository;
  HomeProvider({required this.homeRepository});

  List<String> _imageUrls = [];
  bool _isLoading = true;
  bool _isLoadingUsers = true;
  bool _isLoadingImages = true;
  String? _errorMessage;
  int _currentImageIndex = 1; // Default index
  List<EventUser> users = [];

  List<ImageModel> _images = [];

  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  bool get isLoadingUsers => _isLoadingUsers;
  bool get isLoadingImages => _isLoadingImages;
  String? get errorMessage => _errorMessage;
  int get currentImageIndex => _currentImageIndex;

  List<ImageModel> get images => _images;

  Future<void> loadTopImages() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _imageUrls = await homeRepository.fetchTopImages();
    } catch (e) {
      _errorMessage = "Failed to load images";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// **Load users from API**
  Future<void> loadOrganizers() async {
    try {
      users.clear();
      _isLoadingUsers = true;
      notifyListeners();

      users = await homeRepository.loadOrganizers();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingUsers = false;
      notifyListeners();
    }
  }

  /// Update the current image index when slider changes
  void updateImageIndex(int index) {
    _currentImageIndex = index; // CarouselSlider index starts from 0
    notifyListeners();
  }

  /// Load images from the repository
  Future<void> fetchImagesWithDes() async {
    try {
      _isLoadingImages = true;
      notifyListeners();

      _images = await homeRepository.fetchImagesWithDes();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingImages = false;
      notifyListeners();
    }
  }
}
