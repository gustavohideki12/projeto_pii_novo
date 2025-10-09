import 'package:flutter/foundation.dart';
import '../models/project.dart';
import '../services/project_service.dart';

class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];
  bool _isLoading = false;

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;

  Future<void> loadProjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      _projects = await ProjectService.getProjects();
      _projects.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      print('Erro ao carregar projetos: $e');
      _projects = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProject(Project project) async {
    try {
      final success = await ProjectService.saveProject(project);
      if (success) {
        await loadProjects(); // Recarrega a lista
        return true;
      }
      return false;
    } catch (e) {
      print('Erro ao adicionar projeto: $e');
      return false;
    }
  }

  Future<bool> updateProject(Project project) async {
    try {
      final updatedProject = project.copyWith(
        updatedAt: DateTime.now(),
      );
      final success = await ProjectService.saveProject(updatedProject);
      if (success) {
        await loadProjects(); // Recarrega a lista
        return true;
      }
      return false;
    } catch (e) {
      print('Erro ao atualizar projeto: $e');
      return false;
    }
  }

  Future<bool> deleteProject(String id) async {
    try {
      final success = await ProjectService.deleteProject(id);
      if (success) {
        await loadProjects(); // Recarrega a lista
        return true;
      }
      return false;
    } catch (e) {
      print('Erro ao deletar projeto: $e');
      return false;
    }
  }

  Project? getProjectById(String id) {
    return _projects.where((project) => project.id == id).firstOrNull;
  }

  List<Project> getProjectsByStatus(ProjectStatus status) {
    return _projects.where((project) => project.status == status).toList();
  }

  int getProjectCountByStatus(ProjectStatus status) {
    return _projects.where((project) => project.status == status).length;
  }

  int get totalProjects => _projects.length;
  int get activeProjects => getProjectCountByStatus(ProjectStatus.inProgress);
  int get completedProjects => getProjectCountByStatus(ProjectStatus.completed);
  int get planningProjects => getProjectCountByStatus(ProjectStatus.planning);
}
