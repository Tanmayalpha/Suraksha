import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:suraksha/Services/api_services/apiConstants.dart';
import 'package:suraksha/utils/colors%20.dart';
import 'package:suraksha/widgets/app_bar.dart';

import '../model/call_logs_response.dart';

class CallLogsScreen extends StatefulWidget {
  final String? id;

  const CallLogsScreen({Key? key, this.id}) : super(key: key);

  @override
  State<CallLogsScreen> createState() => _CallLogsScreenState();
}

class _CallLogsScreenState extends State<CallLogsScreen> {
  final List<CallLog> callLogs = [
    CallLog(
        callerName: "John Doe",
        callDuration: "2m 30s",
        callStatus: CallStatus.missed,
        message: "Missed your call."),
    CallLog(
        callerName: "Jane Smith",
        callDuration: "1m 45s",
        callStatus: CallStatus.received),
    CallLog(
        callerName: "Alice Johnson",
        callDuration: "3m 10s",
        callStatus: CallStatus.dialed),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCallLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Call logs', context: context),
      body: callLogsRsponse == null
          ? Center(
              child: CircularProgressIndicator(
                color: CustomColors.primaryColor,
              ),
            )
          : callLogsRsponse?.data?.isEmpty ?? true
              ? Center(
                  child: Text('No call logs found!'),
                )
              : ListView.builder(
                  itemCount: callLogsRsponse?.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    var item = callLogsRsponse?.data?[index];
                    return ListTile(
                      leading: _getCallStatusIcon(item?.callStatus ?? '0'),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(item?.callStatus == '0' ? 'Missed call' : 'Received call'),
                        Text( '${DateFormat('dd MMM yyy hh:mm a').format(DateTime.parse(item?.callDialed ?? ''))}')],),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item?.duration.toString() ?? ''),
                          if (item?.callStatus == '0' && item?.message != null)
                            Text(
                              item?.message ?? '',
                              style: TextStyle(
                                  color: Colors
                                      .red), // Customizing style for missed call message
                            ),
                        ],
                      ),
                      trailing: InkWell(
                        onTap: (){
                          showDialog(context: context, builder: (context) => AlertDialog(title: Image.network('${item?.callerImage}'),));
                        },
                        child: Container(
                            height: 50,
                            width: 50,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                                image: DecorationImage(
                                    image: NetworkImage('${item?.callerImage}'),
                                    fit: BoxFit.cover),borderRadius: BorderRadius.circular(25))),
                      ),
                      onTap: () {
                        // Add your onTap logic here
                      },
                    );
                  },
                ),
    );
  }

  Widget _getCallStatusIcon(String status) {
    IconData? icon;
    Color? color;
    switch (status) {
      case '0':
        icon = Icons.call_missed;
        color = Colors.red;
        break;
      case '1':
        icon = Icons.call_received;
        color = Colors.green;
        break;
      /*case CallStatus.dialed:
        icon = Icons.call_made;
        color = Colors.blue;
        break;*/
    }
    return Icon(icon, color: color);
  }

  Widget _getCallStatusIndicator(String status) {
    Color? color;
    switch (status) {
      case "0":
        color = Colors.red;
        break;
      case CallStatus.received:
        color = Colors.green;
        /* break;
      case CallStatus.dialed:
        color = Colors.blue;*/
        break;
    }
    return CircleAvatar(backgroundColor: color, radius: 8);
  }

  CallLogsRsponse? callLogsRsponse;

  getCallLogs() async {
    apiBaseHelper
        .getAPICall(Uri.parse('${baseUrl}getLogs/${widget.id}'))
        .then((value) {
      bool status = value['status'];
      String msg = value['message'];

      if (status) {
        callLogsRsponse = CallLogsRsponse.fromJson(value);
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: msg);
        setState(() {});
      }
    });
  }
}

enum CallStatus { missed, received, dialed }

class CallLog {
  final String callerName;
  final String callDuration;
  final CallStatus callStatus;
  final String? message;

  CallLog(
      {required this.callerName,
      required this.callDuration,
      required this.callStatus,
      this.message});
}
