import 'package:dine_ease/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget{
  void Function(int,String?)? onTabChange;

  CustomAppBar(this.onTabChange, {Key? key});
  @override
  State<CustomAppBar> createState() => _CustomAppBar();
  
  @override
  Size get preferredSize => const Size(
    double.maxFinite,
    136
  );
}

class _CustomAppBar extends State<CustomAppBar>{
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context){
    final bool isPhone = MediaQuery.of(context).size.shortestSide < 600;

    return SafeArea(
      child: 
        Stack(
          children: [
            Positioned.fill(
              child: 
              
               Column(
                 children: [
                   Padding(
                      padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 25/2.5
                    ),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SearchBar(
                            // elevation: MaterialStateProperty.all(25.0),
                            backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 240, 240, 240),
                            ),
                            controller: textController,
                            hintText: "Search",
                            hintStyle: MaterialStateProperty.all(const TextStyle(color: Colors.grey, fontSize: 14.0)),                    
                          ),
                        ),
                        IconButton(onPressed: (){
                          if(textController.text.isNotEmpty)
                          {
                            widget.onTabChange!(4,textController.text);
                            setState(() {
                              textController.clear();
                            });
                          }
                        },
                        icon: const Icon(Icons.search_rounded)),
                        //space between
                        //notification button with an icon in background
                        // ElevatedButton(
                        //   onPressed: (){},
                        //   style: ButtonStyle(
                        //     backgroundColor: MaterialStateProperty.all(Colors.white),
                        //     shape: MaterialStateProperty.all(
                        //       RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(10),
                        //       ),
                        //     ),
                        //     elevation: MaterialStateProperty.all(0),
                        //   ),
                        //   child: const Icon(
                        //     Icons.notifications_rounded,
                        //     color: Colors.black,
                        //   ),
                        // ),
                        //profile with an icon in background gesturedetector
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserScreen()
                              )
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.black,
                              size: 30.0,
                            ),
                          ),
                        )
                        
                      ]
                    )
                   ),
                    //space between
                    const SizedBox(height: 10),
                    //scrollable tabs with button: for you, restaurants, events, restaurants for events
                    Center(
                      child: DefaultTabController(length: 4, child: 
                      TabBar(
                        
                        onTap: (selectedTabIndex) {widget.onTabChange!(selectedTabIndex,null);},
                        isScrollable: true,
                        //set tabalignment to center
                        tabAlignment: TabAlignment.center,
                        tabs: 
                        [
                          Tab(
                            child: Text(
                              "For You",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: isPhone ? 14 : 20 ,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Restaurants",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: isPhone ? 14 : 20 ,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Events",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: isPhone ? 14 : 20 ,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Restaurants for Events",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: isPhone ? 14 : 20 ,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      )
                      ),
                    )
                 ],
               ),
            )
          ],
            
        ),
      
      
      );
  }
}