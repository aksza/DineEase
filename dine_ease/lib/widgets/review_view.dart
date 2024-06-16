import 'package:dine_ease/models/review_models.dart';
import 'package:flutter/material.dart';

class ReviewView extends StatefulWidget {
  final Review review;
  final String email;
  final VoidCallback onDelete; // Callback függvény a törléshez
  final Function(String)? onUpdate; // Callback függvény a frissítéshez

  const ReviewView({super.key, 
    required this.review,
    required this.email,
    required this.onDelete,
    this.onUpdate,
  });

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  final TextEditingController _editingController = TextEditingController();
  String _editedContent = "";
  String _originalContent = ""; // Az eredeti tartalmat eltároló változó
  bool _isEditingEnabled = false;

  @override
  void initState() {
    super.initState();
    _editingController.text = widget.review.content;
    _editedContent = widget.review.content;
    _originalContent = widget.review.content; // Eredeti tartalom inicializálása
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
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
                Expanded(
                  child: Text(
                    '${widget.review.userName} to ${widget.review.restaurantName}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if(widget.onUpdate != null)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _enableEditing(true), // Szerkesztés engedélyezése
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _showDeleteConfirmationDialog(context), // Törlés esemény kezelése
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            if(widget.onUpdate != null)
            _isEditingEnabled
                ? TextField(
                    controller: _editingController,
                    onChanged: (value) {
                      setState(() {
                        _editedContent = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )
                : GestureDetector(
                    onTap: () => _enableEditing(true),
                    child: Text(
                      _editedContent,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
            if (_isEditingEnabled)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _saveChanges, // Módosítások mentése
                    child: const Text('Save'),
                  ),
                  const SizedBox(width: 8.0), // Szünet a gombok között
                  TextButton(
                    onPressed: _cancelChanges, // Módosítások visszavonása
                    child: const Text('Cancel'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _enableEditing(bool enable) {
    setState(() {
      _isEditingEnabled = enable;
    });
  }

  void _saveChanges() {
    widget.onUpdate!(_editedContent); // Módosítások mentése
    _enableEditing(false); // Szerkesztés kikapcsolása
  }

  void _cancelChanges() {
    setState(() {
      _editedContent = _originalContent; // Visszaállítjuk az eredeti tartalmat
      _editingController.text = _originalContent; // TextController tartalmának visszaállítása
    });
    _enableEditing(false); // Szerkesztés kikapcsolása
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Review"),
          content: const Text("Are you sure you want to delete this review?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: widget.onDelete, // Execute delete callback
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
