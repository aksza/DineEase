import 'package:dine_ease/models/review_models.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantReview extends StatefulWidget {
  final Review review;
  final Function(String)? onEdit;
  final VoidCallback? onDelete;

  RestaurantReview({
    required this.review,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<RestaurantReview> createState() => _RestaurantReviewState();
}
class _RestaurantReviewState extends State<RestaurantReview> {
  late SharedPreferences prefs;
  late String ownEmail;
  late String email;
  RequestUtil requestUtil = RequestUtil();
  bool isExpanded = false;
  bool isLoading = true;
  bool isEditing = false; 
  late TextEditingController _editingController; 
  late String _originalContent;
  @override
  void initState() {
    super.initState();
    getUserById(widget.review.userId);
    initPrefs();
    _editingController = TextEditingController(text: widget.review.content);
    _originalContent = widget.review.content; 
  }

  void _saveChanges() {
    widget.onEdit?.call(_editingController.text);
    setState(() {
      isEditing = false;
    });
  }

  void _cancelChanges() {
    setState(() {
      isEditing = false;
      _editingController.text = _originalContent; 
    });
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      ownEmail = prefs.getString('email')!;
    });
  }

  Future<void> getUserById(int id) async {
    var user = await requestUtil.getUserById(id);
    setState(() {
      email = user.email;
      isLoading = false;
    });
  }

  void _showDeleteConfirmationDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Review'),
        content: Text('Do you want to delete your review?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              widget.onDelete?.call();
              Navigator.of(context).pop(); 
            },
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.account_circle, size: 48.0),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          email,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        if (isEditing) 
                          TextField(
                            controller: _editingController,
                            autofocus: true,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          )
                        else
                          Text(
                            widget.review.content,
                            maxLines: isExpanded ? null : 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (ownEmail == email)
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                        ),
                        if (isExpanded)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (isEditing) 
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.save),
                                      onPressed: _saveChanges,
                                      // },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.cancel),
                                      onPressed: _cancelChanges,
                                    ),
                                  ],
                                )
                              else
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      isEditing = true;
                                    });
                                  },
                                ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteConfirmationDialog();
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                ],
              ),
            ),
          );
  }
}
