class SponnerRequest {
  final int id;
  final String companyName;
  final String? logoUrl;
  final String urlSocial;
  final String? urlSocial1;
  final String contactEmail;
  final String descreption;

  SponnerRequest({
    required this.id,
    required this.companyName,
    this.logoUrl,
    required this.urlSocial,
    this.urlSocial1,
    required this.contactEmail,
    required this.descreption,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'logoUrl': logoUrl,
      'urlSocial': urlSocial,
      'urlSocial1': urlSocial1,
      'contactEmail': contactEmail,
      'descreption': descreption,
    };
  }
}
