class ApiResponse<TData> {
  final TData data;
  final String error;
  final String message;

  ApiResponse({this.data, this.error, this.message});

  bool get isSuccess => error == null || error.isEmpty;
}
