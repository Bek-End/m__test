import 'package:m_test/data/dto/new_dto.dart';
import 'package:m_test/data/dto/new_parameters.dart';
import 'package:m_test/domain/entities/new_entity.dart';
import 'package:m_test/domain/repositories/new_repository.dart';

class NewUseCase {
  final NewRepository newRepository;
  const NewUseCase(this.newRepository);

  Future<ResultEntity> getAllNews({NewParameters? param}) async {
    final dto = await newRepository.getAllNews(param: param);
    return ResultEntity(
      totalResults: dto.totalResults,
      newEntity: _dtoToEntity(dto),
    );
  }

  Future<ResultEntity> getTopNews({NewParameters? param}) async {
    final dto = await newRepository.getTopNews(param: param);
    return ResultEntity(
      totalResults: dto.totalResults,
      newEntity: _dtoToEntity(dto),
    );
  }

  List<NewEntity> _dtoToEntity(ResultDto dto) {
    final news = <NewEntity>[];
    for (var i = 0; i < dto.articles.length; i++) {
      final item = dto.articles[i];
      news.add(NewEntity(
        source: SourceEntity(name: item.source.name, id: item.source.id),
        title: item.title,
        description: item.description,
        url: item.url,
        publishedAt: item.publishedAt,
        content: item.content,
        author: item.author,
        urlToImage: item.urlToImage,
      ));
    }
    return news;
  }
}
