class Repository {
  final int? id;
  final String name;
  final String description;
  final String url;

  Repository(
      {required this.id,
      required this.name,
      required this.description,
      required this.url});

  // Create a Repository object from a Supabase Map
  factory Repository.fromMap(Map<String, dynamic> map) {
    return Repository(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      url: map['url'] as String,
    );
  }

  // Convert a Repository object to a Map for Supabase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'url': url,
    };
  }
}
