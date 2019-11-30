
class ApiResponse<TData> {
  final TData data;
  final String errorMgs;
  final String message;
  final dynamic error;

  ApiResponse({this.data, this.errorMgs, this.message, this.error});

  bool get isSuccess => error == null || errorMgs.isEmpty || error == null;

}
