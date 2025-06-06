class SponsorResponse {
  final int id;
  final String name;
  final String? logo;
  final String? description;
  final String website;
  final double donate;

  SponsorResponse({
    required this.id,
    required this.name,
    this.logo,
    this.description,
    required this.website,
    required this.donate,
  });

  factory SponsorResponse.fromJson(Map<String, dynamic> json) {
    return SponsorResponse(
      id: json['id'],
      name: json['name'],
      logo: json['logo'] ?? '',
      description: json['description'] ?? '',
      website: json['website'],
      donate: json['donate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'description': description,
      'website': website,
      'donate': donate,
    };
  }
}
