import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/user/user.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/typedefs.dart';
import '../../../globals/blocs/sessions_bloc.dart';
import '../../../globals/blocs/sessions_event.dart';
import 'sign_in_events.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvents, SingInState> {
  SignInBloc(super.initialState,
      {required AuthRepository authRepository,
      required SessionBloc sessionBloc})
      : _authRepository = authRepository,
        _sessionBloc = sessionBloc {
    on<SignInEmailChangedEvent>(
        (event, emit) => emit(state.copyWith(email: event.email)));
    on<SignInPasswordChangedEvent>(
        (event, emit) => emit(state.copyWith(password: event.password)));
    on<SignInTermsChangedEvent>((event, emit) => null);
  }
  final AuthRepository _authRepository;
  final SessionBloc _sessionBloc;

  HttpFuture<User> signIn() async {
    add(SignInEvents.fetching(true));
    final result = await _authRepository.signIn(state.email, state.password);
    result.whenOrNull(
      right: (user) {
        _sessionBloc.add(SessionEvents.serUser(user));
      },
    );
    add(SignInEvents.fetching(false));

    return result;
  }
}
