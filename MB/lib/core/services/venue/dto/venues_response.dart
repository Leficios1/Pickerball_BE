class VenuesResponse {
  final int id;
  final String name;
  final String address;
  final int capacity;
  final String urlImage;
  final int createBy;

  VenuesResponse({
    required this.id,
    required this.name,
    required this.address,
    required this.capacity,
    required this.urlImage,
    required this.createBy,
  });

  factory VenuesResponse.fromJson(Map<String, dynamic> json) {
    return VenuesResponse(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      capacity: json['capacity'],
      urlImage: json['urlImage'],
      createBy: json['createBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'capacity': capacity,
      'urlImage': urlImage,
      'createBy': createBy,
    };
  }
}
