import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/auth_repository.dart';
import 'sessions_event.dart';
import 'sessions_state.dart';

class SessionBloc extends Bloc<SessionEvents, SessionState> {
  SessionBloc(super.initialState, {required AuthRepository authRepository})
 {
    on<SessionSetUserEvent>(
        (event, emit) => emit(state.copyWith(user: event.user)));
    on<SessionSignOutEvent>((event, emit) => emit(state.copyWith(user: null)));
  }

}
