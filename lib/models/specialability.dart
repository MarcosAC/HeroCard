class SpecialAbility {
  final String id;
  final String name;
  final String type;
  final String description;

  const SpecialAbility({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
    };
  }

  factory SpecialAbility.fromMap(Map<String, dynamic> map) {
    return SpecialAbility(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      description: map['description'],
    );
  }

  SpecialAbility copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
  }) {
    return SpecialAbility(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }
}