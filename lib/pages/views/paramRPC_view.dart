import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_idena/main.dart';
import 'package:my_idena/myIdena_app/myIdena_app_theme.dart';
import 'package:my_idena/pages/myIdena_home.dart';
import 'package:my_idena/utils/app_localizations.dart';
import 'package:my_idena/utils/sharedPreferencesHelper.dart';

class ParamRPCView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  const ParamRPCView({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _ParamRPCViewState createState() => _ParamRPCViewState();
}

class _ParamRPCViewState extends State<ParamRPCView> {
  final _keyFormParamRPC = GlobalKey<FormState>();
  String apiUrl;
  String keyApp;
  bool _keyAppVisible;

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
            return AnimatedBuilder(
                animation: widget.animationController,
                builder: (BuildContext context, Widget child) {
                  return FadeTransition(
                    opacity: widget.animation,
                    child: Form(
                      key: _keyFormParamRPC,
                      child: new Transform(
                        transform: new Matrix4.translationValues(
                            0.0, 30 * (1.0 - widget.animation.value), 0.0),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 16, bottom: 18),
                          child: Container(
                            decoration: BoxDecoration(
                              color: MyIdenaAppTheme.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                  topRight: Radius.circular(68.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color:
                                        MyIdenaAppTheme.grey.withOpacity(0.2),
                                    offset: Offset(1.1, 1.1),
                                    blurRadius: 10.0),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24, right: 24, top: 8, bottom: 16),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 6),
                                              child: TextFormField(
                                                controller: initialValue(
                                                    snapshot.data.apiUrl == null
                                                        ? ''
                                                        : snapshot.data.apiUrl),
                                                validator: (val) => val.isEmpty
                                                    ? AppLocalizations.of(
                                                            context)
                                                        .translate(
                                                            "Enter your API url")
                                                    : null,
                                                onChanged: (val) =>
                                                    apiUrl = val,
                                                keyboardType:
                                                    TextInputType.text,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily:
                                                      MyIdenaAppTheme.fontName,
                                                ),
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey[400],
                                                        width: 1.0),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xFFF2F3F8),
                                                        width: 1.0),
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          top: 14.0),
                                                  prefixIcon: Icon(
                                                    FlevaIcons.link_2,
                                                    color: Colors.black54,
                                                  ),
                                                  hintText: AppLocalizations.of(
                                                          context)
                                                      .translate(
                                                          "Enter your API url"),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 6),
                                              child: TextFormField(
                                                controller: initialValue(
                                                    snapshot.data.keyApp == null
                                                        ? ''
                                                        : snapshot.data.keyApp),
                                                validator: (val) => val.isEmpty
                                                    ? AppLocalizations.of(
                                                            context)
                                                        .translate(
                                                            "Enter your key app")
                                                    : null,
                                                onChanged: (val) =>
                                                    keyApp = val,
                                                keyboardType:
                                                    TextInputType.text,
                                                obscureText: !_keyAppVisible,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily:
                                                      MyIdenaAppTheme.fontName,
                                                ),
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey[400],
                                                        width: 1.0),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xFFF2F3F8),
                                                        width: 1.0),
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          top: 14.0),
                                                  prefixIcon: Icon(
                                                    Icons.vpn_key,
                                                    color: Colors.black54,
                                                  ),
                                                  hintText: AppLocalizations.of(
                                                          context)
                                                      .translate(
                                                          "Enter your key app"),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _keyAppVisible
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                      color: Theme.of(context)
                                                          .primaryColorDark,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _keyAppVisible =
                                                            !_keyAppVisible;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 6),
                                              child: RaisedButton(
                                                elevation: 5.0,
                                                onPressed: () async {
                                                  if (_keyFormParamRPC
                                                      .currentState
                                                      .validate()) {
                                                    try {
                                                      await SharedPreferencesHelper
                                                          .setIdenaSharedPreferences(
                                                              IdenaSharedPreferences(
                                                                  apiUrl,
                                                                  keyApp
                                                                  ));
                                                    } catch (e) {
                                                      logger.e(e.toString());
                                                    }
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (context) =>
                                                                SimpleDialog(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            AppLocalizations.of(context).translate("Parameters have been saved"),
                                                                            style: TextStyle(
                                                                                fontFamily: MyIdenaAppTheme.fontName,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 16,
                                                                                letterSpacing: -0.1,
                                                                                color: MyIdenaAppTheme.darkText),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ));
                                                    setState(() {});
                                                  }
                                                },
                                                padding: EdgeInsets.all(15.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                                color: Colors.white,
                                                child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate("Save"),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      letterSpacing: 1.5,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          MyIdenaAppTheme
                                                              .fontName,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
        });
  }

  initialValue(val) {
    return TextEditingController(text: val);
  }
}
