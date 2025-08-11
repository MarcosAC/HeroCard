class Item {
  final String id;
  final String name;
  final String type;
  final String? description;

  const Item({
    required this.id,
    required this.name,
    required this.type,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      description: map['description'],
    );
  }

  Item copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }
}