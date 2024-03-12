import 'package:flutter/material.dart';
import 'package:suraksha/Services/api_services/apiConstants.dart';
import 'package:suraksha/model/login_model.dart';
import 'package:suraksha/utils/colors%20.dart';
import 'package:suraksha/widgets/app_bar.dart';

import '../Services/api_services/apiStrings.dart';
import '../model/notification_response.dart';

class NotificationScreen extends StatefulWidget {
  final LoginResponse? loginResponse;

  const NotificationScreen({Key? key, this.loginResponse}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotifiaction();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: myAppBar(title: 'Notification', context: context),
      body: notificationResponse == null ? Center(child: CircularProgressIndicator(color: CustomColors.primaryColor),) :
      notificationResponse?.data?.isEmpty ??  true ? Center(child: Text('No notification found!'),) : ListView.builder(
        itemCount: notificationResponse?.data?.length ?? 0,
        shrinkWrap: true,
        itemBuilder: (context, index) {

          var item = notificationResponse?.data?[index];
        return  Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
            child: Container(
              // height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CustomColors.primaryColor.withOpacity(.1)
              ),

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: CustomColors.primaryColor.withOpacity(.3)
                    ),
                    child: Icon(Icons.notification_add_outlined,color: CustomColors.primaryColor,)),
                  title: Text( '${item?.title ?? ''}'),
                  subtitle: Text( '${item?.body ?? ''}'),
                ) /*Row(
                  children: [
                    Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: CustomColors.primaryColor.withOpacity(.3)
                        ),
                        child: Icon(Icons.notification_add_outlined,color: CustomColors.primaryColor,)),
                    SizedBox(width: 10,),
                    Expanded(child: Text( '${item?.body ?? ''}')),
                  ],
                ),*/
              ),
            ),
          );
      },),
    );
  }

  NotificationResponse? notificationResponse ;
  Future<void> getNotifiaction() async {


    apiBaseHelper.getAPICall(Uri.parse('${baseUrl}getNotifications/${widget.loginResponse?.data?.user?.suraksha_code}')).then((value) {
      bool status = value['status'];
      String msg = value['message'];
      if (status) {
        notificationResponse = NotificationResponse.fromJson(value);
        setState(() {});
      } else {
        setState(() {});
      }
    });
  }
}
