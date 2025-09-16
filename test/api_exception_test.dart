import 'package:flutter_test/flutter_test.dart';
import 'package:abstrak/model/api_exception.dart';

void main() {
  group('SignUpException Tests', () {
    test('should create email exists exception with correct message', () {
      final exception = SignUpException.emailExists();
      
      expect(exception.message, contains('email already exists'));
      expect(exception.errorCode, equals('EMAIL_EXISTS'));
    });

    test('should create network error exception', () {
      final exception = SignUpException.networkError();
      
      expect(exception.message, contains('Network connection failed'));
      expect(exception.errorCode, equals('NETWORK_ERROR'));
    });

    test('should create weak password exception', () {
      final exception = SignUpException.weakPassword();
      
      expect(exception.message, contains('Password is too weak'));
      expect(exception.errorCode, equals('WEAK_PASSWORD'));
    });

    test('should create server error exception', () {
      final exception = SignUpException.serverError();
      
      expect(exception.message, contains('Server is temporarily unavailable'));
      expect(exception.errorCode, equals('SERVER_ERROR'));
    });

    test('should create custom exception with message', () {
      final customMessage = 'Custom error message';
      final exception = SignUpException(
        message: customMessage,
        statusCode: 400,
        errorCode: 'CUSTOM_ERROR',
      );
      
      expect(exception.message, equals(customMessage));
      expect(exception.statusCode, equals(400));
      expect(exception.errorCode, equals('CUSTOM_ERROR'));
    });
  });
}