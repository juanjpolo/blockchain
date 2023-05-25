import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import 'widgets/error.dart';
import 'widgets/loaded.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(
          exchangeRepository: context.read(), wsRepository: context.read())
        ..add(InitializeEvent()),
      child: Builder(
        builder: (context) {
          final HomeBloc bloc = context.watch();
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/sign-in'),
                    icon: const Icon(Icons.login)),
              ),
              body: bloc.state.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                failed: (failure) {
                  return HomeError(
                    failure: failure,
                  );
                },
                loaded: (cryptos, _) => HomeLoaded(cryptos: cryptos),
              ));
        },
      ),
    );
  }
}
/*
 final HomeBloc bloc = context.watch();
          return Scaffold(
              body: bloc.state.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                failed: (failure) {
                  return HomeError(
                    failure: failure,
                  );
                },
                loaded: (cryptos, _) => HomeLoaded(cryptos: cryptos),
              ));
*/