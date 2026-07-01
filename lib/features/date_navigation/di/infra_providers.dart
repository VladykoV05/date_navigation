import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

export '../../../core/di/firestore_di.dart';

part 'infra_providers.g.dart';

@Riverpod(keepAlive: true)
http.Client httpClient(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
}
