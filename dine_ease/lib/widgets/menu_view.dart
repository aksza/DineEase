import 'package:dine_ease/models/menu_model.dart';
import 'package:dine_ease/models/order_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';

// Globális rendelések lista
List<Order> orders = [];

class MenuView extends StatefulWidget {
  final Menu menu;
  final int? reservationId;
  const MenuView({Key? key, required this.menu, this.reservationId}) : super(key: key);

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  bool _isExpanded = false;
  final RequestUtil _requestUtil = RequestUtil();

  void _showCommentDialog() {
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a comment'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(
              hintText: 'Enter your comment',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel gomb megnyomása
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Order order = Order(
                  menuId: widget.menu.id,
                  reservationId: 0,
                  comment: commentController.text.isNotEmpty ? commentController.text : null,
                );

                setState(() {
                  orders.add(order);
                });
                Navigator.of(context).pop(); // Order hozzáadása után bezárás
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order added to cart'),
                  ),
                );
              },
              child: const Text('Add Order'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(widget.menu.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle: Text('${widget.menu.price} RON'),
              trailing: widget.reservationId != null
                  ? IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: _showCommentDialog,
                    )
                  : null,
            ),
            if (_isExpanded) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    const Text(
                      'Ingredients:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.menu.ingredients,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Menu Type:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.menu.menuTypeName,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ],
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(_isExpanded ? 'Show Less' : 'Show More'),
                    Icon(_isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
