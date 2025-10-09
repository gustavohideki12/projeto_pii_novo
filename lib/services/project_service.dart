import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';
import '../utils/app_constants.dart';

class ProjectService {
  static const String _projectsKey = AppConstants.projectsKey;

  static Future<List<Project>> getProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectsJson = prefs.getStringList(_projectsKey) ?? [];

      return projectsJson.map((json) {
        final projectMap = jsonDecode(json) as Map<String, dynamic>;
        return Project.fromJson(projectMap);
      }).toList();
    } catch (e) {
      print('Erro ao carregar projetos: $e');
      return [];
    }
  }

  static Future<Project?> getProject(String id) async {
    try {
      final projects = await getProjects();
      return projects.where((project) => project.id == id).firstOrNull;
    } catch (e) {
      print('Erro ao buscar projeto: $e');
      return null;
    }
  }

  static Future<bool> saveProject(Project project) async {
    try {
      final projects = await getProjects();
      final existingIndex = projects.indexWhere((p) => p.id == project.id);

      if (existingIndex >= 0) {
        projects[existingIndex] = project;
      } else {
        projects.add(project);
      }

      final projectsJson = projects.map((p) => jsonEncode(p.toJson())).toList();
      final prefs = await SharedPreferences.getInstance();

      return await prefs.setStringList(_projectsKey, projectsJson);
    } catch (e) {
      print('Erro ao salvar projeto: $e');
      return false;
    }
  }

  static Future<bool> deleteProject(String id) async {
    try {
      final projects = await getProjects();
      projects.removeWhere((project) => project.id == id);

      final projectsJson = projects.map((p) => jsonEncode(p.toJson())).toList();
      final prefs = await SharedPreferences.getInstance();

      return await prefs.setStringList(_projectsKey, projectsJson);
    } catch (e) {
      print('Erro ao deletar projeto: $e');
      return false;
    }
  }

  static Future<String> generateProjectId() async {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static Future<Project> createProject({
    required String name,
    required String description,
    required String location,
    required DateTime startDate,
    ProjectStatus status = ProjectStatus.planning,
    List<String>? imagePaths,
  }) async {
    final id = await generateProjectId();
    final now = DateTime.now();

    return Project(
      id: id,
      name: name,
      description: description,
      location: location,
      startDate: startDate,
      status: status,
      imagePaths: imagePaths ?? [],
      createdAt: now,
      updatedAt: now,
    );
  }
}
