import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piggy_android/services/fetcher.dart';
import 'package:piggy_android/types/response.dart';

import '../types/account.dart';

class AccountService {
  static Future<PaginatedResponse<Account>> find([String? name = '', int? page = 1]) async {
    final response = await http.get(
      apiUri('accounts', {
        'name': name,
        'pageNumber': page.toString()
      }),
      headers: apiHeader
    );

    if (response.statusCode == 200) {
      final PaginatedResponse<Account> paginated = PaginatedResponse.fromJson(response.body, Account.fromJsonList);

      return paginated;
    } else {
      throw Exception(response.body);
    }
  }

  static Future<Account> findById(int id, [String? startDate = '', String? endDate = '']) async {
    final response = await http.get(
        apiUri('accounts/$id', {
          'startDate': startDate,
          'endDate': endDate
        }),
        headers: apiHeader
    );

    if (response.statusCode == 200) {
      return Account.fromJson((jsonDecode(response.body))['account']);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<Account> findSelf([String? startDate = '', String? endDate = '']) async {
    final response = await http.get(
        apiUri('accounts', {
          'startDate': startDate,
          'endDate': endDate
        }),
        headers: apiHeader
    );

    if (response.statusCode == 200) {
      return Account.fromJson((jsonDecode(response.body))['account']);
    } else {
      throw Exception(response.body);
    }
  }
}