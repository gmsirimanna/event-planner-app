import 'package:event_planner/data/repository/home_repo.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  final HomeRepository homeRepository;
  HomeProvider({required this.homeRepository});

  List<String> _imageUrls = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentImageIndex = 1; // Default index

  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentImageIndex => _currentImageIndex;

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

  /// Update the current image index when slider changes
  void updateImageIndex(int index) {
    _currentImageIndex = index; // CarouselSlider index starts from 0
    notifyListeners();
  }
}
