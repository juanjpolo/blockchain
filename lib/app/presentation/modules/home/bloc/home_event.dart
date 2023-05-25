import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/models/crypto/crypto.dart';
import 'home_state.dart';

part 'home_event.freezed.dart';

@freezed
class HomeEvent with _$HomeEvent {
  factory HomeEvent.initialize() = InitializeEvent;
  factory HomeEvent.delete(Crypto crypto) = DeleteEvent;
  factory HomeEvent.updateWsStatus(WsStatus status) = UpdateWsStatusEvent;
  factory HomeEvent.updateCryptoPrices(
    Map<String, double> prices,
  ) = UpdateCryptoPricesEvent;
}
