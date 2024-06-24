import 'package:dine_ease/models/user_model.dart';
import 'package:dine_ease/utils/request_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final RequestUtil requestUtil = RequestUtil();
  late int userId;
  late SharedPreferences prefs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneNumController = TextEditingController();
  bool isAdmin = false;

  List<bool> editable = [false, false, false, false];
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId')!;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      var userData = await requestUtil.getUserById(userId);
      setState(() {
        emailController.text = userData.email;
        firstnameController.text = userData.firstName;
        lastnameController.text = userData.lastName;
        phoneNumController.text = userData.phoneNum;
        isAdmin = userData.isAdmin;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveUserData() async {
    try {
      var userData = User(
        id: userId,
        email: emailController.text,
        firstName: firstnameController.text,
        lastName: lastnameController.text,
        phoneNum: phoneNumController.text,
        isAdmin: isAdmin,
      );
      await requestUtil.postUserUpdate(userId, userData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data saved!')),
      );
    } catch (e) {
      print('Error updating user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Edit Profile'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildEditableTextField(
                      controller: emailController,
                      label: 'Email',
                      index: 0,
                    ),
                    buildEditableTextField(
                      controller: firstnameController,
                      label: 'First Name',
                      index: 1,
                    ),
                    buildEditableTextField(
                      controller: lastnameController,
                      label: 'Last Name',
                      index: 2,
                    ),
                    buildEditableTextField(
                      controller: phoneNumController,
                      label: 'Phone Number',
                      index: 3,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (emailController.text.isEmpty ||
                            firstnameController.text.isEmpty ||
                            lastnameController.text.isEmpty ||
                            phoneNumController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill in all fields'),
                            ),
                          );
                        } else {
                          saveUserData();
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildEditableTextField({
    required TextEditingController controller,
    required String label,
    required int index,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: label),
            readOnly: !editable[index],
          ),
        ),
        IconButton(
          icon: Icon(editable[index] ? Icons.check : Icons.edit),
          onPressed: () {
            setState(() {
              editable[index] = !editable[index];
            });
          },
        ),
      ],
    );
  }
}
