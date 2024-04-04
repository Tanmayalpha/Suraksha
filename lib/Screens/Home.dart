import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suraksha/Screens/VideoCall/video_call.dart';
import 'package:suraksha/Screens/add_members.dart';
import 'package:suraksha/Screens/auth/profile.dart';
import 'package:suraksha/Screens/call_logs.dart';
import 'package:suraksha/Screens/notification_view.dart';
import 'package:suraksha/Screens/pay_to_admin.dart';
import 'package:suraksha/Screens/qr_code.dart';
import 'package:suraksha/Screens/static_pages/faq.dart';
import 'package:suraksha/Screens/static_pages/privacy_policy.dart';
import 'package:suraksha/Screens/static_pages/terms_condition.dart';
import 'package:suraksha/Screens/subscription/subscription.dart';
import 'package:suraksha/Screens/test/test_payment.dart';
import 'package:suraksha/Screens/wallet.dart';
import 'package:suraksha/Services/api_services/apiConstants.dart';
import 'package:suraksha/Services/api_services/apiStrings.dart';
import 'package:suraksha/model/login_model.dart';
import 'package:suraksha/utils/app_images.dart';
import 'package:suraksha/utils/colors%20.dart';
import 'package:suraksha/utils/extentions.dart';
import 'package:suraksha/widgets/app_btn.dart';
import 'package:suraksha/widgets/drawer.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../model/getSliders_response.dart';
import 'auth/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> images = [
    'https://hd.wallpaperswide.com/thumbs/waterfall_scenery-t2.jpg',
    'https://img.freepik.com/premium-photo/wooden-product-display-podium-middle-nature-scenery-premade-photo-mockup-background_179530-773.jpg?',
    'https://img.freepik.com/free-photo/lone-tree_181624-46361.jpg?w=1380&t=st=1708602082~exp=1708602682~hmac=0791690595500c034ce060b1c9023e65fec43e547242c21b9f030fcab848bb9c',
    'https://img.freepik.com/free-photo/misurina-sunset_181624-34793.jpg?w=1380&t=st=1708602104~exp=1708602704~hmac=f2d52b375bcd6ee3012defab767caab4606a7b001585105550d9c8ee085655cb'
  ];

  bool isButton1Tapped = true;

  bool isButton2Tapped = true;
  String? token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inIt();

    getSliders();

  }

  @override
  Widget build(BuildContext context) {
    final unit = MediaQuery.of(context).size.height / 25;
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          leading: InkWell(
              onTap: () {
                if (scaffoldKey.currentState!.isDrawerOpen) {
                  scaffoldKey.currentState!.closeDrawer();
                  //close drawer, if drawer is open
                } else {
                  scaffoldKey.currentState!.openDrawer();
                  //open drawer, if drawer is closed
                }
              },
              child: Image.asset(
                IconsImage.splashLogo,
                scale: 1.5,
                color: CustomColors.primaryColor,
              )),
          // backgroundColor: CustomColors.primaryColor,
          centerTitle: true,
          title: SizedBox(
              width: 150, height: 100, child: Image.asset(Images.homeLogo)),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NotificationScreen(loginResponse: userData),
                    ));
              },
              child: Icon(
                Icons.notifications_active_outlined,
                color: CustomColors.primaryColor,
              ),
            ),
            SizedBox(
              width: 20,
            )
          ]),
      drawer: Drawer(
        child: Container(
          // decoration: BoxDecoration().myBoxDecoration(),
          color: CustomColors.whiteColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        CustomColors.primaryColor,
                        CustomColors.secondaryColor
                      ],
                    ),
                  ),
                  child: Center(
                      child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                            radius: 50,
                            backgroundColor: CustomColors.whiteColor,
                            backgroundImage: NetworkImage(
                              userData?.data?.user?.profile ?? '',
                            )),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                          userData: userData,
                                        ))).then((value) {
                              getProfile();
                            });
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userData?.data?.user?.fullName ?? '',
                                  style: TextStyle(
                                      color: CustomColors.whiteColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                              Text(userData?.data?.user?.email ?? '',
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: CustomColors.whiteColor,
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
                ),
                const Divider(
                  color: CustomColors.primaryColor,
                  thickness: 1,
                ),
                ListTile(
                  onTap: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>  const homeScreen()));
                    Navigator.pop(context);
                  },
                  leading:
                      const Icon(Icons.home, color: CustomColors.primaryColor),
                  title: const Text(
                    "Home",
                    style: TextStyle(
                        color: CustomColors.primaryColor, fontSize: 16),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Wallet(
                                  loginResponse: userData,
                                )));
                  },
                  leading: const Icon(
                    Icons.category_outlined,
                    color: CustomColors.primaryColor,
                  ),
                  title: const Text("My Wallet",
                      style: TextStyle(
                          color: CustomColors.primaryColor, fontSize: 16)),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CallLogsScreen(
                                  id: userData?.data?.user?.suraksha_code,
                                )));
                  },
                  leading: const Icon(
                    Icons.account_box_outlined,
                    color: CustomColors.primaryColor,
                  ),
                  title: const Text("Call log",
                      style: TextStyle(
                          color: CustomColors.primaryColor, fontSize: 16)),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubscriptionScreen(
                                  token: token,planStatus: userData?.data?.user?.planStatus,userData: userData,
                                ))).then((value) {
                      getProfile();
                    });
                  },
                  leading: const Icon(
                    Icons.subscriptions,
                    color: CustomColors.primaryColor,
                  ),
                  title: const Text("My Subscription",
                      style: TextStyle(
                          color: CustomColors.primaryColor, fontSize: 16)),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyQrCode(
                                  loginResponse: userData,
                                ))).then((value) {
                      //getProfile();
                    });
                  },
                  leading: const Icon(
                    Icons.qr_code,
                    color: CustomColors.primaryColor,
                  ),
                  title: const Text("My QR Code",
                      style: TextStyle(
                          color: CustomColors.primaryColor, fontSize: 16)),
                ),
                /*ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PayScreen(userToken: userData?.data?.user?.token,))).then((value) {
                      //getProfile();
                    });
                  },
                  leading: const Icon(
                    Icons.paypal,
                    color: CustomColors.primaryColor,
                  ),
                  title: const Text("Pay to Admin",
                      style: TextStyle(
                          color: CustomColors.primaryColor, fontSize: 16)),
                ),*/
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TermsConditionsWidget()));
                  },
                  leading: const Icon(
                    Icons.privacy_tip_outlined,
                    color: CustomColors.primaryColor,
                  ),
                  title: const Text("Terms & Condition",
                      style: TextStyle(
                          color: CustomColors.primaryColor, fontSize: 16)),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FaqPage()));
                  },
                  leading: const Icon(
                    Icons.question_mark_outlined,
                    color: CustomColors.primaryColor,
                  ),
                  title: const Text("FAQ",
                      style: TextStyle(
                          color: CustomColors.primaryColor, fontSize: 16)),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolicy()));
                  },
                  title: const Text("Privacy Policy",
                      style: TextStyle(
                          color: CustomColors.primaryColor, fontSize: 16)),
                  leading: const Icon(
                    Icons.privacy_tip_rounded,
                    color: CustomColors.primaryColor,
                  ),
                ),
                ListTile(
                  onTap: () {
                    showConfirmDeleteDialog(context);
                  },
                  leading: const Icon(
                    Icons.delete_outline,
                    color: CustomColors.primaryColor,
                  ),
                  title: const Text("Delete Account",
                      style: TextStyle(
                          color: CustomColors.primaryColor, fontSize: 16)),
                ),
                ListTile(
                  onTap: () {
                    showConfirmLogOutDialog(context);
                  },
                  leading: const Icon(
                    Icons.logout,
                    color: CustomColors.primaryColor,
                  ),
                  title: const Text("Logout",
                      style: TextStyle(
                          color: CustomColors.primaryColor, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: floatingButton(),
      body: userData == null
          ? Center(
              child:
                  CircularProgressIndicator(color: CustomColors.primaryColor),
            )
          : Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      homeCircleWidget('Calls', Icons.phone_callback),
                      homeCircleWidget('Wallet', Icons.wallet),
                      homeCircleWidget('Subscription', Icons.subscriptions)
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      CarouselSlider.builder(
                          //carouselController: controller,
                          itemCount: getSliderResponse?.data?.length ?? 0,
                          itemBuilder: (context, index, realIndex) {
                            final image = getSliderResponse?.data?[index];

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                child: Image.network(
                                  image?.image ?? '',
                                  fit: BoxFit.cover,
                                  width: 1000.0,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset('assets/images/homeLogo.jpg'),
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            viewportFraction: 1,
                            onPageChanged: (index, reason) {
                              _current = index;
                              setState(() {});
                            },
                            height: 200,
                            initialPage: 0,
                            reverse: false,
                            autoPlay: true,
                          )),
                      /*Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: buildIndicator(),
              ),*/
                    ],
                  ),
                  buildIndicator(),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'My Subscription',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      )),
                  Container(
                    decoration: BoxDecoration(
                        color: CustomColors.whiteColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            // unit is some relative part of the canvas width
                            offset: Offset(-unit / 2, -unit / 2),
                            blurRadius: 1.5 * unit,
                          ),
                          BoxShadow(
                            color: CustomColors.grayColor.withOpacity(0.2),
                            offset: Offset(unit / 2, unit / 2),
                            blurRadius: 1.5 * unit,
                          ),
                        ]),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Plan Start',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('yyyy-MM-dd').format(
                                        format.parse(
                                            userData?.data?.user?.plan_starts ??
                                                '2023-10-30 02:47:33')),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                      'Start on ${DateFormat('MMM-dd').format(format.parse(userData?.data?.user?.plan_starts ?? '2024-02-27 02:47:33'))}',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey))
                                ],
                              ),
                              Container(
                                width: 2,
                                height: 80,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Plan Ends',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('yyyy-MM-dd').format(
                                        format.parse(
                                            userData?.data?.user?.plan_ends ??
                                                '2023-10-30 02:47:33')),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                      'Expire on ${DateFormat('MMM-dd').format(format.parse(userData?.data?.user?.plan_ends ?? '2024-03-27 02:47:33'))}',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubscriptionScreen(
                                      token: userData?.data?.user?.token,userData: userData),
                                )).then((value) {
                              getProfile();
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              /*Container(
                          height: 50,
                          width: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                isButton1Tapped
                                    ? CustomColors.primaryColor
                                    : CustomColors.whiteColor,
                                isButton1Tapped
                                    ? CustomColors.secondaryColor
                                    : CustomColors.whiteColor
                              ],
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              isButton1Tapped = true;
                              isButton2Tapped = false;

                              setState(() {});
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              'Subscribe',
                              style: TextStyle(
                                color: isButton1Tapped
                                    ? CustomColors.whiteColor
                                    : CustomColors.primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),*/
                              userData?.data?.user?.planStatus.toString() == '2'
                                  ? Container(
                                      height: 50,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            isButton2Tapped
                                                ? CustomColors.primaryColor
                                                : CustomColors.whiteColor,
                                            isButton2Tapped
                                                ? CustomColors.secondaryColor
                                                : CustomColors.whiteColor
                                          ],
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          // isButton1Tapped = false;
                                          //  isButton2Tapped = true;

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SubscriptionScreen(
                                                        token: userData?.data
                                                            ?.user?.token,userData: userData),
                                              )).then((value) {
                                            getProfile();
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                        ),
                                        child: Text(
                                          'Renew',
                                          style: TextStyle(
                                            color: isButton2Tapped
                                                ? CustomColors.whiteColor
                                                : CustomColors.primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox()
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

  inIt() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    getProfile();
  }

  setLogOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  Future<void> deleteAccount() async {
    apiBaseHelper
        .deleteAPICall(Uri.parse('${baseUrl}user/$token'))
        .then((value) {
      bool status = value['value'];
      String msg = value['message'];

      Fluttertoast.showToast(msg: msg);
      setLogOut();
    });
  }

  showConfirmLogOutDialog(context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Are you sure You want to logout?"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.primaryColor),
                    child: const Text("No",
                        style: TextStyle(color: CustomColors.whiteColor))),
                ElevatedButton(
                    onPressed: () {
                      setLogOut();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primaryColor,
                    ),
                    child: const Text(
                      "Yes",
                      style: TextStyle(color: CustomColors.whiteColor),
                    )),
              ],
            ),
          );
        });
  }

  showConfirmDeleteDialog(context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Are you sure You want to delete account ?"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.primaryColor),
                    child: const Text("No",
                        style: TextStyle(color: CustomColors.whiteColor))),
                ElevatedButton(
                    onPressed: () {
                      deleteAccount();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primaryColor,
                    ),
                    child: const Text(
                      "Yes",
                      style: TextStyle(color: CustomColors.whiteColor),
                    )),
              ],
            ),
          );
        });
  }

  int _current = 0;

  buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        getSliderResponse?.data?.length ?? 0,
        (index) {
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4)),
          );
        },
      ),
    );
  }

  Widget homeCircleWidget(String title, IconData icon) {
    return InkWell(
      onTap: () {
        if (title == 'Subscription') {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubscriptionScreen(token: token,planStatus: userData?.data?.user?.planStatus,userData: userData),
              )).then((value) {
            getProfile();
          });
        } else if (title == 'Calls') {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CallLogsScreen(id: userData?.data?.user?.suraksha_code),
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Wallet(
                        loginResponse: userData,
                      )));
        }
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration().myHomeBoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                icon,
                size: 40,
                color: CustomColors.primaryColor,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget floatingButton() {
    return InkWell(
      onTap: () async{
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMemberScreen(),
            ));
        /*if (!await launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&origin=22.7469038,%2075.8980404&destination=22.7456224,75.8972469'), mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch');
        }*/
       // launch('https://www.google.com/maps/dir/?api=1&origin=22.7469038,%2075.8980404&destination=22.7456224,75.8972469',);

        /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CashFreePaymentMethod(),
            ));*/
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration().myHomeBoxDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add Member'),
            Icon(
              Icons.arrow_forward,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  LoginResponse? userData;

  Future<void> getProfile() async {
    apiBaseHelper.getAPICall(Uri.parse('${baseUrl}user/$token')).then((value) {
      print('${value}');

      bool status = value['status'];
      String msg = value['message'];

      print('${value}');

      if (status) {
        userData = LoginResponse.fromJson(value);
        setState(() {});
      }

      Fluttertoast.showToast(msg: msg);
    });

    setState(() {});
  }

  GetSliderResponse? getSliderResponse;

  Future<void> getSliders() async {
    apiBaseHelper.getAPICall(Uri.parse('${baseUrl}getSliders')).then((value) {
      print('${value}');

      bool status = value['status'];
      String msg = value['message'];

      print('${value}');

      if (status) {
        getSliderResponse = GetSliderResponse.fromJson(value);
        setState(() {});
      }

      Fluttertoast.showToast(msg: msg);
    });

    setState(() {});
  }
}
