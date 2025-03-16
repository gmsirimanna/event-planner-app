class ImageModel {
  final int id;
  final int albumId;
  final String title;
  final String description;
  final String imageUrl;
  final String thumbnailUrl;

  ImageModel({
    required this.id,
    required this.albumId,
    required this.title,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.description,
  });

  /// **Factory method to create an `ImageModel` from a JSON object**
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] as int,
      albumId: json['albumId'] as int,
      title: json['title'] as String,
      imageUrl: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      description: json['description'] ?? "", // Fallback if description is missing
    );
  }

  /// **Method to convert an `ImageModel` instance to JSON format**
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'albumId': albumId,
      'title': title,
      'url': imageUrl,
      'thumbnailUrl': thumbnailUrl,
      'description': description,
    };
  }
}
