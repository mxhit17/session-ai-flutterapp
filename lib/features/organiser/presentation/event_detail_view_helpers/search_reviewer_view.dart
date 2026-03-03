import 'dart:async';
import 'package:flutter/material.dart';
import 'package:session.ai/features/organiser/data/organiser_repository.dart';
import 'package:session.ai/features/organiser/models/get_user_response.dart';

class SearchReviewersScreen extends StatefulWidget {
  final String eventId;

  const SearchReviewersScreen({super.key, required this.eventId});

  @override
  State<SearchReviewersScreen> createState() => _SearchReviewersScreenState();
}

class _SearchReviewersScreenState extends State<SearchReviewersScreen> {
  final OrganiserRepository _repository = OrganiserRepository();

  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;

  bool _isLoading = false;
  List<GetUsersModel> _users = [];

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.trim().isNotEmpty) {
        _searchUsers(value.trim());
      } else {
        setState(() => _users = []);
      }
    });
  }

  Future<void> _searchUsers(String query) async {
    setState(() => _isLoading = true);

    try {
      final results = await _repository.searchUsers(query);

      if (mounted) {
        setState(() {
          _users = results;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to search users")));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addReviewer(GetUsersModel user) async {
    try {
      await _repository.addReviewer(widget.eventId, user.id);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Reviewer added")));

      Navigator.pop(context, true); // refresh previous tab
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add reviewer")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Reviewers")),
      body: Column(
        children: [
          /// 🔍 SEARCH FIELD
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search by name or email",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          /// RESULTS
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _users.isEmpty
                    ? const Center(
                      child: Text(
                        "Start typing to search users",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];

                        return ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(user.fullName),
                          subtitle: Text(user.email),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.green,
                            ),
                            onPressed: () => _addReviewer(user),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
