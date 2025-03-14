class EventUser {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String company;
  final String address;

  EventUser({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.company,
    required this.address,
  });

  /// **Convert API response to EventUser model**
  factory EventUser.fromJson(Map<String, dynamic> json) {
    return EventUser(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      company: json['company']?['name'] ?? '',
      address: "${json['address']?['street']}, ${json['address']?['city']} ${json['address']?['zipcode']}",
    );
  }

  /// **Convert EventUser to JSON (if needed)**
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "username": username,
      "email": email,
      "phone": phone,
      "website": website,
      "company": company,
      "address": address,
    };
  }
}
