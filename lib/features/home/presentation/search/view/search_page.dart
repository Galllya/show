import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slow/common/widgets/app_bar_image.dart';
import 'package:slow/features/home/presentation/search/bloc/search_bloc.dart';
import 'package:slow/features/home/presentation/search/view/search_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late SearchBloc searchBloc;
  @override
  void initState() {
    searchBloc = SearchBloc()
      ..add(
        const SearchEvent.started(),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => searchBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const AppBarImage(),
        ),
        body: const SearchView(),
      ),
    );
  }
}
