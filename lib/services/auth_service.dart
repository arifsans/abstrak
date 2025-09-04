class AuthService {
  // Sign in with email and password
  static Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // For demonstration, we'll simulate an API call
      // In a real app, you would make an actual HTTP request to your backend
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, accept any email/password combination
      // In real implementation, you would validate against your backend
      if (email.isNotEmpty && password.length >= 6) {
        return AuthResult(
          success: true,
          message: 'Sign in successful',
          user: User(
            id: '1',
            email: email,
            name: _extractNameFromEmail(email),
          ),
        );
      } else {
        return AuthResult(
          success: false,
          message: 'Invalid credentials',
        );
      }
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
  
  // Example of actual API call (commented out for demo)
  /*
  static Future<AuthResult> _makeApiCall({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/signin'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthResult(
          success: true,
          message: 'Sign in successful',
          user: User.fromJson(data['user']),
          token: data['token'],
        );
      } else {
        final error = jsonDecode(response.body);
        return AuthResult(
          success: false,
          message: error['message'] ?? 'Sign in failed',
        );
      }
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
  */
  
  // Sign out
  static Future<void> signOut() async {
    // Clear any stored tokens, user data, etc.
    // In a real app, you might also call a logout endpoint
    await Future.delayed(const Duration(milliseconds: 500));
  }
  
  // Helper method to extract name from email
  static String _extractNameFromEmail(String email) {
    final parts = email.split('@');
    if (parts.isNotEmpty) {
      final name = parts[0];
      // Capitalize first letter and replace dots/underscores with spaces
      return name
          .replaceAll(RegExp(r'[._]'), ' ')
          .split(' ')
          .map((word) => word.isNotEmpty 
              ? '${word[0].toUpperCase()}${word.substring(1)}' 
              : '')
          .join(' ');
    }
    return 'User';
  }
}

// Auth result model
class AuthResult {
  final bool success;
  final String message;
  final User? user;
  final String? token;
  
  AuthResult({
    required this.success,
    required this.message,
    this.user,
    this.token,
  });
}

// User model
class User {
  final String id;
  final String email;
  final String name;
  
  User({
    required this.id,
    required this.email,
    required this.name,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }
}
