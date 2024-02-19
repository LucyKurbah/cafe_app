import 'dart:convert';
import 'dart:io';
import 'package:cafe_app/components/colors.dart';
import 'package:cafe_app/components/dimensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cafe_app/widgets/top_custom_shape.dart';
import 'package:flutter/material.dart';
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

class ProfileOld extends StatefulWidget {
  const ProfileOld({super.key});

  @override
  State<ProfileOld> createState() => _ProfileOldState();
}

class _ProfileOldState extends State<ProfileOld> {
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
                              // ReadOnlyTextField(
                              //   label: 'Name',
                              //   defaultText: _nameController.text,
                              //   enable: true,
                              // ),
                              TextField(
                                    controller: _nameController,
                                    style:  TextStyle(
                                      color: textColor,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: "Name",
                                      labelStyle: TextStyle(color: textColor),
                                      border:  OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: greyColor,
                                          width: 1.0,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                        ),
                                      ),
                                      enabledBorder:  OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: greyColor,
                                          width: 1.0,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                        ),
                                      ),
                                      disabledBorder:  OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: greyColor,
                                          width: 1.0,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                        ),
                                      ),
                                      focusedBorder:  OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: blueColor,
                                          width: 2.0,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                                                SizedBox(
                                height: Dimensions.height10,
                              ),
                              ReadOnlyTextField(
                                label: 'Email',
                                defaultText: '${_profileInfo[0].email}',
                                enable: false,
                                // controller: _emailController
                              ),
                              SizedBox(
                                height: Dimensions.height10,
                              ),
                              ReadOnlyTextField(
                                label: 'Phone Number',
                                defaultText: '${_profileInfo[0].phone_no}',
                                enable: false,
                                //controller: _phoneController
                              ),
                              
                              SizedBox(height: Dimensions.height20),
                              Text(
                                'Upload ID:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: textColor),
                              ),
                             
                              SizedBox(height: Dimensions.height10),
                             
                              DropdownButton<String>(
                                    value: dropdownvalue,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: [
                                      const DropdownMenuItem<String>(
                                        value: "0",
                                        child: Text("Select ID"),
                                      ),
                                      ..._idList.map((floor) {
                                        // print(floor.id.toString());
                                        return DropdownMenuItem<String>(
                                          value: floor.id.toString(),
                                          child: Text(floor.document_name),
                                        );
                                      }).toList(),
                                    ],
                                    onChanged: (String? newValue) {

                                      setState(() {
                                        dropdownvalue = newValue!;
                                        if (newValue == "0") {
                                         
                                          f_id = 0; // Set the  ID to null or any other default value
                                        } else {
                                          for (var id in _idList) {
                                            if (id.id.toString() ==
                                                newValue) {
                                            
                                              f_id = id.id;//int.parse(newValue.substring(1));
                                            }
                                          }
                                        }
                                      });
                                    },
                                    style: TextStyle(color: textColor),
                                    dropdownColor: greyColor7,
                                    underline: Container(
                                      height: 1,
                                      color: textColor,
                                    ),
                                    isExpanded: true,
                                    hint: Text(
                                      dropdownvalue ?? 'Select ID',
                                      style: TextStyle(color: textColor),
                                ),
                              )  ,
                              SizedBox(height: Dimensions.height20),
                              _profileInfo[0].doc_image != "" ? 
                              Column(
                                        children: [
                                          Text(
                                            'Uploaded Document:',
                                            style: TextStyle(fontSize: 13, color: textColor),
                                          ),
                                          SizedBox(height: 10),
                                          Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              Image.network(
                                                '${ _profileInfo[0].doc_image }',
                                                width: MediaQuery.sizeOf(context).width,
                                                height: 150,
                                                fit: BoxFit.cover,
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // IconButton(
                                                  //   onPressed: _pickFile,
                                                  //   icon: Icon(Icons.edit),
                                                  // ),
                                                  IconButton(
                                                    onPressed: _deleteFile,
                                                    icon: Icon(Icons.delete),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                              :
                              TextButton.icon(
                                onPressed: _pickFile,
                                icon: const Icon(Icons.upload_file),
                                label: _file != null
                                    ? Text(_fileName ?? '')
                                    : const Text('Select file'),
                              ),
                              // _file != null ?
                              // Container(
                              //       height: 200,
                              //       width: MediaQuery.of(context).size.width, // Set your desired height here
                              //       child: _file != null
                              //           ? Image.file(
                              //               _file!,
                              //               fit: BoxFit.cover,
                              //             )
                              //           : Text("File not Chosen"),
                              //     ): Text(""),
                              SizedBox(height: Dimensions.height15),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: _saveProfile,
                                        child: const Text('Save Profile'),
                                      ),
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
