import 'package:flutter/material.dart';
import '../controllers/repository_controller.dart';
import '../models/repository_model.dart';

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
          await _controller.createRepository(repository);
        } else {
          await _controller.updateRepository(repository);
        }
        widget.refresh();
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

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
}