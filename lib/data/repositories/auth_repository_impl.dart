import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexust/data/services/auth_service.dart';
import 'package:nexust/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  User? get currentUser => _authService.currentUser;

  @override
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  @override
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _authService.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _authService.createUserWithEmailAndPassword(email, password);
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }

  @override
  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email);
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }
}
