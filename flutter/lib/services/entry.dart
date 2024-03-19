import 'dart:convert';

import 'package:http/http.dart' as http;

import 'fetcher.dart';

class EntryService {
  static Future<void> transfer(int fromId, int toId, double amount, String description) async {
    final response = await http.post(
      apiUri('entries'),
      headers: apiHeader,
      body: jsonEncode({
        'description': description,
        'amount': amount,
        'debtor_id': toId,
        'creditor_id': fromId
      })
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.body);
    }
  }

  static Future<void> deleteEntry(int id) async {
    final response = await http.delete(
      apiUri('entries/$id'),
      headers: apiHeader
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.body);
    }
  }
}