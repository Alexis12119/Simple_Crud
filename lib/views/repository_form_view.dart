import 'package:flutter/material.dart';
import 'package:repo_ms/controllers/repository_controller.dart';
import 'package:repo_ms/models/repository_model.dart';

class RepositoryFormView extends StatefulWidget {
  final Repository? repository;
  final VoidCallback refresh;

  const RepositoryFormView({super.key, this.repository, required this.refresh});

  @override
  RepositoryFormViewState createState() => RepositoryFormViewState();
}

class RepositoryFormViewState extends State<RepositoryFormView> {
  final _formKey = GlobalKey<FormState>();
  final RepositoryController _controller = RepositoryController();

  late String _name;
  late String _description;
  late String _url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.repository == null ? 'Add Repository' : 'Edit Repository'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Name is required' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Description is required' : null,
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                initialValue: _url,
                decoration: const InputDecoration(labelText: 'Repository URL'),
                validator: (value) => value!.isEmpty ? 'URL is required' : null,
                onSaved: (value) => _url = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRepository,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _name = widget.repository?.name ?? '';
    _description = widget.repository?.description ?? '';
    _url = widget.repository?.url ?? '';
  }

  void _saveRepository() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final repository = Repository(
        id: widget.repository?.id, // Null for new entries
        name: _name,
        description: _description,
        url: _url,
      );

      try {
        if (widget.repository == null) {
          // Add new repository
          await _controller.createRepository(repository);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Repository added successfully!'),
                backgroundColor: Colors.green, // Green background for success
              ),
            );
          }
        } else {
          // Update existing repository
          await _controller.updateRepository(repository);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Repository updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
        widget.refresh();
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
