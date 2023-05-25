import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'app/data/repositories_impl/auth_repository_impl.dart';
import 'app/data/repositories_impl/exchange_repository_impl.dart';
import 'app/data/repositories_impl/ws_repository_impl.dart';
import 'app/data/services/remote/exchage_api.dart';
import 'app/domain/repositories/auth_repository.dart';
import 'app/domain/repositories/exchange_repository.dart';
import 'app/domain/repositories/ws_repository.dart';
import 'app/my_app.dart';
import 'app/presentation/globals/blocs/sessions_bloc.dart';
import 'app/presentation/globals/blocs/sessions_state.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ExchangeRepository>(
          create: (context) => ExchangeRepositoryImpl(ExchangeAPI(Client())),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(),
        ),
        Provider<WsRepository>(
          create: (context) => WsRepositoryImpl((ids) =>
              WebSocketChannel.connect(Uri.parse(
                  'wss://ws.coincap.io/prices?assets=${ids.join(',')}'))),
        ),
      ],
      child: BlocProvider(
        create: (context) => SessionBloc(SessionState(), authRepository: AuthRepository()),
        child:const MyApp(),
      ),
    ),
  );
}
