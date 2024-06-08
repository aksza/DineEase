import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/helper/order_notifier.dart';
import 'package:dine_ease/models/menu_type_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:dine_ease/models/menu_model.dart';
import 'package:dine_ease/models/order_model.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class MenuView extends StatefulWidget {
  final Menu menu;
  final int? reservationId;
  VoidCallback? onDelete;

  MenuView({
    required this.menu,
    this.reservationId,
    this.onDelete,
  });

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final RequestUtil _requestUtil = RequestUtil();
  bool _isExpanded = false;
  late String role;
  bool isLoading = true;
  late List<MenuType> _menuTypes = [];
  late int restaurant;


  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  void fetchDetails() async{
    try{
      var menus = await _requestUtil.getMenuTypes();
      int restaurantId = await DataBaseProvider().getUserId();
      DataBaseProvider().getRole().then((value) {
        setState(() {
          role = value;
          isLoading = false;
          _menuTypes = menus;
          restaurant = restaurantId;
        });
      });
    }catch(e){
      print(e);
    }
  }
  
  void _updateMenuItem(Menu menu) async {
    try {
      await _requestUtil.putUpdateMenu(menu);
      setState(() {
        
      });
    } catch (e) {
      print(e);
    }
  }

  void _showCommentDialog(BuildContext context) {
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
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Order order = Order(
                  menuId: widget.menu.id!,
                  menuName: widget.menu.name,
                  reservationId: 0,
                  comment: commentController.text.isNotEmpty ? commentController.text : null,
                  price: widget.menu.price,
                );

                Provider.of<OrderProvider>(context, listen: false).addOrder(order);
                Navigator.of(context).pop(); 
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

  void _showEditDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ingredientsController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    int? menuTypeId = widget.menu.menuypeId;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Menu Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    //initial value
                    controller: nameController..text = widget.menu.name,
                    // controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: ingredientsController..text = widget.menu.ingredients,
                    decoration: const InputDecoration(labelText: 'Ingredients'),
                  ),
                  TextField(
                    controller: priceController..text = widget.menu.price.toString(),
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), 
                    ],
                  ),
                  DropdownButton<int>(
                    value: menuTypeId,
                    items: _menuTypes.map((menuType) {
                      return DropdownMenuItem<int>(
                        value: menuType.id,
                        child: Text(menuType.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        menuTypeId = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(nameController.text.isEmpty || ingredientsController.text.isEmpty || priceController.text.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields'),
                        ),
                      );
                      return;
                    }
                    final newItem = Menu(
                      id: widget.menu.id,
                      restaurantId: restaurant,
                      name: nameController.text,
                      ingredients: ingredientsController.text,
                      price: int.parse(priceController.text),
                      menuypeId: menuTypeId!,
                      menuTypeName: _menuTypes.firstWhere((element) => element.id == menuTypeId).name,
                    );
                    Logger().i({ newItem.name, newItem.ingredients, newItem.price, newItem.restaurantId, newItem.menuypeId});
                    _updateMenuItem(newItem);
                    setState(() {
                      widget.menu.name = newItem.name;
                      widget.menu.ingredients = newItem.ingredients;
                      widget.menu.price = newItem.price;
                      widget.menu.menuTypeName = newItem.menuTypeName;
                      widget.menu.menuypeId = newItem.menuypeId;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteMenu() async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this menu item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Logger().i({'Menu id': widget.menu.id, 'Menu name': widget.menu.name, 'Menu price': widget.menu.price});
                Navigator.of(context).pop(true); // Confirm
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        await _requestUtil.deleteRemoveMenu(widget.menu.id!);
        setState(() {

        });
        if (widget.onDelete != null) {
          widget.onDelete!();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Menu item deleted successfully'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete menu item: $e'),
          ),
        );
      }
    }
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
              trailing: isLoading
                  ? CircularProgressIndicator()
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.reservationId != null)
                          IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () => _showCommentDialog(context),
                          ),
                        if (role == "Restaurant") ...[
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: _showEditDialog,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: _deleteMenu,
                          ),
                        ],
                      ],
                    ),
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
                      widget.menu.menuTypeName!,
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
