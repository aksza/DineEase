import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/menu_model.dart';
import 'package:dine_ease/models/menu_type_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/menu_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class RMenuScreen extends StatefulWidget {
  static const routeName = '/r_menu';

  const RMenuScreen({super.key});

  @override
  State<RMenuScreen> createState() => _RMenuScreenState();
}

class _RMenuScreenState extends State<RMenuScreen> {
  final RequestUtil _requestUtil = RequestUtil();
  late List<Menu> _menus = [];
  late List<MenuType> _menuTypes = [];
  bool isLoading = true;
  late int restaurant;

  @override
  void initState() {
    super.initState();
    _fetchMenu();
  }

  void _fetchMenu() async {
    try {
      int restaurantId = await DataBaseProvider().getUserId();
      final response = await _requestUtil.getMenuByRestaurantId(restaurantId);
      final response2 = await _requestUtil.getMenuTypes();
      setState(() {
        _menus = response;
        _menuTypes = response2;
        restaurant = restaurantId;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _addMenuItem(Menu menu) async {
    try {
      await _requestUtil.postAddMenu(menu);
      var menus = await _requestUtil.getMenuByRestaurantId(restaurant);
      setState(() {
        _menus = menus;
      });
    } catch (e) {
      print(e);
    }
  }

  void _onMenuDeleted() {
    setState(() {
      _fetchMenu();
    });
  }

  void _showAddMenuDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ingredientsController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    int? menuTypeId = _menuTypes.isNotEmpty ? _menuTypes[0].id : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Menu Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: ingredientsController,
                    decoration: const InputDecoration(labelText: 'Ingredients'),
                  ),
                  TextField(
                    controller: priceController,
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
                    //ha a controllerek nem uresek
                    if (nameController.text.isEmpty || ingredientsController.text.isEmpty || priceController.text.isEmpty) {
                      return;
                    }
                    final newItem = Menu(
                      name: nameController.text,
                      ingredients: ingredientsController.text,
                      price: int.parse(priceController.text),
                      restaurantId: restaurant, 
                      menuypeId: menuTypeId!,
                    );
                    Logger().i({ newItem.name, newItem.ingredients, newItem.price, newItem.restaurantId, newItem.menuypeId});
                    _addMenuItem(newItem);
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _showAddMenuDialog,
                    child: const Text('+ Add Menu'),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _menus.length,
                    itemBuilder: (context, index) {
                      return MenuView(menu: _menus[index], onDelete: _onMenuDeleted);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
