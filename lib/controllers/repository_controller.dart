import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/repository_model.dart';

class RepositoryController {
  final SupabaseClient supabase = Supabase.instance.client;

  Stream<List<Repository>> subscribeToRepositories() {
    // Listen to all changes in the 'repositories' table
    return supabase.from('repositories').stream(primaryKey: ['id']).map(
        (data) => data.map((item) => Repository.fromMap(item)).toList());
  }

  Future<List<Repository>> fetchRepositories() async {
    final response = await supabase.from('repositories').select();
    return (response as List).map((repo) => Repository.fromMap(repo)).toList();
  }

  Future<void> createRepository(Repository repository) async {
    await supabase.from('repositories').insert(repository.toMap());
  }

  Future<void> updateRepository(Repository repository) async {
    await supabase
        .from('repositories')
        .update(repository.toMap())
        .eq('id', repository.id.toString());
  }

  Future<void> deleteRepository(int id) async {
    await supabase.from('repositories').delete().eq('id', id);
  }
}