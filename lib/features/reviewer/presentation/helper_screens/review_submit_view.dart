import 'package:flutter/material.dart';
import 'package:session.ai/features/reviewer/data/reviewer_api.dart';

class ReviewSubmitScreen extends StatefulWidget {
  final String sessionId;

  const ReviewSubmitScreen({super.key, required this.sessionId});

  @override
  State<ReviewSubmitScreen> createState() => _ReviewSubmitScreenState();
}

class _ReviewSubmitScreenState extends State<ReviewSubmitScreen> {
  final ReviewerApi _api = ReviewerApi();

  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  bool _loading = false;

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a rating")));
      return;
    }

    setState(() => _loading = true);

    try {
      await _api.submitReview(
        sessionId: widget.sessionId,
        score: _rating,
        comment: _commentController.text,
      );

      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review submitted successfully")),
      );
    } catch (e) {
      setState(() => _loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: $e")));
    }
  }

  Widget _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;

        return IconButton(
          iconSize: 36,
          icon: Icon(
            starIndex <= _rating ? Icons.star : Icons.star_border,
            color: Colors.orange,
          ),
          onPressed: () {
            setState(() {
              _rating = starIndex;
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Review")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Rate this session",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// ⭐ STAR RATING
            _buildStars(),

            const SizedBox(height: 30),

            /// COMMENT INPUT
            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Comment",
                border: OutlineInputBorder(),
                hintText: "Write your review...",
              ),
            ),

            const SizedBox(height: 30),

            /// SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submitReview,
                child:
                    _loading
                        ? const CircularProgressIndicator()
                        : const Text("Submit Review"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
