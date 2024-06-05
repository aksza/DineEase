import 'package:dine_ease/models/eventt_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class REventViewScreen extends StatefulWidget {
  final Eventt event;
  final VoidCallback onUpdate;

  REventViewScreen({required this.event, required this.onUpdate});

  @override
  State<REventViewScreen> createState() => _REventViewScreenState();
}

class _REventViewScreenState extends State<REventViewScreen> {
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _startingDateController = TextEditingController();
  TextEditingController _endingDateController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _startingHourController = TextEditingController();
  TextEditingController _endingHourController = TextEditingController();

  bool _isEditing = false;
  String text = 'Edit';

  RequestUtil _requestUtil = RequestUtil();

  @override
  void initState() {
    super.initState();
    setValues();
  }

  //set the values of the text controllers
  void setValues(){
    _eventNameController.text = widget.event.eventName;
    _startingDateController.text = DateFormat('yyyy-MM-dd').format(widget.event.startingDate);
    _startingHourController.text = DateFormat('HH:mm').format(widget.event.startingDate);
    _endingDateController.text = DateFormat('yyyy-MM-dd').format(widget.event.endingDate);
    _endingHourController.text = DateFormat('HH:mm').format(widget.event.endingDate);
    _descriptionController.text = widget.event.description ?? '';
  }

  //update event
  void updateEvent() async {
    Eventt updatedEvent = Eventt(
      id: widget.event.id,
      eventName: _eventNameController.text,
      restaurantId: widget.event.restaurantId,
      restaurantName: widget.event.restaurantName,
      description: _descriptionController.text,
      startingDate: DateTime.parse(_startingDateController.text + ' ' + _startingHourController.text),
      endingDate: DateTime.parse(_endingDateController.text + ' ' + _endingHourController.text),
    );
    Logger().i(updatedEvent);

    await _requestUtil.putUpdateEvent(updatedEvent);
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showEditEventDialog();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _eventNameController.text,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Event Date and Time
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${_startingDateController.text} - ${_endingDateController.text}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditEventDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(_isEditing ? 'Edit Event' : 'View Event'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _eventNameController,
                    readOnly: !_isEditing,
                    decoration: InputDecoration(labelText: 'Event Name'),
                  ),
                  TextFormField(
                    controller: _startingDateController,
                    readOnly: !_isEditing,
                    decoration: InputDecoration(labelText: 'Starting Date'),
                    onTap: () async {
                      DateTime? selectedDateTime = await showDatePicker(
                        context: context,
                        initialDate: _isEditing ? widget.event.startingDate : DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDateTime != null) {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: _isEditing ? TimeOfDay.fromDateTime(widget.event.startingDate) : TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          setState(() {
                            String formattedDateTime = '${DateFormat('yyyy-MM-dd').format(selectedDateTime)} ${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                            _startingDateController.text = formattedDateTime;
                          });
                        }
                      }
                    },
                  ),
                  TextFormField(
                    controller: _endingDateController,
                    readOnly: !_isEditing,
                    decoration: InputDecoration(labelText: 'Ending Date'),
                    onTap: () async {
                      DateTime? selectedDateTime = await showDatePicker(
                        context: context,
                        initialDate: _isEditing ? widget.event.endingDate : DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDateTime != null) {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: _isEditing ? TimeOfDay.fromDateTime(widget.event.endingDate) : TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          setState(() {
                            String formattedDateTime = '${DateFormat('yyyy-MM-dd').format(selectedDateTime)} ${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                            _endingDateController.text = formattedDateTime;
                          });
                        }
                      }
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _startingHourController,
                          readOnly: !_isEditing,
                          decoration: InputDecoration(labelText: 'Starting Time (HH:mm)'),
                          onTap: () async {
                            TimeOfDay? selectedTime = await showTimePicker(
                              context: context,
                              initialTime: _isEditing ? TimeOfDay.fromDateTime(widget.event.startingDate) : TimeOfDay.now(),
                            );
                            if (selectedTime != null) {
                              setState(() {
                                _startingHourController.text = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _endingHourController,
                          readOnly: !_isEditing,
                          decoration: InputDecoration(labelText: 'Ending Time (HH:mm)'),
                          onTap: () async {
                            TimeOfDay? selectedTime = await showTimePicker(
                              context: context,
                              initialTime: _isEditing ? TimeOfDay.fromDateTime(widget.event.endingDate) : TimeOfDay.now(),
                            );
                            if (selectedTime != null) {
                              setState(() {
                                _endingHourController.text = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    readOnly: !_isEditing,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    if (_isEditing) {
                      _isEditing = false;
                      text = 'Edit';
                      if (DateTime.parse(_startingDateController.text + ' ' + _startingHourController.text).isAfter(DateTime.parse(_endingDateController.text + ' ' + _endingHourController.text))) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Starting Date cannot be greater than Ending Date')));
                        return;
                      }
                      updateEvent();
                      widget.onUpdate();
                    } else {
                      _isEditing = true;
                      text = 'Save';
                    }
                  });
                },
                child: Text(text),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    },
  );
}
}
