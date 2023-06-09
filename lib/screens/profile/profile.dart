import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cafe_app/components/size_config.dart';
import 'package:cafe_app/widgets/top_custom_shape.dart';
import 'package:cafe_app/widgets/user_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/profile_skelton.dart';

import '../../components/read_only_textfield.dart';
import '../../services/api_response.dart';
import '../../services/orders_service.dart';
import '../../services/profile_service.dart';
import '../../widgets/custom_widgets.dart';
import 'package:path/path.dart' as path;

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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 10),(){
        setState(() {
          _isLoading = true;
          _loadProfile(); 
        });
    });
    super.initState();
    // load orders when the widget is initialized
  }

  Future<void> _loadProfile() async{
    ApiResponse response  = await getProfile(); // call order service to get orders
    if(response.error == null)
    {
       setState(() {
        _profileInfo = response.data as List<dynamic>;
        _nameController = TextEditingController(text: _profileInfo[0].name);
        _isLoading = false;
      });
    }
    else{
       setState(() {
        _isLoading = true;
        showSnackBar(title: '${response.error}', message: '');
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf','jpeg','jpg'],
    );

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
        _fileName = path.basename(_file!.path);
      });
    }
  }

  void _saveProfile() async{
    String? filePath;
    if (_file != null) {
      filePath = _file?.path;
    }
    // Map<String, dynamic> otherDetails = {
    //   'name': _nameController.text,
    //   'email': _emailController.text,
    //   'phone': _phoneController.text,
    // };

    // final response = await saveProfileDetailsApiCall(filePath);
    ApiResponse response  = await saveProfileDetailsApiCall(filePath); // call order service to get orders
    if(response.error == null)
    {
       setState(() {
          _isLoading = false;
          showSnackBar(title: 'Document saved', message: '');
      });
    }
    else{
       setState(() {
        _isLoading = true;
        showSnackBar(title: '${response.error}', message: '');
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text("My Profile",style: TextStyle(color: Colors.white),),
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            }, 
            icon: Icon(Icons.arrow_back), color: Colors.white,)
            
      ),
      body:
            _isLoading // show loading spinner if data is loading
                  ?
                  
                  ListView.separated(
                      itemCount: 1,
                      itemBuilder: (context, index) => const ProfileSkelton(),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 20),
                    )
                  : 
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TopCustomShape(profileInfo: _profileInfo[0]),
                      SizedBox(height: 20,),
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
                                          // controller: _nameController,
                                          // onChanged: (newValue) {
                                          //   setState(() {
                                          //     _nameController.text = newValue;
                                          //   });
                                          // },
                                        ),
                                        SizedBox(height: 20,),
                                      ReadOnlyTextField(
                                          label: 'Email',
                                          defaultText: '${_profileInfo[0].email}',
                                          enable : false,
                                          // controller: _emailController
                                      ),
                                      SizedBox(height: 20,),
                                      ReadOnlyTextField(
                                          label: 'Phone Number',
                                          defaultText: '${_profileInfo[0].phone_no}',
                                          enable: false,
                                          //controller: _phoneController
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Upload your ID (PDF/JPEG/JPG)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: _pickFile,
                                        icon: Icon(Icons.upload_file),
                                        label: _file != null ? Text(_fileName ?? ''): Text('Select file'),
                                      ),
                                      SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: _saveProfile,
                                        child: Text('Save Profile'),
                                      ),
                                    ],
                                  ),
                                )
                             
                             
                          ],
                        ),
                      )
                      
                
                      //SizeConfig.screenHeight!/34.15,),                              /// 20.0
                      // UserSection(icon_name: Icons.account_circle, section_text: "My information"),
                      // UserSection(icon_name: Icons.credit_card, section_text: "Credit Card"),
                      // UserSection(icon_name: Icons.shopping_basket, section_text: "Past orders"),
                      // UserSection(icon_name: Icons.location_city, section_text: "Address information"),
                      // UserSection(icon_name: Icons.wallet_giftcard, section_text: "Coupons"),
                    ],
                  ),
                ),
    );
  }
}