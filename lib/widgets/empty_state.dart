import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class EmptyState extends StatefulWidget {
  final IconData icon;
  final String title;
  final String message;
  // SVG removido por compatibilidade do ambiente

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    
  });

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width < 400 ? 24 : 40),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width < 400 ? 24 : 40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                    spreadRadius: -4,
                  ),
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.02),
                    blurRadius: 24,
                    offset: const Offset(0, 4),
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ilustração (SVG) ou ícone
                  _buildIllustration(context),

                  const SizedBox(height: 32),

                  // Título moderno
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.05),
                          AppTheme.secondaryColor.withOpacity(0.03),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimaryColor,
                        letterSpacing: -0.5,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Mensagem moderna
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.message,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondaryColor,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Elemento decorativo sutil
                  Container(
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.3),
                          AppTheme.secondaryColor.withOpacity(0.2),
                          AppTheme.primaryColor.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    final size = MediaQuery.of(context).size.width < 400 ? 140.0 : 180.0;
    // Fallback para ícone com container decorado
    return Container(
      width: MediaQuery.of(context).size.width < 400 ? 100 : 140,
      height: MediaQuery.of(context).size.width < 400 ? 100 : 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.2),
            AppTheme.secondaryColor.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          widget.icon,
          size: MediaQuery.of(context).size.width < 400 ? 50 : 72,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}
