import 'dart:convert';

import 'package:piggy_android/types/entry.dart';

class Account {
  Account({
    this.id,
    required this.name,
    required this.username,
    this.password,
    required this.role,
    this.totalDebit,
    this.totalCredit,
    this.totalQueryDebit,
    this.totalQueryCredit,
    this.entries
  });

  int? id;
  final String name;
  final String username;
  String? password;
  final String role;
  double? totalDebit;
  double? totalCredit;
  double? totalQueryDebit;
  double? totalQueryCredit;
  List<Entry>? entries;

  factory Account.fromJwt(Map<String, dynamic> decoded) {
    return switch (decoded) {
      {
      'id': int? id,
      'name': String name,
      'username': String username,
      'role': String role
      } => Account(
          id: id,
          name: name,
          username: username,
          role: role
      ),
      _ => throw const FormatException('cannot load account jwt')
    };
  }

  factory Account.fromJsonList(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int? id,
        'name': String name,
        'username': String username,
        'role': String role,
        'total_debit': String? totalDebit?,
        'total_credit': String? totalCredit?
      } => Account(
        id: id,
        name: name,
        username: username,
        role: role,
        totalDebit: totalDebit != null ? double.parse(totalDebit) : null,
        totalCredit: totalCredit != null ? double.parse(totalCredit) : null
      ),
      _ => throw const FormatException('cannot load account list')
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    List<Entry> entries = [];
    double totalDebit = double.parse(json['total_debit'].toString());
    double totalCredit = double.parse(json['total_credit'].toString());
    double totalQueryDebit = double.parse(json['total_query_debit'].toString());
    double totalQueryCredit = double.parse(json['total_query_credit'].toString());


    for(final entry in json['entries']) {
      entries.add(Entry.fromJson(entry));
    }

    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'username': String username,
        'role': String role
      } => Account(
        id: id,
        name: name,
        username: username,
        role: role,
        totalDebit: totalDebit,
        totalCredit: totalCredit,
        totalQueryDebit: totalQueryDebit,
        totalQueryCredit: totalQueryCredit,
        entries: entries
      ),
      _ => throw const FormatException('Failed to load account')
    };
  }
}