import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream para monitorar mudanças de autenticação
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuário atual
  static User? get currentUser => _auth.currentUser;

  // Verificar se está logado
  static bool get isLoggedIn => currentUser != null;

  // Login anônimo
  static Future<UserCredential?> signInAnonymously() async {
    try {
      final UserCredential result = await _auth.signInAnonymously();
      return result;
    } on FirebaseAuthException catch (e) {
      print('Erro no login anônimo: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('Erro inesperado no login anônimo: $e');
      throw Exception('Erro inesperado durante o login');
    }
  }

  // Login com email e senha
  static Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      print('Erro no login com email: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('Erro inesperado no login: $e');
      throw Exception('Erro inesperado durante o login');
    }
  }

  // Cadastro com email e senha
  static Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      print('Erro no cadastro: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('Erro inesperado no cadastro: $e');
      throw Exception('Erro inesperado durante o cadastro');
    }
  }

  // Logout
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Erro ao fazer logout: $e');
      throw Exception('Erro ao fazer logout');
    }
  }

  // Reset de senha
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Erro ao enviar email de reset: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('Erro inesperado no reset de senha: $e');
      throw Exception('Erro inesperado ao resetar senha');
    }
  }

  // Atualizar perfil do usuário
  static Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
        }
        await user.reload();
      }
    } catch (e) {
      print('Erro ao atualizar perfil: $e');
      throw Exception('Erro ao atualizar perfil');
    }
  }

  // Deletar conta
  static Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user != null) {
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      print('Erro ao deletar conta: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('Erro inesperado ao deletar conta: $e');
      throw Exception('Erro inesperado ao deletar conta');
    }
  }

  // Tratamento de exceções do Firebase Auth
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Este email já está sendo usado.';
      case 'weak-password':
        return 'A senha é muito fraca.';
      case 'invalid-email':
        return 'Email inválido.';
      case 'user-disabled':
        return 'Esta conta foi desabilitada.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'operation-not-allowed':
        return 'Operação não permitida.';
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet.';
      default:
        return 'Erro de autenticação: ${e.message}';
    }
  }

  // Verificar se o email está verificado
  static bool get isEmailVerified => currentUser?.emailVerified ?? false;

  // Enviar email de verificação
  static Future<void> sendEmailVerification() async {
    try {
      final user = currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      print('Erro ao enviar email de verificação: $e');
      throw Exception('Erro ao enviar email de verificação');
    }
  }
}
