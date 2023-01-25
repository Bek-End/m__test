import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m_test/domain/entities/new_entity.dart';

class DetailNewScreen extends StatelessWidget {
  final NewEntity newEntity;
  const DetailNewScreen({
    required this.newEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String formatter(DateTime dateTime) {
      return DateFormat('dd MMMM yyyy hh:mm').format(dateTime);
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                newEntity.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              newEntity.description,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            if (newEntity.urlToImage != null)
              Image.network(newEntity.urlToImage!),
            Text('Author: ${newEntity.author ?? 'Anonimous'}'),
            Text('Published at: ${formatter(newEntity.publishedAt.toLocal())}'),
          ],
        ),
      ),
    );
  }
}
