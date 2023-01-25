import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_test/presentation/blocs/new_bloc.dart';
import 'package:m_test/presentation/widgets/loading.dart';
import 'package:m_test/presentation/widgets/new_card.dart';
import 'package:rxdart/rxdart.dart';

class TopNewsScreen extends StatefulWidget {
  const TopNewsScreen({super.key});

  @override
  State<TopNewsScreen> createState() => _TopNewsScreenState();
}

class _TopNewsScreenState extends State<TopNewsScreen> with TickerProviderStateMixin {
  final _topController = ScrollController();
  final _allController = ScrollController();
  late final TabController _tabController;
  final BehaviorSubject<String> _title = BehaviorSubject.seeded('Top news');

  void _listen() {
    _topController.addListener(() {
      if (_topController.position.atEdge) {
        if (_topController.position.pixels != 0) {
          context.read<NewBloc>().add(NewUpdatePageTopNewEvent());
        }
      }
    });

    _allController.addListener(() {
      if (_allController.position.atEdge) {
        if (_allController.position.pixels != 0) {
          context.read<NewBloc>().add(NewUpdatePageAllNewEvent());
        }
      }
    });

    _tabController.addListener(() {
      _title.value = _tabController.index == 0 ? 'Top news' : 'All news';
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    _listen();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: StreamBuilder<String>(
            stream: _title,
            builder: (context, snapshot) {
              return Text(_title.value);
            }
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(icon: Icon(Icons.view_list_outlined)),
              Tab(icon: Icon(Icons.view_list_rounded)),
            ],
          ),
        ),
        body: BlocBuilder<NewBloc, NewState>(
          builder: (context, state) {
            if (state is NewCompleteState) {
              final topLength = state.topNews.length;
              final allLength = state.allNews.length;
              return TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ListView.builder(
                    itemCount: topLength + (state.isTopLoading ? 1 : 0),
                    controller: _topController,
                    itemBuilder: (_, index) {
                      if (index == topLength) return const Loading();
                      return NewCard(newEntity: state.topNews[index]);
                    },
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      context.read<NewBloc>().add(NewRefreshEvent());
                    },
                    child: ListView.builder(
                      itemCount: allLength + (state.isAllLoading ? 1 : 0),
                      controller: _allController,
                      itemBuilder: (_, index) {
                        if (index == allLength) return const Loading();
                        return NewCard(newEntity: state.allNews[index]);
                      },
                    ),
                  ),
                ],
              );
            }
            return const Loading();
          },
        ),
      ),
    );
  }
}
