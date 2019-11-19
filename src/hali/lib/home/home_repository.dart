import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:hali/home/index.dart';

class HomeRepository {
  final provider = HomeProvider();

  Future<void> loadAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(new Duration(seconds: 2));
  }

  Future<void> saveAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(new Duration(seconds: 2));
  }

  Future<List<UserStatDto>> fetchUserStatisticDashboard(int month) async {
    final statDtoRes = await provider.fetchUserStatisticDashboard(month);
    final userStatList = List<UserStatDto>();

    if(!statDtoRes.isSuccess) {
      print(statDtoRes.error);
      return userStatList;
    }

    final statDto = statDtoRes.data;

    userStatList.add(UserStatDto(
        totalCount: statDto.totalAssignedCustomer,
        statTitle: statDto.totalAssignedCustomer.toString(),
        statDescription: 'Khách Hàng',
        icon: Icons.group));

    userStatList.add(UserStatDto(
        totalCount: statDto.totalNewCustomerInAMonth,
        statTitle: statDto.totalNewCustomerInAMonth.toString(),
        statDescription: 'Khách Hàng Mới',
        icon: Icons.group_add));

    userStatList.add(UserStatDto(
        totalCount: statDto.totalCustomerWithOrderInAMonth,
        statTitle: statDto.totalCustomerWithOrderInAMonth.toString(),
        statDescription: 'Khách Đã Mua Hàng',
        icon: Icons.add_shopping_cart));

    userStatList.add(UserStatDto(
        totalCount: statDto.totalPercentCustomerVisitInAMonth,
        statTitle: '${statDto.totalPercentCustomerVisitInAMonth}%',
        statDescription: 'Đã Viếng Thăm',
        icon: Icons.location_on));

    userStatList.add(UserStatDto(
        totalCount: statDto.percentSalesTargetInAMonth,
        statTitle: '${statDto.percentSalesTargetInAMonth}%',
        statDescription: 'Chỉ Tiêu Bán Hàng',
        icon: Icons.monetization_on));

    userStatList.add(UserStatDto(
        totalCount: statDto.customerMTGInAMonth,
        statTitle: NumberFormat.compact().format(statDto.customerMTGInAMonth),
        statDescription: 'MTG',
        icon: Icons.directions_run));

    return userStatList;
  }
}
