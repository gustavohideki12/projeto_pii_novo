import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import 'dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoginMode = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width < 400 ? 16 : 24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildAuthCard(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width < 400 ? 20 : 32,
          vertical: MediaQuery.of(context).size.height < 800 ? 24 : 32,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildForm(),
              const SizedBox(height: 24),
              _buildActionButtons(),
              const SizedBox(height: 16),
              _buildModeToggle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: AppTheme.floatingShadow,
          ),
          child: const Icon(
            Icons.construction,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppConstants.appName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isLoginMode ? 'Entre na sua conta' : 'Crie sua conta',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _buildEmailField(),
        const SizedBox(height: 16),
        _buildPasswordField(),
        if (!_isLoginMode) ...[
          const SizedBox(height: 16),
          _buildConfirmPasswordField(),
        ],
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email é obrigatório';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Email inválido';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Senha',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Senha é obrigatória';
        }
        if (value.length < 6) {
          return 'Senha deve ter pelo menos 6 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: 'Confirmar Senha',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Confirmação de senha é obrigatória';
        }
        if (value != _passwordController.text) {
          return 'Senhas não coincidem';
        }
        return null;
      },
    );
  }

  Widget _buildActionButtons() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: authProvider.isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: authProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        _isLoginMode ? 'Entrar' : 'Criar Conta',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: authProvider.isLoading ? null : _handleAnonymousLogin,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Continuar Anonimamente',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
            if (_isLoginMode) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : () async {
                          if (_emailController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Informe seu email para resetar a senha.')),
                            );
                            return;
                          }
                          final ok = await authProvider.resetPassword(_emailController.text.trim());
                          if (ok && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Email de redefinição enviado.')),
                            );
                          }
                        },
                  child: const Text('Esqueci minha senha'),
                ),
              ),
            ],
            if (authProvider.errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.errorColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppTheme.errorColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        authProvider.errorMessage!,
                        style: TextStyle(
                          color: AppTheme.errorColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildModeToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLoginMode ? 'Não tem uma conta? ' : 'Já tem uma conta? ',
          style: TextStyle(
            color: AppTheme.textSecondaryColor,
          ),
        ),
        GestureDetector(
          onTap: _toggleMode,
          child: Text(
            _isLoginMode ? 'Cadastre-se' : 'Entre aqui',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _confirmPasswordController.clear();
      context.read<AuthProvider>().clearError();
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    bool success = false;

    if (_isLoginMode) {
      success = await authProvider.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } else {
      success = await authProvider.signUpWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  Future<void> _handleAnonymousLogin() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signInAnonymously();

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }
}
