import 'package:dine_ease/models/rating_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';

class RatingView extends StatefulWidget {
  final Rating rating;
  final VoidCallback onDelete;

  const RatingView({super.key, required this.rating, required this.onDelete});

  @override
  _RatingViewState createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  late int _currentRating;
  late int _originalRating;
  bool _isEditing = false;
  final RequestUtil requestUtil = RequestUtil();

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating.ratingNumber;
    _originalRating = widget.rating.ratingNumber;
  }

  void _updateRating(int newRating) {
    setState(() {
      _currentRating = newRating;
      _isEditing = true;
    });
  }

  Future<void> _sendRating() async {
    try {
      widget.rating.ratingNumber = _currentRating;
      await requestUtil.updateRating(widget.rating.id!, widget.rating);
      setState(() {
        _isEditing = false;
        _originalRating = _currentRating;
      });
    } catch (e) {
      print('Error updating rating: $e');
    }
  }

  void _cancelRating() {
    setState(() {
      _currentRating = _originalRating;
      _isEditing = false;
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Rating"),
          content: Text("Are you sure you want to delete your rating?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await requestUtil.deleteRemoveRating(widget.rating.id!);
                  Navigator.pop(context); // Close the dialog
                  widget.onDelete(); // Call the onDelete callback
                } catch (e) {
                  print('Error deleting rating: $e');
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.rating.restaurantName!,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmationDialog(context),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => _updateRating(index + 1),
                  child: Icon(
                    Icons.star,
                    size: 20.0,
                    color: index < _currentRating ? Colors.orange : Colors.grey,
                  ),
                );
              }).map((widget) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: widget,
              )).toList(),
            ),
            if (_isEditing)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _cancelRating,
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: _sendRating,
                    child: Text('Save'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
