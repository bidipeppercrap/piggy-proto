import 'dart:convert';

class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.count,
    required this.data,
  });

  final int count;
  final List<T> data;

  factory PaginatedResponse.fromJson(json, T Function(Map<String, dynamic>) converter) {
    final decoded = jsonDecode(json);
    final List<T> convertedData = [];

    for (final d in decoded['data']) {
      final T converted = converter(d as Map<String, dynamic>);

      convertedData.add(converted);
    }

    return PaginatedResponse(
        count: decoded['count'],
        data: convertedData
    );
  }
}