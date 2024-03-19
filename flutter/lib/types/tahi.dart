import 'package:piggy_android/types/entry.dart';

class Tahi {
  Tahi({
    this.message
  });

  String? message = '';

  factory Tahi.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'message': String? message
      } => Tahi(
          message: message
      ),
      _ => throw const FormatException('Failed to load tahi')
    };
  }
}