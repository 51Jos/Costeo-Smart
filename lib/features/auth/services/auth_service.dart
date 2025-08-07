import 'package:costeosmart/config/api_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Usuario actual
  final Rxn<User> firebaseUser = Rxn<User>();
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  
  // Estado de autenticación
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Escuchar cambios en el estado de autenticación
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }
  
  // Configurar pantalla inicial basada en el estado de autenticación
  void _setInitialScreen(User? user) async {
    if (user == null) {
      isAuthenticated.value = false;
      currentUser.value = null;
    } else {
      isAuthenticated.value = true;
      await _loadUserData(user.uid);
    }
  }
  
  // Cargar datos del usuario desde Firestore
  Future<void> _loadUserData(String userId) async {
    try {
      final doc = await _firestore
          .collection(Collections.users)
          .doc(userId)
          .get();
          
      if (doc.exists) {
        currentUser.value = UserModel.fromFirestore(doc);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error loading user data: $e');
    }
  }
  
  // Registro con email y contraseña
  Future<UserModel?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      isLoading.value = true;
      
      // Crear usuario en Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw Exception('Error al crear usuario');
      }
      
      // Enviar email de verificación
      await credential.user!.sendEmailVerification();
      
      // Crear modelo de usuario
      final userModel = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name,
        phone: phone,
        role: UserRole.user,
        isActive: true,
        isEmailVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        notificationSettings: NotificationSettings(),
      );
      
      // Guardar en Firestore
      await _firestore
          .collection(Collections.users)
          .doc(userModel.id)
          .set(userModel.toFirestore());
      
      currentUser.value = userModel;
      isAuthenticated.value = true;
      
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error durante el registro: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Login con email y contraseña
  Future<UserModel?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw Exception('Error al iniciar sesión');
      }
      
      await _loadUserData(credential.user!.uid);
      
      return currentUser.value;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error durante el login: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Login con Google
  Future<UserModel?> loginWithGoogle() async {
    try {
      isLoading.value = true;
      
      // Implementar Google Sign In
      // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // if (googleUser == null) return null;
      
      // final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );
      
      // final userCredential = await _auth.signInWithCredential(credential);
      
      // Temporalmente lanzar excepción
      throw UnimplementedError('Google Sign In no implementado aún');
    } catch (e) {
      throw Exception('Error con Google Sign In: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Recuperar contraseña
  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error al enviar email de recuperación: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Actualizar perfil de usuario
  Future<void> updateUserProfile({
    required String name,
    String? phone,
    String? photoUrl,
    Map<String, dynamic>? businessInfo,
  }) async {
    try {
      isLoading.value = true;
      
      if (currentUser.value == null) {
        throw Exception('Usuario no autenticado');
      }
      
      final updatedUser = currentUser.value!.copyWith(
        name: name,
        phone: phone,
        photoUrl: photoUrl,
        businessInfo: businessInfo,
        updatedAt: DateTime.now(),
      );
      
      await _firestore
          .collection(Collections.users)
          .doc(updatedUser.id)
          .update(updatedUser.toFirestore());
      
      currentUser.value = updatedUser;
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Actualizar configuración de notificaciones
  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    try {
      isLoading.value = true;
      
      if (currentUser.value == null) {
        throw Exception('Usuario no autenticado');
      }
      
      final updatedUser = currentUser.value!.copyWith(
        notificationSettings: settings,
        updatedAt: DateTime.now(),
      );
      
      await _firestore
          .collection(Collections.users)
          .doc(updatedUser.id)
          .update({
        'notificationSettings': settings.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      currentUser.value = updatedUser;
    } catch (e) {
      throw Exception('Error al actualizar configuración: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Verificar si el email está verificado
  Future<bool> checkEmailVerification() async {
    try {
      await _auth.currentUser?.reload();
      final isVerified = _auth.currentUser?.emailVerified ?? false;
      
      if (isVerified && currentUser.value != null && !currentUser.value!.isEmailVerified) {
        // Actualizar en Firestore
        await _firestore
            .collection(Collections.users)
            .doc(currentUser.value!.id)
            .update({'isEmailVerified': true});
        
        currentUser.value = currentUser.value!.copyWith(isEmailVerified: true);
      }
      
      return isVerified;
    } catch (e) {
      return false;
    }
  }
  
  // Reenviar email de verificación
  Future<void> resendVerificationEmail() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      throw Exception('Error al enviar email de verificación: $e');
    }
  }
  
  // Cambiar contraseña
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;
      
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw Exception('Usuario no autenticado');
      }
      
      // Re-autenticar antes de cambiar contraseña
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error al cambiar contraseña: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Cerrar sesión
  Future<void> logout() async {
    try {
      await _auth.signOut();
      currentUser.value = null;
      isAuthenticated.value = false;
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }
  
  // Eliminar cuenta
  Future<void> deleteAccount(String password) async {
    try {
      isLoading.value = true;
      
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw Exception('Usuario no autenticado');
      }
      
      // Re-autenticar antes de eliminar
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      
      await user.reauthenticateWithCredential(credential);
      
      // Eliminar datos de Firestore
      await _firestore
          .collection(Collections.users)
          .doc(user.uid)
          .delete();
      
      // Eliminar cuenta de Firebase Auth
      await user.delete();
      
      currentUser.value = null;
      isAuthenticated.value = false;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error al eliminar cuenta: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Manejar excepciones de Firebase Auth
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'La contraseña es muy débil';
      case 'email-already-in-use':
        return 'El email ya está registrado';
      case 'invalid-email':
        return 'Email inválido';
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'user-disabled':
        return 'Usuario deshabilitado';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'network-request-failed':
        return 'Error de conexión';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
}