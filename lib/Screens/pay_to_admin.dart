import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suraksha/Services/api_services/apiConstants.dart';
import 'package:suraksha/utils/globles.dart';
import 'package:suraksha/widgets/app_bar.dart';
import 'package:suraksha/widgets/app_btn.dart';
import 'package:http/http.dart'as http;

class PayScreen extends StatefulWidget {
  const PayScreen({Key? key,this.userToken, this.promo,this.amount,this.discount,this.enddate}) : super(key: key);

  final String? userToken;
  final String? promo;
  final String? amount;
  final String? discount;
  final String? enddate;


  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  String? adminQrLink ;
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQrLink();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Admin Qr', context: context),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // qr code image
              Container(
                padding:
                const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                child:  Image.network(adminQrLink ??'',errorBuilder: (context, error, stackTrace) => Center(child: CircularProgressIndicator(),)),
              ),
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(5.0),
                child:  Text(
                  "Scan And Pay ${widget.amount}/-",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              /*  const Text(
                textAlign: TextAlign.center,
                "QR Code Result",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
             GestureDetector(
                onLongPress: () {},
                child: SelectableText(
                  qrCodeResult,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                  cursorColor: Colors.red,
                  showCursor: true,
                  toolbarOptions: const ToolbarOptions(
                    copy: true,
                    cut: true,
                    paste: true,
                    selectAll: true,
                  ),
                ),
              ),*/

              Container(
                padding:
                const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                height: 68.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(
                        32.0,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    showBottomSheet(context);
              /*ScanResult codeScanner = await BarcodeScanner.scan();
                    setState(
                          () {
                        qrCodeResult = codeScanner.rawContent;
                      },
                    );*/ //barcode scanner
                  },
                  child: const Text(
                    "Upload Payment Photo",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  getQrLink() async{
    apiBaseHelper.getAPICall(Uri.parse('${baseUrl}qr_details')).then((value) {

      bool status = value['status'];

      if(status) {
        adminQrLink =  value['data']['qr_details'];
        setState(() {

        });
      }

    });
  }
  
  sendToAdmin() async{
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}addPaymentScreenshot'));
    print('${widget.userToken}-_________token____');
    request.fields.addAll({
      'user_id': widget.userToken ?? "",
    /*"transaction_id" : 'Menual',
    'transaction_details': '',
    'amount': widget.amount ?? '0',
    'discount': widget.discount ?? '0',
    'promo_code': widget.promo ?? '',
    'type_id': '1',*/
    });
    /*if(widget.enddate !=null){

      request.fields.addAll({
        'plan_ends': widget.enddate ?? ''
      });
    }*/
    if(imageFile !=null) {
      request.files.add(await http.MultipartFile.fromPath(
          'screenshot', imageFile?.path ?? ''));
    }
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    var rsult = await response.stream.bytesToString();
    log(rsult);
    var finalResult = jsonDecode(rsult);
    Fluttertoast.showToast(msg: finalResult['message']);

    await addTransaction(
        transactionId: 'manual',
        amount: widget.amount ?? '0',
        discount: widget.discount ?? '0',
        promo: widget.promo ?? '',
        token: widget.userToken ?? "",
        enDate: widget.enddate ?? '',
        ssId: finalResult['data']['screenshot_id'].toString());
    
    }
    else {
      Fluttertoast.showToast(msg: 'Something went wrong! ');

      print(response.reasonPhrase);
    }
  }



Future<void> showBottomSheet(BuildContext context) async{
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10))),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text("Take Image From",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
              ListTile(
                leading: Image.asset(
                  'assets/icons/cameraicon.png',
                  scale: 1.5,
                ),
                title: Text('Camera',
                    style: TextStyle(
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  _getFromCamera(context);
                },
              ),
              ListTile(
                leading: Image.asset(
                  'assets/icons/galleryicon.png',
                  scale: 1.5,
                ),
                title: const Text('Gallery',
                    style: TextStyle(
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  _getFromGallery(context);
                },
              ),
              ListTile(
                leading: Image.asset(
                  'assets/icons/cancelicon.png',
                  scale: 1.5,
                ),
                title: const Text('Cancel',
                    style: TextStyle(
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      });
}

Future<void>showDialogBox(BuildContext context) async{
    showDialog(context: context, builder: (context) {
      return AlertDialog(title: Image.file(imageFile ?? File('')),actions: [
        AppButton(title: 'Send', onTab: (){
          Navigator.pop(context);
          sendToAdmin();
        })
      ],);

    },);
}

  _getFromGallery(BuildContext context) async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        print('${imageFile}gggggg');
      });
      Navigator.pop(context);
      showDialogBox(context);
    }
  }

  _getFromCamera(BuildContext context) async {

    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 80,maxHeight: 400,maxWidth: 400);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Navigator.pop(context);
      showDialogBox(context);
    }
  }


}
