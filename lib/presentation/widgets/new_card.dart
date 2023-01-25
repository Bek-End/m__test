import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_test/domain/entities/new_entity.dart';
import 'package:m_test/presentation/blocs/new_bloc.dart';
import 'package:m_test/presentation/screens/detail_new_screen.dart';

class NewCard extends StatelessWidget {
  final NewEntity newEntity;
  const NewCard({
    required this.newEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite = newEntity.isFavorite;
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(newEntity.title),
        subtitle: Text(newEntity.description),
        trailing: BlocBuilder<NewBloc, NewState>(
          builder: (context, state) {
            if (state is NewCompleteState) {
              return InkWell(
                onTap: () {
                  newEntity.isFavorite
                  ? context.read<NewBloc>().add(NewDeleteToLocalEvent(newEntity))
                  : context.read<NewBloc>().add(NewAddToLocalEvent(newEntity));
                },
                child: Icon(
                  isFavorite ? Icons.bookmark : Icons.bookmark_border,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => DetailNewScreen(newEntity: newEntity),
          ));
        },
      ),
    );
  }
}
