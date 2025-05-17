import 'package:nexust/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({required String email});

  void setLanguage(String languageCode);

  Future<void> signOut();

  Stream<UserEntity?> get authStateChanges;
}
