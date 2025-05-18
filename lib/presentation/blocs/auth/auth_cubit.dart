import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/core/enums/language.dart';
import 'package:nexust/domain/entities/user_entity.dart';
import 'package:nexust/domain/repositories/auth_repository.dart';
import 'package:nexust/domain/usecases/register_user.dart';
import 'package:nexust/presentation/blocs/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final RegisterUser _registerUser;

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      _registerUser = RegisterUser(authRepository),
      super(AuthState.initial()) {
    // Escuchar cambios en el estado de autenticación
    _authRepository.authStateChanges.listen((UserEntity? user) {
      if (user != null) {
        emit(state.copyWith(status: AuthStatus.authenticated, user: user));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
      }
    });
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await _registerUser(
        email: email,
        password: password,
        name: name,
      );

      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await _authRepository.signInWithGoogle();

      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await _authRepository.sendPasswordResetEmail(email: email);
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  void reset() => emit(AuthState.initial());

  void setLanguage(Language language) {
    _authRepository.setLanguage(language.code);
  }
}
