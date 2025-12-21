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

class InteractionException extends ApiException {
  InteractionException({
    required super.message,
    super.statusCode,
    super.errorCode,
    super.details,
  });

  // Factory constructors for common interaction errors
  factory InteractionException.alreadyLiked() {
    return InteractionException(
      message: 'You have already liked this artwork.',
      errorCode: 'ALREADY_LIKED',
    );
  }

  factory InteractionException.notLiked() {
    return InteractionException(
      message: 'You have not liked this artwork yet.',
      errorCode: 'NOT_LIKED',
    );
  }

  factory InteractionException.alreadyFavorited() {
    return InteractionException(
      message: 'You have already favorited this artwork.',
      errorCode: 'ALREADY_FAVORITED',
    );
  }

  factory InteractionException.notFavorited() {
    return InteractionException(
      message: 'You have not favorited this artwork yet.',
      errorCode: 'NOT_FAVORITED',
    );
  }

  factory InteractionException.alreadyBookmarked() {
    return InteractionException(
      message: 'You have already bookmarked this artwork.',
      errorCode: 'ALREADY_BOOKMARKED',
    );
  }

  factory InteractionException.notBookmarked() {
    return InteractionException(
      message: 'You have not bookmarked this artwork yet.',
      errorCode: 'NOT_BOOKMARKED',
    );
  }

  factory InteractionException.artwerkNotFound() {
    return InteractionException(
      message: 'The artwork you are trying to interact with was not found.',
      errorCode: 'ARTWORK_NOT_FOUND',
    );
  }

  factory InteractionException.unauthorizedInteraction() {
    return InteractionException(
      message: 'You are not authorized to perform this interaction.',
      errorCode: 'UNAUTHORIZED_INTERACTION',
    );
  }

  factory InteractionException.networkError() {
    return InteractionException(
      message: 'Network connection failed. Please check your internet connection and try again.',
      errorCode: 'NETWORK_ERROR',
    );
  }

  factory InteractionException.unknown(String? message) {
    return InteractionException(
      message: message ?? 'An unexpected error occurred while processing your interaction.',
      errorCode: 'UNKNOWN_ERROR',
    );
  }
}

class CommentException extends ApiException {
  CommentException({
    required super.message,
    super.statusCode,
    super.errorCode,
    super.details,
  });

  // Factory constructors for common comment errors
  factory CommentException.emptyContent() {
    return CommentException(
      message: 'Comment content cannot be empty.',
      errorCode: 'EMPTY_CONTENT',
    );
  }

  factory CommentException.tooLong() {
    return CommentException(
      message: 'Comment is too long. Please keep it under 500 characters.',
      errorCode: 'TOO_LONG',
    );
  }

  factory CommentException.commentNotFound() {
    return CommentException(
      message: 'The comment you are trying to access was not found.',
      errorCode: 'COMMENT_NOT_FOUND',
    );
  }

  factory CommentException.artwerkNotFound() {
    return CommentException(
      message: 'The artwork you are trying to comment on was not found.',
      errorCode: 'ARTWORK_NOT_FOUND',
    );
  }

  factory CommentException.unauthorizedEdit() {
    return CommentException(
      message: 'You are not authorized to edit this comment.',
      errorCode: 'UNAUTHORIZED_EDIT',
    );
  }

  factory CommentException.unauthorizedDelete() {
    return CommentException(
      message: 'You are not authorized to delete this comment.',
      errorCode: 'UNAUTHORIZED_DELETE',
    );
  }

  factory CommentException.invalidParent() {
    return CommentException(
      message: 'The parent comment you are replying to does not exist.',
      errorCode: 'INVALID_PARENT',
    );
  }

  factory CommentException.maxRepliesDepth() {
    return CommentException(
      message: 'Maximum reply depth reached. You cannot reply to this comment.',
      errorCode: 'MAX_REPLIES_DEPTH',
    );
  }

  factory CommentException.networkError() {
    return CommentException(
      message: 'Network connection failed. Please check your internet connection and try again.',
      errorCode: 'NETWORK_ERROR',
    );
  }

  factory CommentException.unknown(String? message) {
    return CommentException(
      message: message ?? 'An unexpected error occurred while processing your comment.',
      errorCode: 'UNKNOWN_ERROR',
    );
  }
}