import 'package:m_test/domain/entities/new_entity.dart';

abstract class LocalRepository {
  Future<List<NewEntity>> readNews();
  Future<void> writeNew(NewEntity newEntity);
  Future<void> deleteNew(NewEntity newEntity);
}
