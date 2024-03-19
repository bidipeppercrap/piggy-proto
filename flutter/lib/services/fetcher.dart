import 'package:piggy_android/store.dart';

Uri apiUri(String endpoint, [Map<String, dynamic>? queries]) {
  return Uri.https('api.piggy-proto.bidipeppercrap.com', endpoint, queries);
}

final Map<String, String> apiHeader = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer ${AccountSession.token}'
};