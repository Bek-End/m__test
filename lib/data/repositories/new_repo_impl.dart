import 'dart:io';

import 'package:dio/dio.dart';
import 'package:m_test/data/dto/new_dto.dart';
import 'package:m_test/data/dto/new_parameters.dart';
import 'package:m_test/domain/repositories/new_repository.dart';
import 'package:m_test/presentation/widgets/error_overlay.dart';

class NewRepoImpl implements NewRepository {
  final Dio dio;
  const NewRepoImpl(this.dio);

  @override
  Future<ResultDto> getAllNews({NewParameters? param}) async {
    try {
      final res = await dio.get(
        '/v2/everything',
        queryParameters: param?.toJson(),
      );
      return ResultDto.fromJson(res.data!);
    } on SocketException {
      showError('Нет подключения к интернету');
      rethrow;
    } catch (e) {
      showError('Ошибка');
      rethrow;
    }
  }

  @override
  Future<ResultDto> getTopNews({NewParameters? param}) async {
    try {
      final res = await dio.get(
        '/v2/top-headlines',
        queryParameters: param?.toJson(),
      );
      return ResultDto.fromJson(res.data!);
    } on SocketException {
      showError('Нет подключения к интернету');
      rethrow;
    } catch (e) {
      showError('Ошибка');
      rethrow;
    }
  }
}
