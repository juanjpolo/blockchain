import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../domain/repositories/exchange_repository.dart';
import '../../../../domain/repositories/ws_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ExchangeRepository exchangeRepository;
  final WsRepository wsRepository;
  final ids = [
    'bitcoin',
    'dogecoin',
    'litecoin',
    'monero',
    'usd-coin',
    'tether',
    'ethereum',
    'binance-coin'
  ];
  StreamSubscription? _priceSubscription;

  HomeBloc({required this.exchangeRepository, required this.wsRepository})
      : super(HomeState.loading()) {
    on<InitializeEvent>((event, emit) => initializeMethod(event, emit));
    on<UpdateWsStatusEvent>(_onUpdateWsStatus);
    on<UpdateCryptoPricesEvent>(_onUpdateCryptoPrices);
    on<DeleteEvent>(_onDelete);
  }

  void _onUpdateCryptoPrices(
      UpdateCryptoPricesEvent event, Emitter<HomeState> emit) {
    state.mapOrNull(loaded: (state) {
      final keys = event.prices.keys;
      final cryptos = [
        ...state.cryptos.map((crypto) {
          if (keys.contains(crypto.id)) {
            return crypto.copyWith(price: event.prices[crypto.id]!);
          }
          return crypto;
        })
      ];
      emit(state.copyWith(cryptos: cryptos));
    });
  }

  Future<void> initializeMethod(event, emit) async {
    try {
      state.maybeWhen(
        loading: () {},
        orElse: () => emit(
          HomeState.loading(),
        ),
      );
      final result = await exchangeRepository.getPrices(ids);
      emit(result.when(left: (_) {
        return HomeState.failed(_);
      }, right: (cryptos) {
        startPriceListening();
        return HomeState.loaded(cryptos: cryptos);
      }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> startPriceListening() async {
    final connected = await wsRepository.connect(ids);
    add(UpdateWsStatusEvent(
        connected ? const WsStatus.connected() : const WsStatus.failed()));
    _priceSubscription?.cancel();

    _priceSubscription = wsRepository.onPriceChange.listen((changes) {
      add(UpdateCryptoPricesEvent(changes));
    });

    return connected;
  }

  void _onUpdateWsStatus(UpdateWsStatusEvent event, Emitter<HomeState> emit) {
    state.mapOrNull(loaded: (state) {
      emit(state.copyWith(wsStatus: event.status));
    });
  }

  void _onDelete(DeleteEvent event, Emitter<HomeState> emit) {
    state.mapOrNull(loaded: (state) {
      final cryptos = [...state.cryptos];
      cryptos.removeWhere((element) => element.id == event.crypto.id);
      emit(state.copyWith(cryptos: cryptos));
    });
  }

  @override
  Future<void> close() {
    _priceSubscription?.cancel();
    return super.close();
  }
}
