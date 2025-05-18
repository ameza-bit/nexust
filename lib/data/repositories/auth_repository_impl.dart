import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
        throw Exception('login.register.error.weak_password'.tr());
      } else if (e.code == 'email-already-in-use') {
        throw Exception('login.register.error.email_exists'.tr());
      } else {
        throw Exception(
          'login.register.error.generic'.tr(
            namedArgs: {'error': e.message ?? 'Error desconocido'},
          ),
        );
      }
    } catch (e) {
      throw Exception(
        'login.register.error.generic'.tr(namedArgs: {'error': e.toString()}),
      );
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
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        throw Exception('login.error.user_not_found'.tr());
      } else {
        throw Exception(
          'login.error.generic'.tr(
            namedArgs: {'error': e.message ?? 'Error desconocido'},
          ),
        );
      }
    } catch (e) {
      throw Exception(
        'login.error.generic'.tr(namedArgs: {'error': e.toString()}),
      );
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(
            scopes: ['https://www.googleapis.com/auth/userinfo.email'],
          ).signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      return UserEntity(
        uid: user!.uid,
        email: user.email,
        name: user.displayName,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        throw Exception('login.error.user_not_found'.tr());
      } else {
        throw Exception(
          'login.error.generic'.tr(
            namedArgs: {'error': e.message ?? 'Error desconocido'},
          ),
        );
      }
    } catch (e) {
      throw Exception(
        'login.error.generic'.tr(namedArgs: {'error': e.toString()}),
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('login.forgot_password.error.user_not_found'.tr());
      } else {
        throw Exception(
          'login.forgot_password.error.generic'.tr(
            namedArgs: {'error': e.message ?? 'Error desconocido'},
          ),
        );
      }
    } catch (e) {
      throw Exception(
        'login.forgot_password.error.generic'.tr(
          namedArgs: {'error': e.toString()},
        ),
      );
    }
  }

  @override
  void setLanguage(String languageCode) {
    _firebaseAuth.setLanguageCode(languageCode);
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
