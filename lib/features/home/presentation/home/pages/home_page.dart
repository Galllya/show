import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slow/common/widgets/app_bar_image.dart';
import 'package:slow/features/home/presentation/home/bloc/home_bloc.dart';
import 'package:slow/features/home/presentation/home/pages/home_view.dart';
import 'package:slow/features/home/presentation/home/widgets/drawer_custom.dart';
import 'package:slow/features/home/presentation/search/view/search_page.dart';
import 'package:slow/resources/resources.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc homeBloc;

  @override
  void initState() {
    homeBloc = HomeBloc()
      ..add(
        const HomeEvent.started(),
      );

    super.initState();
  }

  void openSearchPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchPage(),
      ),
    );
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>.value(
      value: homeBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const AppBarImage(),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => openDrawer(context),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () => openSearchPage(context),
              icon: const Icon(
                Icons.search,
              ),
            ),
          ],
        ),
        drawer: const DrawerCustom(),
        body: HomeView(
          addMessageEvent: (message) {
            homeBloc.add(HomeEvent.addMessage(message));
          },
        ),
      ),
    );
  }
}
