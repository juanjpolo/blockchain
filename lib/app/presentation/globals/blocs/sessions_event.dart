import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/user/user.dart';

part 'sessions_event.freezed.dart';

@freezed
class SessionEvents with _$SessionEvents {
  factory SessionEvents.serUser(User user) = SessionSetUserEvent;
  factory SessionEvents.signOut() = SessionSignOutEvent;
}
