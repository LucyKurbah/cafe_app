import 'dart:io';
import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cafe_app/widgets/top_custom_shape.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/profile_skelton.dart';

import '../../components/read_only_textfield.dart';
import '../../services/api_response.dart';
import '../../services/profile_service.dart';
import '../../widgets/custom_widgets.dart';
import 'package:path/path.dart' as path;

import '../home/home_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<dynamic> _profileInfo = [].obs;
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  File? _file;
  String? _fileName;

  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        _isLoading = true;
        _loadProfile();
      });
    });
    super.initState();
    // load orders when the widget is initialized
  }

  Future<void> _loadProfile() async {
    ApiResponse response =
        await getProfile(); // call order service to get orders
    if (response.error == null) {
      setState(() {
        _profileInfo = response.data as List<dynamic>;
        _nameController = TextEditingController(text: _profileInfo[0].name);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = true;
        showSnackBar(title: '${response.error}', message: '');
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpeg', 'jpg'],
    );

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
        _fileName = path.basename(_file!.path);
      });
    }
  }

  void _saveProfile() async {
    String? filePath;
    if (_file != null) {
      filePath = _file?.path;
    }

    ApiResponse response = await saveProfileDetailsApiCall(
        filePath); // call order service to get orders
    if (response.error == null) {
      setState(() {
        _isLoading = false;
        showSnackBar(title: 'Document saved', message: '');
      });
    } else {
      setState(() {
        _isLoading = true;
        showSnackBar(title: '${response.error}', message: '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: mainColor,
          title: Text(
            "My Profile",
            style: TextStyle(color: textColor),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => const HomeScreen()));
            },
            icon: const Icon(Icons.arrow_back),
            color: textColor,
          )),
      body: _isLoading // show loading spinner if data is loading
          ? ListView.separated(
              itemCount: 1,
              itemBuilder: (context, index) => const ProfileSkelton(),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopCustomShape(profileInfo: _profileInfo[0]),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReadOnlyTextField(
                                label: 'Name',
                                defaultText: _nameController.text,
                                enable: false,
                              ),
                              SizedBox(
                                height: Dimensions.height20,
                              ),
                              ReadOnlyTextField(
                                label: 'Email',
                                defaultText: '${_profileInfo[0].email}',
                                enable: false,
                                // controller: _emailController
                              ),
                              SizedBox(
                                height: Dimensions.height20,
                              ),
                              ReadOnlyTextField(
                                label: 'Phone Number',
                                defaultText: '${_profileInfo[0].phone_no}',
                                enable: false,
                                //controller: _phoneController
                              ),
                              SizedBox(height: Dimensions.height15),
                              Text(
                                'Upload your ID (PDF/JPEG/JPG)',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: textColor),
                              ),
                              TextButton.icon(
                                onPressed: _pickFile,
                                icon: const Icon(Icons.upload_file),
                                label: _file != null
                                    ? Text(_fileName ?? '')
                                    : const Text('Select file'),
                              ),
                              SizedBox(height: Dimensions.height15),
                              ElevatedButton(
                                onPressed: _saveProfile,
                                child: const Text('Save Profile'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
