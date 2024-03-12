import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suraksha/Services/api_services/apiConstants.dart';
import 'package:suraksha/model/login_model.dart';
import 'package:suraksha/utils/colors%20.dart';
import 'package:suraksha/utils/extentions.dart';
import 'package:suraksha/utils/globles.dart';
import 'package:suraksha/widgets/app_bar.dart';
import 'package:suraksha/widgets/app_btn.dart';
import 'package:suraksha/widgets/app_textField.dart';
import 'package:http/http.dart'as http;

class ProfilePage extends StatefulWidget {

  final LoginResponse? userData;
  const ProfilePage({super.key,this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  XFile? _selectedImage;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Choose Image Source'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ImageSource.camera);
              },
              child: Text('Camera'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, ImageSource.gallery);
              },
              child: Text('Gallery'),
            ),
          ],
        );
      },
    );

    if (source != null) {
      final XFile? image = await _picker.pickImage(source: source,imageQuality: 80,maxHeight: 400,maxWidth: 400);

      setState(() {
        _selectedImage = image;
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.userData?.data?.user?.fullName ?? '';
        mobileController.text =widget.userData?.data?.user?.mobile ?? '' ;
    emailController.text =widget.userData?.data?.user?.email ?? '' ;
        addressController.text = widget.userData?.data?.user?.address ?? '' ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'My Profile',context: context),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        //decoration: BoxDecoration().myBoxDecoration(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: CustomColors.primaryColor)
                  ),
                  child: _selectedImage != null
                      ? Image.file(File(_selectedImage!.path), fit: BoxFit.fill,)
                      : Image.network('${widget.userData?.data?.user?.profile}',fit: BoxFit.fill,errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.person, size: 50,color:  CustomColors.primaryColor,);
                      },),
                ),
              ),
              SizedBox(height: 5,),
              Text('Id: ${widget.userData?.data?.user?.suraksha_code}', style: TextStyle(color: CustomColors.grayColor.withOpacity(0.5)),),

              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text("Information",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: CustomColors.blackTemp),),
                  ),
                ],
              ),
              Divider(),

              SizedBox(height: 20,),

              AppTextField(
                controller: nameController,
                prefixIcon: Icons.person,
                hint: "Enter Name",
                validator: nameTextValidator,
                inputType:TextInputType.text,

              ),
              const SizedBox(
                height: 20,
              ),
              AppTextField(
                controller: mobileController,
                prefixIcon: Icons.call,
                hint: "Mobile Number",
                validator: mobileValidator,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]'),
                  ),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              AppTextField(
                controller: emailController,
                prefixIcon: Icons.email,
                hint: "Enter Email",
                validator: emailValidator,
                inputType:TextInputType.emailAddress,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(8),
                  // FilteringTextInputFormatter.allow(
                  // //  RegExp(r'[0-8]'),
                  // ),
                  // FilteringTextInputFormatter.digitsOnly
                ],
              ),

              SizedBox(height: 20,),
              AppTextField(
                controller: addressController,
                prefixIcon: Icons.location_city,
                hint: "Enter Address",
                validator: nameTextValidator,
                inputType:TextInputType.text,


              ),

              SizedBox(
                height: 30,
              ),
              AppButton(title: 'Update Profile', onTab: (){
                updateProfile ();
                if(_selectedImage !=null){
                  updateProfilePicture();
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget profileTile(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      height: 50,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(15)),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  color:  CustomColors.blackTemp,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  color:  CustomColors.blackTemp,
                  fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
  
  Future<void> updateProfile () async{
      var uri = Uri.parse('${baseUrl}user/${widget.userData?.data?.user?.token}?full_name=${nameController.text}&address=${addressController.text}');
    
    apiBaseHelper.putAPICall(uri).then((value) {

      bool status = value['status'];
      String msg = value['message'];

      Fluttertoast.showToast(msg: msg);

      Navigator.pop(context);


    });
    
    
  }


  Future<void>updateProfilePicture()async{
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}changeProfile'));
    request.fields.addAll({
      'user_id': '${widget.userData?.data?.user?.token}'
    });
    if(_selectedImage!=null) {
      request.files.add(await http.MultipartFile.fromPath(
          'image', _selectedImage?.path ?? ''));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }
  
}