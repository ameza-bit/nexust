import 'package:nexust/domain/entities/user_entity.dart';
import 'package:nexust/domain/repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
    required String name,
  }) async {
    return await repository.registerWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
  }
}
