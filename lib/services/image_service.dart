import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/app_constants.dart';
import 'firebase_storage_service.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Erro ao selecionar imagem da galeria: $e');
      throw Exception(AppConstants.imageSelectionFailed);
    }
  }

  static Future<File?> takePhotoWithCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Erro ao tirar foto: $e');
      throw Exception(AppConstants.cameraError);
    }
  }

  static Future<bool> isImageSizeValid(File image) async {
    try {
      if (kIsWeb) {
        // No web, assumir que a imagem é válida
        return true;
      }
      final sizeInBytes = await image.length();
      return sizeInBytes <= AppConstants.maxImageSize;
    } catch (e) {
      print('Erro ao verificar tamanho da imagem: $e');
      return true; // Assumir válida em caso de erro
    }
  }

  static bool isImageFormatSupported(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return AppConstants.supportedImageFormats.contains(extension);
  }

  static String getFileNameFromPath(String path) {
    if (kIsWeb) {
      // No web, usar '/' como separador
      return path.split('/').last;
    }
    return path.split(Platform.pathSeparator).last;
  }

  // Upload de imagem para Firebase Storage
  static Future<String> uploadImageToFirebase({
    required File image,
    required String userId,
    required String projectId,
  }) async {
    try {
      // Validar tipo de arquivo
      if (!FirebaseStorageService.isValidImageType(image.path)) {
        throw Exception('Tipo de arquivo não suportado');
      }

      // Validar tamanho do arquivo
      final fileSize = await image.length();
      if (!FirebaseStorageService.isValidImageSize(fileSize)) {
        throw Exception('Arquivo muito grande. Máximo: 10MB');
      }

      // Upload para Firebase Storage
      final downloadUrl = await FirebaseStorageService.uploadImage(
        imageFile: image,
        userId: userId,
        projectId: projectId,
      );

      return downloadUrl;
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
      throw Exception('Erro ao fazer upload da imagem: $e');
    }
  }

  // Upload de múltiplas imagens para Firebase Storage
  static Future<List<String>> uploadMultipleImagesToFirebase({
    required List<File> images,
    required String userId,
    required String projectId,
  }) async {
    try {
      final List<String> downloadUrls = [];

      for (final image in images) {
        // Validar cada imagem
        if (!FirebaseStorageService.isValidImageType(image.path)) {
          print('Pulando imagem com tipo não suportado: ${image.path}');
          continue;
        }

        final fileSize = await image.length();
        if (!FirebaseStorageService.isValidImageSize(fileSize)) {
          print('Pulando imagem muito grande: ${image.path}');
          continue;
        }

        final downloadUrl = await FirebaseStorageService.uploadImage(
          imageFile: image,
          userId: userId,
          projectId: projectId,
        );
        downloadUrls.add(downloadUrl);
      }

      return downloadUrls;
    } catch (e) {
      print('Erro ao fazer upload de múltiplas imagens: $e');
      throw Exception('Erro ao fazer upload de múltiplas imagens: $e');
    }
  }

  // Método legado para compatibilidade (retorna path local)
  static Future<String> saveImageToAppDirectory(File image, String projectId) async {
    try {
      // Para compatibilidade com código existente, retornamos o path local
      // Em produção, use uploadImageToFirebase
      return image.path;
    } catch (e) {
      print('Erro ao salvar imagem: $e');
      throw Exception('Erro ao salvar imagem');
    }
  }

  static Future<List<String>> pickMultipleImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      final List<String> imagePaths = [];
      for (var file in pickedFiles) {
        final imageFile = File(file.path);
        if (await isImageSizeValid(imageFile) && isImageFormatSupported(file.name)) {
          imagePaths.add(file.path);
        }
      }

      return imagePaths;
    } catch (e) {
      print('Erro ao selecionar múltiplas imagens: $e');
      throw Exception(AppConstants.imageSelectionFailed);
    }
  }
}
