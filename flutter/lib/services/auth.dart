import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:piggy_android/services/fetcher.dart';

class Token {
  final String token;

  const Token({
    required this.token
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'token': String token,
      } =>
        Token(
          token: token
        ),
      _ => throw const FormatException('Failed to load token')
    };
  }
}

Future<Token> submitCredential(String username, String password) async {
  final response = await http.post(apiUri('login'),
    headers: {
      'Content-Type': 'application/json'
    },
    body: jsonEncode({
      'username': username,
      'password': password
    }),
  );

  if (response.statusCode == 200) {
    return Token.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to login');
  }
}