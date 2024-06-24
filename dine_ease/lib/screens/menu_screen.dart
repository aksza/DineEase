import 'package:dine_ease/models/menu_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/menu_view.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  static const routeName = '/menu_screen';
  final int restaurantId;
  final int? reservationId;

  MenuScreen({Key? key, required this.restaurantId,this.reservationId}) : super(key: key);
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Menu> menu = []; 
  final RequestUtil _requestUtil = RequestUtil();

  Future<void> getMenuByRestaurantId(int id) async {
    var smenu = await _requestUtil.getMenuByRestaurantId(id);
    setState(() {
      menu = smenu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: const Text('Menu'),
      ),
      body: Center(
        child: FutureBuilder<List<Menu>>(
          future: _requestUtil.getMenuByRestaurantId(widget.restaurantId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No menu items found');
            }
            menu = snapshot.data!;
            return ListView.builder(
              itemCount: menu.length,
              itemBuilder: (context, index) {
                return MenuView(
                    menu: menu[index],
                    reservationId: widget.reservationId,
                    );
              },
            );
          },
        ),
      ),
    );
  }
}