import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_test/presentation/blocs/new_bloc.dart';
import 'package:m_test/presentation/widgets/loading.dart';
import 'package:m_test/presentation/widgets/new_card.dart';

class FavoriteNewsScreen extends StatelessWidget {
  const FavoriteNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite news'),
      ),
      body: BlocBuilder<NewBloc, NewState>(
        buildWhen: (prev, curr) {
          return prev is NewLoadingState && curr is NewCompleteState ||
              prev is NewCompleteState &&
                  curr is NewCompleteState &&
                  prev.localNews.length != curr.localNews.length;
        },
        builder: (context, state) {
          if (state is NewCompleteState) {
            return ListView.builder(
              itemCount: state.localNews.length,
              itemBuilder: (_, index) {
                return NewCard(newEntity: state.localNews[index]);
              },
            );
          }
          return const Loading();
        },
      ),
    );
  }
}
