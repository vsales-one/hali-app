import 'package:dio/dio.dart';

import 'package:hali/repositories/client_repository.dart';
import 'package:hali/home/index.dart';
import 'package:hali/models/api_response.dart';

class HomeProvider {

  Future<ApiResponse<UserStatisticsDashboardDto>> fetchUserStatisticDashboard(int month) async {
    final client = await ClientRepository.create();
    try {
      final response = await client.get('/api/user/dms-statistics/$month');
      return ApiResponse(data: UserStatisticsDashboardDto.fromJson(response.data));
    }
    on DioError catch(e) {
      return ApiResponse(error: e.message);
    }
  }
}
