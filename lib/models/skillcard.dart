class SkillCard {
  final String id;
  final String name;
  final String? description;

  const SkillCard({
    required this.id,
    required this.name,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory SkillCard.fromMap(Map<String, dynamic> map) {
    return SkillCard(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  SkillCard copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return SkillCard(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}