String? validatePassword(String password) {
  // Check if the password length is at least 8 characters
  if (password.length < 8) {
    return 'Password must be at least 8 characters long';
  }

  // Check if the password contains at least one uppercase letter
  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    return 'Password must contain at least one uppercase letter';
  }

  // Check if the password contains at least one lowercase letter
  if (!RegExp(r'[a-z]').hasMatch(password)) {
    return 'Password must contain at least one lowercase letter';
  }

  // Check if the password contains at least one number
  if (!RegExp(r'[0-9]').hasMatch(password)) {
    return 'Password must contain at least one number';
  }

  // Check if the password contains at least one special character
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
    return 'Password must contain at least one special character';
  }

  return null; // Return null if the password is valid
}
