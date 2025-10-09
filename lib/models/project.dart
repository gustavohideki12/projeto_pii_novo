
enum ProjectStatus {
  planning,
  inProgress,
  completed,
  paused,
  cancelled,
}

extension ProjectStatusExtension on ProjectStatus {
  String get displayName {
    switch (this) {
      case ProjectStatus.planning:
        return 'Planejamento';
      case ProjectStatus.inProgress:
        return 'Em Andamento';
      case ProjectStatus.completed:
        return 'Concluída';
      case ProjectStatus.paused:
        return 'Pausada';
      case ProjectStatus.cancelled:
        return 'Cancelada';
    }
  }

  String get key {
    switch (this) {
      case ProjectStatus.planning:
        return 'planning';
      case ProjectStatus.inProgress:
        return 'in_progress';
      case ProjectStatus.completed:
        return 'completed';
      case ProjectStatus.paused:
        return 'paused';
      case ProjectStatus.cancelled:
        return 'cancelled';
    }
  }
}

class Project {
  final String id;
  final String name;
  final String description;
  final String location;
  final DateTime startDate;
  final DateTime? endDate;
  final ProjectStatus status;
  final List<String> imagePaths;
  final DateTime createdAt;
  final DateTime updatedAt;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.imagePaths,
    required this.createdAt,
    required this.updatedAt,
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    ProjectStatus? status,
    List<String>? imagePaths,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      imagePaths: imagePaths ?? this.imagePaths,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status.key,
      'imagePaths': imagePaths,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      status: ProjectStatus.values.firstWhere(
        (e) => e.key == json['status'] as String,
        orElse: () => ProjectStatus.planning,
      ),
      imagePaths: List<String>.from(json['imagePaths'] as List<dynamic>? ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Project && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Project(id: $id, name: $name, status: ${status.displayName})';
  }
}
