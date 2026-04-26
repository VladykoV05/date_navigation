import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/account_repository_impl.dart';
import '../domain/repositories/account_repository.dart';
import 'data_providers.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => AccountRepositoryImpl(ref.watch(accountRemoteDataSourceProvider)),
);
