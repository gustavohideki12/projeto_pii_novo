import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../utils/app_constants.dart';

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
      final sizeInBytes = await image.length();
      return sizeInBytes <= AppConstants.maxImageSize;
    } catch (e) {
      print('Erro ao verificar tamanho da imagem: $e');
      return false;
    }
  }

  static bool isImageFormatSupported(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return AppConstants.supportedImageFormats.contains(extension);
  }

  static String getFileNameFromPath(String path) {
    return path.split(Platform.pathSeparator).last;
  }

  static Future<String> saveImageToAppDirectory(File image, String projectId) async {
    try {
      // Para esta implementação inicial, retornamos apenas o caminho original
      // Em uma implementação mais avançada, poderíamos salvar em um diretório específico do app
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
