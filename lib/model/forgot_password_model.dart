class ForgotPasswordModel {
  final bool status;
  final String message;
  final String? token; // Optional token for future use

  ForgotPasswordModel({
    required this.status,
    required this.message,
    this.token,
  });

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (token != null) 'token': token,
    };
  }

  @override
  String toString() {
    return 'ForgotPasswordModel(status: $status, message: $message, token: $token)';
  }
}