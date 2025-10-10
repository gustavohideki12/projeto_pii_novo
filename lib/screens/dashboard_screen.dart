import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/image_service.dart';
import '../utils/app_constants.dart';
import '../utils/app_theme.dart';
import '../widgets/project_card.dart';
import '../widgets/empty_state.dart';
import '../providers/project_provider.dart';
import '../providers/auth_provider.dart';
import 'registro_obra_form_screen.dart';
import 'registros_timeline_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final projectProvider = context.read<ProjectProvider>();
      
      if (authProvider.isLoggedIn && authProvider.userId != null) {
        projectProvider.initialize(authProvider.userId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.dashboardTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RegistrosTimelineScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RegistrosTimelineScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.surfaceGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: Consumer<ProjectProvider>(
            builder: (context, projectProvider, child) {
              if (projectProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (projectProvider.projects.isEmpty) {
                return EmptyState(
                  icon: Icons.construction,
                  title: AppConstants.noProjectsMessage,
                  message: AppConstants.addProjectMessage,
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width < 400 ? 12 : 16,
                      MediaQuery.of(context).size.width < 400 ? 12 : 16,
                      MediaQuery.of(context).size.width < 400 ? 12 : 16,
                      0,
                    ),
                    child: _DashboardHeader(projectProvider: projectProvider),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width < 400 ? 12 : 16),
                      itemCount: projectProvider.projects.length,
                      itemBuilder: (context, index) {
                        final project = projectProvider.projects[index];
                        return ProjectCard(
                          project: project,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RegistrosTimelineScreen(
                                  projectId: project.id,
                                  projectName: project.name,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showImageSourceDialog(context);
        },
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Registrar Obra'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Capturar Imagem'),
          content: const Text('Escolha como capturar a imagem da obra'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _captureImage(context, ImageSource.camera);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.camera_alt, color: AppTheme.primaryColor),
                  const SizedBox(width: 8),
                  const Text('Câmera'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _captureImage(context, ImageSource.gallery);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_library, color: AppTheme.secondaryColor),
                  const SizedBox(width: 8),
                  const Text('Galeria'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: AppTheme.textSecondaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _captureImage(BuildContext context, ImageSource source) async {
    try {
      if (kIsWeb) {
        final picker = ImagePicker();
        final XFile? pickedFile = await picker.pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );

        if (pickedFile != null && mounted) {
          final authProvider = context.read<AuthProvider>();

          if (authProvider.userId == null) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Usuário não autenticado'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            }
            return;
          }

          final bytes = await pickedFile.readAsBytes();

          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RegistroObraFormScreen(
                  imageBytes: bytes,
                  imageFileName: pickedFile.name,
                  // sem obra específica ao partir do FAB do dashboard
                ),
              ),
            );
          }
        }
        return;
      }

      File? imageFile;
      if (source == ImageSource.camera) {
        imageFile = await ImageService.takePhotoWithCamera();
      } else {
        imageFile = await ImageService.pickImageFromGallery();
      }

      if (imageFile != null && mounted) {
        // Verificar se o usuário está autenticado
        final authProvider = context.read<AuthProvider>();
        
        if (authProvider.userId == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Usuário não autenticado'),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
          return;
        }

        // Navegar para o formulário de registro
        if (mounted) {
        Navigator.of(context).push(
            MaterialPageRoute(
            builder: (context) => RegistroObraFormScreen(
              imageFile: imageFile!,
              // sem obra específica ao partir do FAB do dashboard
            ),
            ),
          );
        }
      }
    } catch (e) {
      print('Erro ao capturar imagem: $e');
      // Não mostrar erro para o usuário, apenas log
    }
  }
}

class _DashboardHeader extends StatelessWidget {
  final ProjectProvider projectProvider;
  const _DashboardHeader({required this.projectProvider});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatInfo(
        label: 'Ativas',
        value: projectProvider.activeProjects.toString(),
        color: AppTheme.primaryColor,
        icon: Icons.work_outline,
      ),
      _StatInfo(
        label: 'Concluídas',
        value: projectProvider.completedProjects.toString(),
        color: AppTheme.successColor,
        icon: Icons.verified_outlined,
      ),
      _StatInfo(
        label: 'Total',
        value: projectProvider.totalProjects.toString(),
        color: AppTheme.secondaryColor,
        icon: Icons.all_inbox_outlined,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: stats
            .map((s) => Expanded(
                  child: _StatCard(info: s),
                ))
            .toList(),
      ),
    );
  }
}

class _StatInfo {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  _StatInfo({required this.label, required this.value, required this.color, required this.icon});
}

class _StatCard extends StatelessWidget {
  final _StatInfo info;
  const _StatCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: info.color.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: info.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(info.icon, color: info.color, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info.value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: info.color),
              ),
              const SizedBox(height: 2),
              Text(
                info.label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
