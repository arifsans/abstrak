enum ApiStatus { initial, loading, success, error }

class ApiState<T> {
  final ApiStatus status;
  final T? data;
  final String? error;

  const ApiState({
    required this.status,
    this.data,
    this.error,
  });

  factory ApiState.initial() => const ApiState(status: ApiStatus.initial);
  factory ApiState.loading() => const ApiState(status: ApiStatus.loading);
  factory ApiState.success(T data) => ApiState(status: ApiStatus.success, data: data);
  factory ApiState.error(String message) => ApiState(status: ApiStatus.error, error: message);
}
