import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexust/domain/entities/user_entity.dart';
import 'package:nexust/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Actualizar el nombre del usuario
      await userCredential.user?.updateDisplayName(name);

      // Recargar el usuario para obtener los datos actualizados
      await userCredential.user?.reload();

      final user = _firebaseAuth.currentUser;

      return UserEntity(
        uid: user!.uid,
        email: user.email,
        name: user.displayName,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('La contraseña proporcionada es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Este correo ya está registrado con otra cuenta.');
      } else {
        throw Exception('Error al registrar: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error al registrar: $e');
    }
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      return UserEntity(
        uid: user!.uid,
        email: user.email,
        name: user.displayName,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw Exception(
          'Credenciales incorrectas. Verifica tu email y contraseña.',
        );
      } else {
        throw Exception('Error al iniciar sesión: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((User? user) {
      if (user == null) {
        return null;
      }

      return UserEntity(
        uid: user.uid,
        email: user.email,
        name: user.displayName,
        photoUrl: user.photoURL,
      );
    });
  }
}
