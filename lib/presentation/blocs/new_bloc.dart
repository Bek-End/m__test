import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:m_test/data/dto/new_parameters.dart';
import 'package:m_test/domain/entities/new_entity.dart';
import 'package:m_test/domain/repositories/local_repository.dart';
import 'package:m_test/domain/usecases/new.usecase.dart';

class NewBloc extends Bloc<NewEvent, NewState> {
  NewBloc() : super(NewLoadingState()) {
    final NewUseCase newUseCase = GetIt.I.get();
    final LocalRepository localRepository = GetIt.I.get();
    int topTotal = 0;
    int topPage = 1;
    int topPageSize = 0;
    int allPage = 1;
    int allPageSize = 0;
    Timer? timer;

    Future<void> listen() async {
      final top = await newUseCase.getTopNews(
        param: NewParameters(page: 1, pageSize: 15),
      );
      if (top.totalResults != topTotal) {
        topTotal = top.totalResults;
        topPage = 1;
        topPageSize = (topTotal ~/ 15);
        add(_NewRefreshEvent(top.newEntity));
      }
    }

    timer = Timer.periodic(
      const Duration(seconds: 5),
      (Timer t) async => await listen(),
    );

    on<NewInitEvent>((event, emit) async {
      final all = await newUseCase.getAllNews(
        param: NewParameters(page: 1, pageSize: 15),
      );
      final top = await newUseCase.getTopNews(
        param: NewParameters(page: 1, pageSize: 15),
      );
      final localNews = await localRepository.readNews();

      topTotal = top.totalResults;
      topPageSize = (topTotal / 15).ceil();
      allPageSize = (all.totalResults / 15).ceil();
      emit(NewCompleteState(
        topNews: top.newEntity,
        allNews: all.newEntity,
        localNews: localNews,
        isTopLoading: topPageSize > topPage,
        isAllLoading: allPageSize > allPage,
      ));
    });

    on<_NewRefreshEvent>((event, emit) async {
      final currState = state as NewCompleteState;
      emit(currState.copyWith(
        allNews: event.list,
        isTopLoading: topPageSize > topPage,
        isAllLoading: allPageSize > allPage,
      ));
    });

    on<NewRefreshEvent>((event, emit) async {
      final all = await newUseCase.getAllNews(
        param: NewParameters(page: 1, pageSize: 15),
      );
      allPage = 1;
      allPageSize = (all.totalResults ~/ 15);
      final currState = state as NewCompleteState;
      emit(currState.copyWith(
        allNews: all.newEntity,
        isTopLoading: topPageSize > topPage,
        isAllLoading: allPageSize > allPage,
      ));
    });

    on<NewUpdatePageTopNewEvent>((event, emit) async {
      if (topPage >= topPageSize) return;

      topPage++;
      final top = await newUseCase.getTopNews(
        param: NewParameters(page: topPage, pageSize: 15),
      );
      final currState = state as NewCompleteState;
      emit(currState.copyWith(
        topNews: [...currState.topNews, ...top.newEntity],
        isTopLoading: topPageSize > topPage,
        isAllLoading: allPageSize > allPage,
      ));
    });

    on<NewUpdatePageAllNewEvent>((event, emit) async {
      if (allPage >= allPageSize) return;

      final all = await newUseCase.getAllNews(
        param: NewParameters(page: ++allPage, pageSize: 15),
      );
      final currState = state as NewCompleteState;
      emit(currState.copyWith(
        allNews: [...currState.allNews, ...all.newEntity],
        isTopLoading: topPageSize > topPage,
        isAllLoading: allPageSize > allPage,
      ));
    });

    on<NewAddToLocalEvent>((event, emit) async {
      event.newEntity.isFavorite = true;
      await localRepository.writeNew(event.newEntity);
      final currState = state as NewCompleteState;
      emit(currState.copyWith(
        localNews: [event.newEntity, ...currState.localNews],
      ));
    });

    on<NewDeleteToLocalEvent>((event, emit) async {
      await localRepository.deleteNew(event.newEntity);
      final currState = state as NewCompleteState;
      event.newEntity.isFavorite = false;
      final localNews = await localRepository.readNews();
      emit(currState.copyWith(localNews: localNews));
    });
  }
}

abstract class NewEvent {}

class NewInitEvent extends NewEvent {}

class NewRefreshEvent extends NewEvent {}

class _NewRefreshEvent extends NewEvent {
  final List<NewEntity> list;
  _NewRefreshEvent(this.list);
}

class NewAddToLocalEvent extends NewEvent {
  final NewEntity newEntity;
  NewAddToLocalEvent(this.newEntity);
}

class NewDeleteToLocalEvent extends NewEvent {
  final NewEntity newEntity;
  NewDeleteToLocalEvent(this.newEntity);
}

class NewUpdatePageAllNewEvent extends NewEvent {}

class NewUpdatePageTopNewEvent extends NewEvent {}

abstract class NewState {}

class NewLoadingState extends NewState {}

class NewCompleteState extends NewState {
  final List<NewEntity> topNews;
  final List<NewEntity> allNews;
  final List<NewEntity> localNews;
  final bool isTopLoading;
  final bool isAllLoading;
  NewCompleteState({
    required this.topNews,
    required this.allNews,
    required this.localNews,
    required this.isTopLoading,
    required this.isAllLoading,
  });

  NewCompleteState copyWith({
    final List<NewEntity>? topNews,
    final List<NewEntity>? allNews,
    final List<NewEntity>? localNews,
    final bool? isTopLoading,
    final bool? isAllLoading,
  }) =>
      NewCompleteState(
        topNews: topNews ?? this.topNews,
        allNews: allNews ?? this.allNews,
        localNews: localNews ?? this.localNews,
        isTopLoading: isTopLoading ?? this.isTopLoading,
        isAllLoading: isAllLoading ?? this.isAllLoading,
      );
}
