import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/project_service.dart';
import '../services/image_service.dart';
import '../utils/app_constants.dart';
import '../utils/app_theme.dart';
import '../widgets/project_card.dart';
import '../widgets/empty_state.dart';
import '../providers/project_provider.dart';

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
      context.read<ProjectProvider>().loadProjects();
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
              // TODO: Implementar busca
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Busca será implementada em breve')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implementar filtros
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filtros serão implementados em breve')),
              );
            },
          ),
        ],
      ),
      body: Consumer<ProjectProvider>(
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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projectProvider.projects.length,
            itemBuilder: (context, index) {
              final project = projectProvider.projects[index];
              return ProjectCard(
                project: project,
                onTap: () {
                  // TODO: Navegar para detalhes do projeto
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Detalhes de ${project.name} serão implementados em breve')),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showImageSourceDialog(context);
        },
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Nova Obra'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppConstants.captureImageTitle),
          content: Text(AppConstants.chooseImageSource),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _captureImage(context, ImageSource.camera);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.camera_alt, color: AppTheme.primaryColor),
                  const SizedBox(width: 8),
                  Text(AppConstants.cameraButton),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _captureImage(context, ImageSource.gallery);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_library, color: AppTheme.secondaryColor),
                  const SizedBox(width: 8),
                  Text(AppConstants.galleryButton),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppConstants.cancelButton,
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
      File? imageFile;

      if (source == ImageSource.camera) {
        imageFile = await ImageService.takePhotoWithCamera();
      } else {
        imageFile = await ImageService.pickImageFromGallery();
      }

      if (imageFile != null) {
        // Validar tamanho da imagem
        if (!await ImageService.isImageSizeValid(imageFile)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Imagem muito grande. Tamanho máximo: ${AppConstants.maxImageSize ~/ (1024 * 1024)}MB'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
          return;
        }

        // Validar formato da imagem
        if (!ImageService.isImageFormatSupported(ImageService.getFileNameFromPath(imageFile.path))) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Formato de imagem não suportado. Use: ${AppConstants.supportedImageFormats.join(", ")}'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
          return;
        }

        // Criar novo projeto com a imagem
        final project = await ProjectService.createProject(
          name: 'Nova Obra ${DateTime.now().millisecondsSinceEpoch}',
          description: 'Obra criada automaticamente',
          location: 'Localização não definida',
          startDate: DateTime.now(),
          imagePaths: [await ImageService.saveImageToAppDirectory(imageFile, 'temp')],
        );

        // Salvar projeto
        final success = await context.read<ProjectProvider>().addProject(project);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(source == ImageSource.camera
                  ? AppConstants.imageCaptured
                  : AppConstants.imageSelected),
              backgroundColor: AppTheme.successColor,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar projeto'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
}
