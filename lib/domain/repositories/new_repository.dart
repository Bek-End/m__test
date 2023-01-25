import 'package:m_test/data/dto/new_dto.dart';
import 'package:m_test/data/dto/new_parameters.dart';

abstract class NewRepository {
  Future<ResultDto> getAllNews({NewParameters? param});
  Future<ResultDto> getTopNews({NewParameters? param});
}
