import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_idena/backoffice/factory/connectivity_service.dart';
import 'package:my_idena/backoffice/factory/httpService.dart';
import 'package:my_idena/main.dart';
import 'package:my_idena/myIdena_app/myIdena_app_theme.dart';
import 'package:my_idena/pages/myIdena_home.dart';
import 'package:my_idena/utils/app_localizations.dart';
import 'package:my_idena/utils/sharedPreferencesHelper.dart';

HttpService httpService = HttpService();

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  int bottomSelectedIndex = 0;
  final _keyForm = GlobalKey<FormState>();
  bool _keyAppVisible;
  bool _checkNodeConnection;
  TextEditingController apiUrlController = new TextEditingController();
  TextEditingController keyAppController = new TextEditingController();

  @override
  void dispose() {
    pageController.dispose();
    apiUrlController.dispose();
    keyAppController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _keyAppVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<IdenaSharedPreferences>(
        future: SharedPreferencesHelper.getIdenaSharedPreferences(),
        builder: (BuildContext context,
            AsyncSnapshot<IdenaSharedPreferences> snapshot) {
          if (snapshot.hasData == false) {
            return Center(child: CircularProgressIndicator());
          } else {
            apiUrlController.text =
                snapshot.data.apiUrl != null ? snapshot.data.apiUrl : "";
            keyAppController.text =
                snapshot.data.keyApp != null ? snapshot.data.keyApp : "";
            return Form(
              key: _keyForm,
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    bottomSelectedIndex = index;
                  });
                },
                children: <Widget>[
                  _welcome(index: 1),
                  _getPageUrlApi(index: 2, contextStream: context),
                  _getPageKeyApp(index: 3, contextStream: context),
                ],
              ),
            );
          }
        });
  }

  _welcome({int index}) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Image.asset('assets/images/img_idena_intro.png'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context).translate("Welcome !"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontFamily: MyIdenaAppTheme.fontName,
                      letterSpacing: -0.2,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                _getPageIndicator(index, Colors.white54, Colors.white),
                SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context).translate(
                      "my Idena is an application currently under development. You use it at your own risk. \n\nIn any case, the owner of this application can't be held responsible for problems related to use or bugs.\n\n"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.red[400],
                      fontSize: 16,
                      fontFamily: MyIdenaAppTheme.fontName,
                      letterSpacing: -0.2),
                ),
                Text(
                  AppLocalizations.of(context).translate(
                      "In case of bugs, please notify them on the project's Github page (see \"About\" page).\n\nThe Idena core team is not participating in the development of this application"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: MyIdenaAppTheme.fontName,
                      letterSpacing: -0.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getPageUrlApi({int index, BuildContext contextStream}) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Image.asset('assets/images/img_ip.png'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context).translate("Type your\nurl api"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontFamily: MyIdenaAppTheme.fontName,
                      letterSpacing: -0.2,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                _getPageIndicator(index, Colors.white54, Colors.white),
                SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context).translate(
                      "Please, type http://{ip_address}:{port_number}\nto connect to your node"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: MyIdenaAppTheme.fontName,
                      letterSpacing: -0.2),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConnectivityService().getConnectionStatus(contextStream),
                    checkNodeConnection(),
                  ],
                ),
                TextFormField(
                  cursorColor: Colors.white,
                  controller: apiUrlController,
                  validator: (val) => val.isEmpty
                      ? AppLocalizations.of(context)
                          .translate("Enter your API url")
                      : null,
                  onChanged: (val) {
                    try {
                      SharedPreferencesHelper.setIdenaSharedPreferences(
                          IdenaSharedPreferences(apiUrlController.text,
                              keyAppController.text, null));
                    } catch (e) {
                      logger.e(e.toString());
                    }
                  },
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: MyIdenaAppTheme.fontName,
                    letterSpacing: -0.2,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey[400], width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFF2F3F8), width: 1.0),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      FlevaIcons.link_2,
                      color: Colors.white54,
                    ),
                    hintText: AppLocalizations.of(context)
                        .translate("Enter your API url"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getPageKeyApp({int index, BuildContext contextStream}) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/img_key.png'),
                  Text(
                    AppLocalizations.of(context)
                        .translate("Type your\nkey app"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: MyIdenaAppTheme.fontName,
                        letterSpacing: -0.2,
                        fontSize: 35,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _getPageIndicator(index, Colors.white54, Colors.white),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppLocalizations.of(context).translate(
                        "Please, type the api.key (cf \\datadir\\api.key file)"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: MyIdenaAppTheme.fontName,
                        letterSpacing: -0.2),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConnectivityService().getConnectionStatus(contextStream),
                      checkNodeConnection(),
                    ],
                  ),
                  TextFormField(
                    controller: keyAppController,
                    validator: (val) => val.isEmpty
                        ? AppLocalizations.of(context)
                            .translate("Enter your key app")
                        : null,
                    onChanged: (val) {
                      try {
                        SharedPreferencesHelper.setIdenaSharedPreferences(
                            IdenaSharedPreferences(apiUrlController.text,
                                keyAppController.text, null));
                      } catch (e) {
                        logger.e(e.toString());
                      }
                    },
                    keyboardType: TextInputType.text,
                    obscureText: !_keyAppVisible,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: MyIdenaAppTheme.fontName,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[400], width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFF2F3F8), width: 1.0),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 14.0),
                      prefixIcon: Icon(
                        Icons.vpn_key,
                        color: Colors.white54,
                      ),
                      hintText: AppLocalizations.of(context)
                          .translate("Enter your key app"),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _keyAppVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _keyAppVisible = !_keyAppVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  goHome(),
                ],
              ),
            ),
          ),
        ));
  }

  _getPageIndicator(index, Color colorsSelected, Color colorsByDefault) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: index == 1 ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
              color: index == 1 ? colorsByDefault : colorsSelected,
              borderRadius: BorderRadius.circular(10)),
        ),
        SizedBox(
          width: 20,
        ),
        Container(
          width: index == 2 ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
              color: index == 2 ? colorsByDefault : colorsSelected,
              borderRadius: BorderRadius.circular(10)),
        ),
        SizedBox(
          width: 20,
        ),
        Container(
          width: index == 3 ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
              color: index == 3 ? colorsByDefault : colorsSelected,
              borderRadius: BorderRadius.circular(10)),
        ),
      ],
    );
  }

  Widget goHome() {
    if (_checkNodeConnection != null && _checkNodeConnection) {
      return IconButton(
        icon: Icon(FlevaIcons.globe_2_outline),
        color: Colors.green,
        iconSize: 40,
        onPressed: () {
          Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => Home()));
        },
      );
    } else {
      return SizedBox(width: 1, height: 1);
    }
  }

  Widget checkNodeConnection() {
    return FutureBuilder(
        future: httpService.checkConnection(
            apiUrlController.text, keyAppController.text),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            _checkNodeConnection = snapshot.data;
            if (_checkNodeConnection) {
              return Text(
                "Connexion Noeud ok",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontFamily: MyIdenaAppTheme.fontName,
                    letterSpacing: -0.2,
                    fontWeight: FontWeight.w500),
              );
            } else {
              return Text(
                "Connexion Noeud ko",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontFamily: MyIdenaAppTheme.fontName,
                    letterSpacing: -0.2,
                    fontWeight: FontWeight.w500),
              );
            }
          } else {
            _checkNodeConnection = false;
            return Text(
              "Connexion Noeud ko",
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontFamily: MyIdenaAppTheme.fontName,
                  letterSpacing: -0.2,
                  fontWeight: FontWeight.w500),
            );
          }
        });
  }
}
