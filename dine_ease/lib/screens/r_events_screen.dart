import 'package:dine_ease/auth/db_service.dart';
import 'package:dine_ease/models/eventt_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:dine_ease/widgets/r_event_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class REventsScreen extends StatefulWidget {
  static const routeName = '/r_events';

  const REventsScreen({super.key});

  @override
  State<REventsScreen> createState() => _REventsScreenState();
}

class _REventsScreenState extends State<REventsScreen> {
  RequestUtil requestUtil = RequestUtil();
  List<Eventt> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  // Fetching events
  void fetchEvents() async {
    int restaurantId = await DataBaseProvider().getUserId();

    final response = await requestUtil.getEventsByRestaurantId(restaurantId);
    setState(() {
      events = response;
      isLoading = false;
    });
  }

  // Add event
  void addEvent(Eventt event) async {
    await requestUtil.postAddEvent(event);
    fetchEvents(); // Refresh events after adding a new event
  }

  // Show alert dialog for adding a new event
  void showAddEventDialog() {
    Eventt event = Eventt(
      id: 0,
      eventName: '',
      restaurantId: 0,
      restaurantName: '',
      description: '',
      startingDate: DateTime(1999, 1, 1),
      endingDate: DateTime(1999, 1, 1),
      eCategories: [],
    );

    TextEditingController startingDateController = TextEditingController();
    TextEditingController startingTimeController = TextEditingController();
    TextEditingController endingDateController = TextEditingController();
    TextEditingController endingTimeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'Event Name'),
                  onChanged: (value) {
                    event.eventName = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    event.description = value;
                  },
                ),
                TextField(
                  controller: startingDateController,
                  decoration: const InputDecoration(labelText: 'Select Starting Date'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                       if (selectedDate.isBefore(DateTime.now())) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a future date.'),
                            ),
                          );
                          return;
                        }
                      setState(() {
                        event.startingDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          event.startingDate.hour,
                          event.startingDate.minute,
                        );
                        startingDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                      });
                    }
                  },
                ),
                TextField(
                  controller: startingTimeController,
                  decoration: const InputDecoration(labelText: 'Select Starting Hour'),
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      setState(() {
                        event.startingDate = DateTime(
                          event.startingDate.year,
                          event.startingDate.month,
                          event.startingDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        startingTimeController.text = selectedTime.format(context);
                      });
                    }
                  },
                ),
                TextField(
                  controller: endingDateController,
                  decoration: const InputDecoration(labelText: 'Select Ending Date'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                       if (selectedDate.isBefore(DateTime.now())) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a future date.'),
                          ),
                        );
                        return;
                      }
                      setState(() {
                        event.endingDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          event.endingDate.hour,
                          event.endingDate.minute,
                        );
                        endingDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                      });
                    }
                  },
                ),
                TextField(
                  controller: endingTimeController,
                  decoration: const InputDecoration(labelText: 'Select Ending Hour'),
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      setState(() {
                        event.endingDate = DateTime(
                          event.endingDate.year,
                          event.endingDate.month,
                          event.endingDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        endingTimeController.text = selectedTime.format(context);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                if (event.eventName.isEmpty ||
                    event.description == null ||
                    event.startingDate == DateTime(1999, 1, 1) ||
                    event.endingDate == DateTime(1999, 1, 1)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill out all fields.'),
                    ),
                  );
                  return;
                }
                if (event.startingDate.isAfter(event.endingDate)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Starting date must be before ending date.'),
                    ),
                  );
                  return;
                }
                
                event.restaurantId = await DataBaseProvider().getUserId();
                addEvent(event);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Update event with requestutil
  void updateEvent() {
    fetchEvents(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 800 ? 3 : 2;
                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: constraints.maxWidth > 800 ? 24.0 : 16.0,
                    mainAxisSpacing: constraints.maxWidth > 800 ? 24.0 : 16.0,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: events.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return GestureDetector(
                        onTap: () {
                          showAddEventDialog();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange[500],
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '+',
                              style: TextStyle(
                                fontSize: 50.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      final event = events[index - 1];
                      return REventViewScreen(event: event,
                      //update event 
                       onUpdate: updateEvent);
                    }
                  },
                );
              },
            ),
    );
  }
}
