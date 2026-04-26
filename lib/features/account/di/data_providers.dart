import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/remote/account_remote_data_source.dart';
import 'infra_providers.dart';

final accountRemoteDataSourceProvider = Provider<AccountRemoteDataSource>(
  (ref) => AccountRemoteDataSource(ref.watch(accountFirestoreProvider)),
);
