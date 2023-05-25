import '../../domain/either/either.dart';
import '../../domain/failures/http_request_failure.dart';
import '../../domain/models/user/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<HttpRequestFailure, User>> signIn(
      String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@test.com' && password == 'test123') {
      return Either.right(User(id: 123, name: 'Juan', avatar: null));
    }

    return Either.left(HttpRequestFailure.unauthorized());
  }
}
