import 'package:hive_flutter/hive_flutter.dart';
import 'package:m_test/domain/entities/new_entity.dart';
import 'package:m_test/domain/repositories/local_repository.dart';

class LocalRepoImpl implements LocalRepository {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(NewEntityAdapter());
    Hive.registerAdapter(SourceEntityAdapter());
  }

  @override
  Future<void> deleteNew(NewEntity newEntity) async {
    final box = await Hive.openBox<NewEntity>('NewEntity');
    for (NewEntity element in box.values) {
      if (element.url == newEntity.url) {
        await element.delete();
        break;
      }
    }
  }

  @override
  Future<List<NewEntity>> readNews() async {
    final box = await Hive.openBox<NewEntity>('NewEntity');
    return box.values.toList();
  }

  @override
  Future<void> writeNew(NewEntity newEntity) async {
    final box = await Hive.openBox<NewEntity>('NewEntity');
    await box.put(newEntity.url, newEntity);
  }
}
