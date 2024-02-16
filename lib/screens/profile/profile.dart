import 'dart:convert';
import 'dart:io';
import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cafe_app/widgets/top_custom_shape.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../api/apiFile.dart';
import '../../components/profile_skelton.dart';
import '../../components/read_only_textfield.dart';
import '../../services/api_response.dart';
import '../../services/profile_service.dart';
import '../../services/user_service.dart';
import '../../widgets/custom_widgets.dart';
import 'package:path/path.dart' as path;
import '../home/home_screen.dart';
import '../user/login.dart';

class Profile extends StatefulWidget {
  final AnimationController animationController;
  const Profile({super.key, required this.animationController});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

 
  List<dynamic> _profileInfo = [].obs;
  bool _isLoading = true;
  List<dynamic> _idList = [].obs;
  int userId = 0;
  String dropdownvalue = "0";
  bool _loading = true;
    int f_id = 0;

  final _formKey = GlobalKey<FormState>();
  File? _file;
  String? _fileName;
  String? _fileData;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {

    widget.animationController.forward();
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        _isLoading = true;
        _loadProfile();
      });
    });
    super.initState();
    // load orders when the widget is initialized
  }

  Future<void> retrieveIDList() async {
    userId = await getUserId();
    ApiResponse response = await getIDList();
    if (response.error == null) {
      setState(() {
        _idList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == ApiConstants.unauthorized) {
      logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  Future<void> _loadProfile() async {
    ApiResponse response =
        await getProfile(); // call order service to get orders
    if (response.error == null) {
      setState(() {
        _profileInfo = response.data as List<dynamic>;
        _nameController = TextEditingController(text: _profileInfo[0].name);
        print(_profileInfo[0]);
        dropdownvalue =  "0"; 
        _isLoading = false;
        retrieveIDList();
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
        _fileName = result.files.single.path?.split('/').last;
        _fileData = base64Encode(_file!.readAsBytesSync());
        var fileData = base64Encode(_file?.readAsBytesSync() as List<int>);
        _fileName = path.basename(_file!.path);
        _uploadProfile();
      });
    }
    else
    {
      return null;
    }
  }
  
  Future<void> _deleteFile() async {
     ApiResponse response = await deleteDocument(); // call order service to get orders
    if (response.error == null) {
      setState(() {
        _loadProfile();
        _file = null;
        _isLoading = false;
        showSnackBar(title: 'Document deleted', message: '');
        
      });
    } else {
      setState(() {
        _isLoading = true;
        showSnackBar(title: '${response.error}', message: '');
      });
    }
  }

  void _saveProfile() async {
    ApiResponse response = await saveProfileDetailsApiCall(_nameController.text,dropdownvalue);
     // call order service to get orders
    if (response.error == null) {
      setState(() {
        _isLoading = false;
        showSnackBar(title: 'Saved', message: '');
        _loadProfile();
      });
    } else {
      setState(() {
        _isLoading = true;
        showSnackBar(title: '${response.error}', message: '');
         _loadProfile();
      });
    }
  }

  void _uploadProfile() async {

    ApiResponse response = await uploadFile( _fileName, _fileData); // call order service to get orders
    if (response.error == null) {
      setState(() {
        _isLoading = false;
        showSnackBar(title: 'Uploaded', message: '');
        _loadProfile();
      });
    } else {
      setState(() {
        _isLoading = true;
        showSnackBar(title: '${response.error}', message: '');
         _loadProfile();
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
    );
  }
}
