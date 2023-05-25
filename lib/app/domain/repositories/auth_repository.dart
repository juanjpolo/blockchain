import '../either/either.dart';
import '../failures/http_request_failure.dart';
import '../models/user/user.dart';

abstract class AuthRepository {
  Future<Either<HttpRequestFailure, User>> signIn(
      String email, String password);
}
