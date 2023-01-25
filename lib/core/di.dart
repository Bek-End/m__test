import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:m_test/data/repositories/local_repo_impl.dart';
import 'package:m_test/data/repositories/new_repo_impl.dart';
import 'package:m_test/domain/repositories/local_repository.dart';
import 'package:m_test/domain/repositories/new_repository.dart';
import 'package:m_test/domain/usecases/new.usecase.dart';

class Di {
  static void init() {
    final getIt = GetIt.I;

    getIt.registerSingleton<Dio>(_getNewService());
    getIt.registerSingleton<NewRepository>(NewRepoImpl(getIt.get()));
    getIt.registerSingleton<NewUseCase>(NewUseCase(getIt.get()));
    getIt.registerSingleton<LocalRepository>(LocalRepoImpl());
  }

  static Future<void> dispose() async {
    return GetIt.I.reset();
  }
}

Dio _getNewService() {
  return Dio(BaseOptions(
    baseUrl: 'https://newsapi.org',
    queryParameters: {
      'q': 'apple',
      'apiKey': 'fdffe402da5846939fa6c9970c52df3b',
    },
  ));
}
