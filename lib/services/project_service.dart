import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project.dart';

class ProjectService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'projects';

  // Obter todos os projetos de um usuário
  static Future<List<Project>> getProjects(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        return Project.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Erro ao carregar projetos: $e');
      return [];
    }
  }

  // Stream de projetos em tempo real
  static Stream<List<Project>> getProjectsStream(String userId) {
    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final projects = snapshot.docs.map((doc) {
        return Project.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      
      // Ordenar localmente por updatedAt
      projects.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return projects;
    });
  }

  // Obter um projeto específico
  static Future<Project?> getProject(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(_collectionName)
          .doc(id)
          .get();

      if (doc.exists) {
        return Project.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar projeto: $e');
      return null;
    }
  }

  // Salvar projeto no Firestore
  static Future<bool> saveProject(Project project) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(project.id)
          .set(project.toFirestore());

      return true;
    } catch (e) {
      print('Erro ao salvar projeto: $e');
      return false;
    }
  }

  // Deletar projeto do Firestore
  static Future<bool> deleteProject(String id) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(id)
          .delete();

      return true;
    } catch (e) {
      print('Erro ao deletar projeto: $e');
      return false;
    }
  }

  // Gerar ID único para projeto
  static String generateProjectId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Criar novo projeto
  static Project createProject({
    required String userId,
    required String name,
    required String description,
    required String location,
    required DateTime startDate,
    ProjectStatus status = ProjectStatus.planning,
    List<String>? imageUrls,
  }) {
    final id = generateProjectId();
    final now = DateTime.now();

    return Project(
      id: id,
      userId: userId,
      name: name,
      description: description,
      location: location,
      startDate: startDate,
      status: status,
      imageUrls: imageUrls ?? [],
      createdAt: now,
      updatedAt: now,
    );
  }

  // Atualizar projeto existente
  static Future<bool> updateProject(Project project) async {
    try {
      final updatedProject = project.copyWith(updatedAt: DateTime.now());
      return await saveProject(updatedProject);
    } catch (e) {
      print('Erro ao atualizar projeto: $e');
      return false;
    }
  }

  // Buscar projetos por status
  static Future<List<Project>> getProjectsByStatus(String userId, ProjectStatus status) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: status.key)
          .get();

      return snapshot.docs.map((doc) {
        return Project.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Erro ao buscar projetos por status: $e');
      return [];
    }
  }

  // Contar projetos por status
  static Future<int> getProjectCountByStatus(String userId, ProjectStatus status) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: status.key)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Erro ao contar projetos por status: $e');
      return 0;
    }
  }
}
