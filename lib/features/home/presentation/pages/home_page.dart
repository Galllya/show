import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slow/features/home/presentation/bloc/bloc/home_bloc.dart';
import 'package:slow/features/home/presentation/pages/home_view.dart';
import 'package:slow/features/home/presentation/widgets/drawer_custom.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>.value(
      value: homeBloc,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Image(
            image: AssetImage(
              Images.logo,
            ),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
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
