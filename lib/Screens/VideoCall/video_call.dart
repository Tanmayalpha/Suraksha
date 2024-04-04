import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:suraksha/Services/api_services/apiConstants.dart';
import 'package:suraksha/utils/colors%20.dart';
import 'package:suraksha/widgets/app_bar.dart';

//String appId = "a0017ef44c754838bc6747388dd2aadf";
String appId = "";
const token = "a0017ef44c754838bc6747388dd2aadf";


class VideoCall extends StatefulWidget {
   String? channel ;
   String? callId ;

   VideoCall({Key? key,this.channel,this.callId}) : super(key: key);

  @override
  State<VideoCall> createState() => _MyVideoCallState();
}

class _MyVideoCallState extends State<VideoCall> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;



  @override
  void initState() {
    super.initState();
    // widget.channel = 'eb2ac3b624' ;
    initAgora();
    updateCall();

  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();
print('_____________${appId}____________${widget.channel}');
    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize( RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));


    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
          _engine.enableLocalVideo(false);
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          Navigator.pop(context);
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: widget.channel ?? '',
      uid: 0,
      options: const ChannelMediaOptions(),

    );
  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }
  Future<void> muteLocalVideoStream(bool mute) async {

  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: CustomColors.primaryColor,
          elevation: 5,shadowColor: CustomColors.secondaryColor,
          leading: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios,color: CustomColors.whiteColor,)),
          centerTitle: true,
          title: Text(
            'Video call',
            style: TextStyle(fontSize: 20,color: CustomColors.whiteColor),
          ),
          actions: [
        SizedBox(width: 20,),
        RawMaterialButton(
          onPressed: _onVideoOnOff,
          child: Icon(
            offCamera ?   Icons.videocam : Icons.videocam_off ,
            color: CustomColors.secondaryColor,
            size: 20.0,
          ),
          shape: CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.white,
          padding: const EdgeInsets.all(12.0),
        )
      ]),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 100,
                height: 150,
                child: Center(
                  child: _localUserJoined
                      ? AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          _toolbar(),

        ],
      ),
    );
  }


  Widget _toolbar() {

    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),

        ],
      ),
    );
  }
  bool muted = false;
  bool offCamera = false;

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection:  RtcConnection(channelId: widget.channel ?? ''),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  void _onCallEnd(BuildContext context) {
    endCall();
    Navigator.pop(context);
  }
  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onVideoOnOff() {

    setState(() {
      offCamera = !offCamera ;
    });
    _engine.enableLocalVideo(offCamera);

  }



  updateCall() async{
    apiBaseHelper.getAPICall(Uri.parse('${baseUrl}updateCallStatus/${widget.callId}')).then((value) {

    });
  }
  endCall() async{
    apiBaseHelper.getAPICall(Uri.parse('${baseUrl}endCallStatus/${widget.callId}')).then((value) {

    }); }
}