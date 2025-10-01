class ForgotPasswordModel {
  final bool success;
  final String message;
  final String? token; // Optional token for future use

  ForgotPasswordModel({
    required this.success,
    required this.message,
    this.token,
  });

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (token != null) 'token': token,
    };
  }

  @override
  String toString() {
    return 'ForgotPasswordModel(success: $success, message: $message, token: $token)';
  }
}