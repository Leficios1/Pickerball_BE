class RegisterRequest {
  final String firstName;
  final String lastName;
  final String secondName;
  final String email;
  final String passwordHash;
  final String dateOfBirth;
  final String gender;
  final String phoneNumber;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.secondName,
    required this.email,
    required this.passwordHash,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'secondName': secondName,
      'email': email,
      'passwordHash': passwordHash,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'phoneNumber': phoneNumber,
    };
  }
}
