class Sponner {
  String companyName;
  String? logoUrl;
  String urlSocial;
  String? urlSocial1;
  String contactEmail;
  String? description;
  bool isAccept;
  DateTime joinedAt;

  Sponner({
    required this.companyName,
    this.logoUrl,
    required this.urlSocial,
    this.urlSocial1,
    required this.contactEmail,
    this.description,
    required this.isAccept,
    required this.joinedAt,
  });

  factory Sponner.fromJson(Map<String, dynamic> json) {
    return Sponner(
      companyName: json['companyName'] as String,
      logoUrl: json['logoUrl'] as String?,
      contactEmail: json['contactEmail'] as String,
      description: json['description'] as String?,
      isAccept: json['isAccept'] as bool,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      urlSocial: json['urlSocial'] as String,
      urlSocial1: json['urlSocial1'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'logoUrl': logoUrl,
      'contactEmail': contactEmail,
      'description': description,
      'isAccept': isAccept,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}
