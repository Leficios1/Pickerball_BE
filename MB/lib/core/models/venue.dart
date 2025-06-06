class Venues {
  int id;
  String name;
  String address;
  int capacity;
  String? urlImage;
  int createBy;

  Venues({
    required this.id,
    required this.name,
    required this.address,
    required this.capacity,
    this.urlImage,
    required this.createBy,
  });

  factory Venues.fromJson(Map<String, dynamic> json) {
    return Venues(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      capacity: json['capacity'] as int,
      urlImage: json['urlImage'] as String?,
      createBy: json['createBy'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'capacity': capacity,
    };
  }
}
