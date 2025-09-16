class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final Map<String, dynamic>? details;

  ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.details,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode, Code: $errorCode)';
  }
}

class SignUpException extends ApiException {
  SignUpException({
    required super.message,
    super.statusCode,
    super.errorCode,
    super.details,
  });

  // Factory constructors for common signup errors
  factory SignUpException.emailExists() {
    return SignUpException(
      message: 'An account with this email already exists. Please use a different email or try signing in.',
      errorCode: 'EMAIL_EXISTS',
    );
  }

  factory SignUpException.weakPassword() {
    return SignUpException(
      message: 'Password is too weak. Please use a stronger password with at least 8 characters, including uppercase, lowercase, and numbers.',
      errorCode: 'WEAK_PASSWORD',
    );
  }

  factory SignUpException.invalidEmail() {
    return SignUpException(
      message: 'Please enter a valid email address.',
      errorCode: 'INVALID_EMAIL',
    );
  }

  factory SignUpException.invalidPhone() {
    return SignUpException(
      message: 'Please enter a valid phone number.',
      errorCode: 'INVALID_PHONE',
    );
  }

  factory SignUpException.networkError() {
    return SignUpException(
      message: 'Network connection failed. Please check your internet connection and try again.',
      errorCode: 'NETWORK_ERROR',
    );
  }

  factory SignUpException.serverError() {
    return SignUpException(
      message: 'Server is temporarily unavailable. Please try again later.',
      errorCode: 'SERVER_ERROR',
    );
  }

  factory SignUpException.unknown(String? message) {
    return SignUpException(
      message: message ?? 'An unexpected error occurred. Please try again.',
      errorCode: 'UNKNOWN_ERROR',
    );
  }
}