class UpdateUserRequest {
  final String? firstName;
  final String? lastName;
  final String? secondName;
  final String? avatarUrl;

  UpdateUserRequest({
    this.firstName,
    this.lastName,
    this.secondName,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (secondName != null) data['secondName'] = secondName;
    if (avatarUrl != null) data['avatarUrl'] = avatarUrl;
    return data;
  }

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) {
    return UpdateUserRequest(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      secondName: json['secondName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}