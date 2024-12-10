import 'package:repo_ms/models/repository_model.dart' show Repository;
import 'package:supabase_flutter/supabase_flutter.dart';

class RepositoryController {
  final SupabaseClient supabase = Supabase.instance.client;
  Future<void> createRepository(Repository repository) async {
    await supabase.from('repositories').insert(repository.toMap());
  }

  Future<void> deleteRepository(int id) async {
    await supabase.from('repositories').delete().eq('id', id);
  }

  Future<List<Repository>> fetchRepositories() async {
    final response = await supabase.from('repositories').select();
    return (response as List).map((repo) => Repository.fromMap(repo)).toList();
  }

  // Fetch repositories matching the search query
  Future<List<Repository>> searchRepositories(String query) async {
    final response =
        await supabase.from('repositories').select().ilike('name', '%$query%');

    return (response as List).map((item) => Repository.fromMap(item)).toList();
  }

  Stream<List<Repository>> subscribeToRepositories() {
    // Listen to all changes in the 'repositories' table
    return supabase.from('repositories').stream(primaryKey: ['id']).map(
        (data) => data.map((item) => Repository.fromMap(item)).toList());
  }

  Future<void> updateRepository(Repository repository) async {
    await supabase
        .from('repositories')
        .update(repository.toMap())
        .eq('id', repository.id.toString());
  }
}
