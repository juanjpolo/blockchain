import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_events.freezed.dart';

@freezed
class SignInEvents with _$SignInEvents {
  factory SignInEvents.emailChanged(String email) = SignInEmailChangedEvent;
  factory SignInEvents.passwordChanged(String password) =
      SignInPasswordChangedEvent;
  factory SignInEvents.termsChanged(bool termsAccepted) =
      SignInTermsChangedEvent;
  factory SignInEvents.fetching(bool value) = SignInFetchingEvent;
}
