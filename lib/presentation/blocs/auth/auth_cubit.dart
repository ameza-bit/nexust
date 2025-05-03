import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexust/data/enums/auth_status.dart';
import 'package:nexust/domain/repositories/auth_repository.dart';
import 'package:nexust/domain/repositories/project_repository.dart';
import 'package:nexust/presentation/blocs/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final ProjectRepository _projectRepository;
  StreamSubscription<User?>? _authStateSubscription;

  AuthCubit(this._authRepository, this._projectRepository)
    : super(AuthState.initial()) {
    // Comprobar el estado de autenticación inicial
    _checkInitialAuthState();

    // Escuchar cambios en el estado de autenticación
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (user) {
        if (user != null) {
          emit(AuthState.authenticated(user));
        } else {
          emit(AuthState.unauthenticated());
        }
      },
      onError: (error) {
        emit(AuthState.error(error.toString()));
      },
    );
  }

  Future<void> _checkInitialAuthState() async {
    try {
      final user = _authRepository.currentUser;
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    emit(AuthState.loading());
    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
      // No es necesario emitir un nuevo estado aquí, ya que el listener lo hará
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Usuario no encontrado para ese correo electrónico.';
          break;
        case 'wrong-password':
          errorMessage = 'Contraseña incorrecta para ese usuario.';
          break;
        case 'invalid-email':
          errorMessage = 'El correo electrónico no es válido.';
          break;
        case 'user-disabled':
          errorMessage = 'Este usuario ha sido deshabilitado.';
          break;
        default:
          errorMessage = 'Error de inicio de sesión: ${e.message}';
      }
      emit(AuthState.error(errorMessage));
    } catch (e) {
      emit(AuthState.error('Error de inicio de sesión: $e'));
    }
  }

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    emit(AuthState.loading());
    try {
      // Crear usuario
      final userCredential = await _authRepository
          .createUserWithEmailAndPassword(email, password);

      // Crear proyecto personal para el usuario
      if (userCredential.user != null) {
        await _projectRepository.createPersonalProject(
          userCredential.user!.uid,
          userCredential.user!.email ?? 'Usuario',
        );
      }
      // No es necesario emitir un nuevo estado aquí, ya que el listener lo hará
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Ya existe una cuenta con este correo electrónico.';
          break;
        case 'invalid-email':
          errorMessage = 'El correo electrónico no es válido.';
          break;
        case 'weak-password':
          errorMessage = 'La contraseña es demasiado débil.';
          break;
        case 'operation-not-allowed':
          errorMessage =
              'El registro con correo y contraseña no está habilitado.';
          break;
        default:
          errorMessage = 'Error de registro: ${e.message}';
      }
      emit(AuthState.error(errorMessage));
    } catch (e) {
      emit(AuthState.error('Error de registro: $e'));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthState.loading());
    try {
      await _authRepository.signInWithGoogle();
      // No es necesario emitir un nuevo estado aquí, ya que el listener lo hará
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage =
              'Ya existe una cuenta con este correo electrónico pero con diferentes credenciales.';
          break;
        case 'invalid-credential':
          errorMessage = 'Las credenciales proporcionadas son inválidas.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'El inicio de sesión con Google no está habilitado.';
          break;
        case 'user-disabled':
          errorMessage = 'Este usuario ha sido deshabilitado.';
          break;
        case 'ERROR_ABORTED_BY_USER':
          errorMessage = 'Inicio de sesión cancelado por el usuario.';
          break;
        default:
          errorMessage = 'Error de inicio de sesión con Google: ${e.message}';
      }
      emit(AuthState.error(errorMessage));
    } catch (e) {
      emit(AuthState.error('Error de inicio de sesión con Google: $e'));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(AuthState.loading());
    try {
      await _authRepository.resetPassword(email);
      emit(
        state.copyWith(status: AuthStatus.unauthenticated, errorMessage: null),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'El correo electrónico no es válido.';
          break;
        case 'user-not-found':
          errorMessage = 'No se encontró usuario con ese correo electrónico.';
          break;
        default:
          errorMessage = 'Error al restablecer la contraseña: ${e.message}';
      }
      emit(AuthState.error(errorMessage));
    } catch (e) {
      emit(AuthState.error('Error al restablecer la contraseña: $e'));
    }
  }

  Future<void> signOut() async {
    emit(AuthState.loading());
    try {
      await _authRepository.signOut();
      // No es necesario emitir un nuevo estado aquí, ya que el listener lo hará
    } catch (e) {
      emit(AuthState.error('Error al cerrar sesión: $e'));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }

  Future<void> updateDisplayName(String displayName) async {
    emit(AuthState.loading());
    try {
      final user = _authRepository.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);

        // Firebase no actualiza inmediatamente la instancia de usuario actual después de
        // updateDisplayName, por lo que necesitamos recargar el usuario manualmente
        await user.reload();

        // Emitir el estado actualizado con el usuario actualizado
        emit(AuthState.authenticated(_authRepository.currentUser!));
      } else {
        emit(AuthState.error('No hay usuario autenticado'));
      }
    } catch (e) {
      emit(AuthState.error('Error al actualizar el nombre: $e'));
    }
  }

  Future<void> updateProfilePhoto(String photoUrl) async {
    emit(AuthState.loading());
    try {
      final user = _authRepository.currentUser;
      if (user != null) {
        await user.updatePhotoURL(photoUrl);

        // Firebase no actualiza inmediatamente la instancia de usuario actual después de
        // updatePhotoURL, por lo que necesitamos recargar el usuario manualmente
        await user.reload();

        // Emitir el estado actualizado con el usuario actualizado
        emit(AuthState.authenticated(_authRepository.currentUser!));
      } else {
        emit(AuthState.error('No hay usuario autenticado'));
      }
    } catch (e) {
      emit(AuthState.error('Error al actualizar la foto de perfil: $e'));
    }
  }

  Future<void> uploadProfileImage(Uint8List imageBytes) async {
    emit(AuthState.loading());
    try {
      final user = _authRepository.currentUser;
      if (user != null) {
        // Usar el repositorio para subir la imagen y obtener la URL
        final photoUrl = await _authRepository.uploadProfileImage(
          imageBytes,
          user.uid,
        );

        // Actualizar la URL de la foto en el perfil del usuario
        await updateProfilePhoto(photoUrl);
      } else {
        emit(AuthState.error('No hay usuario autenticado'));
      }
    } catch (e) {
      emit(AuthState.error('Error al subir la imagen: $e'));
    }
  }
}
