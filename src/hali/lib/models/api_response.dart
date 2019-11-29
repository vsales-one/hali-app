class ApiResponse<TData, E> {
  final TData data;
  final String errorMgs;
  final String message;
  final E error;

  ApiResponse({this.data, this.errorMgs, this.message, this.error});

  bool get isSuccess => error == null || errorMgs.isEmpty || error == null;
}
