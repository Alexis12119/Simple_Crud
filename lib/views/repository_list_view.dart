import 'package:flutter/material.dart';
import 'package:repo_ms/controllers/repository_controller.dart';
import 'package:repo_ms/models/repository_model.dart';
import 'package:repo_ms/views/repository_form_view.dart';
import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl;

class RepositoryListView extends StatefulWidget {
  const RepositoryListView({super.key});

  @override
  RepositoryListViewState createState() => RepositoryListViewState();
}

class RepositoryListViewState extends State<RepositoryListView> {
  final RepositoryController _controller = RepositoryController();
  late Stream<List<Repository>> _repositoryStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Repositories')),
      body: StreamBuilder<List<Repository>>(
        stream: _repositoryStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final repositories = snapshot.data!;
            return ListView.builder(
              itemCount: repositories.length,
              itemBuilder: (context, index) {
                final repo = repositories[index];
                return ListTile(
                  title: Text(repo.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(repo.description),
                      GestureDetector(
                        onTap: () => _openUrl(repo.url),
                        child: Text(
                          repo.url,
                          style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RepositoryFormView(
                                repository: repo, refresh: () {}),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _controller.deleteRepository(repo.id!);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No repositories found.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RepositoryFormView(refresh: () {}),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _repositoryStream = _controller.subscribeToRepositories();
  }

  void _openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Could not open URL')));
      }
    }
  }
}
