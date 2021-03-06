import 'package:my_idena/pages/myIdena_home.dart';
import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:my_idena/backoffice/factory/httpService.dart';
import 'package:my_idena/backoffice/factory/validation,_session_infos.dart';
import 'package:my_idena/main.dart';
import 'package:my_idena/pages/screens/home_screen.dart';
import 'package:my_idena/pages/screens/validation_session_screen.dart';
import 'package:my_idena/utils/app_localizations.dart';
import 'package:my_idena/utils/epoch_period.dart' as EpochPeriod;
import 'package:my_idena/utils/answer_type.dart' as AnswerType;
import 'package:my_idena/utils/relevance_type.dart' as RelevantType;
import 'package:my_idena/myIdena_app/myIdena_app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

HttpService httpService = HttpService();
ValidationSessionInfo validationSessionInfo;
int nbFlips;
List selectionFlipList = new List();
List relevantFlipList = new List();
List<Widget> iconList = new List();
int controllerChronoValue;
// 0 = no selection, 1 = selected, 2 = relevant, 3 = relevant,
List<int> selectedIconList = new List();

class ValidationListView extends StatefulWidget {
  const ValidationListView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;

  @override
  _ValidationListViewState createState() => _ValidationListViewState();
}

class _ValidationListViewState extends State<ValidationListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  AnimationController controllerChrono;

  String get timerString {
    Duration duration = controllerChrono.duration * controllerChrono.value;
    return '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  int index = 0;

  SharedPreferences sharedPreferences;
  bool simulationMode;

  void getSimulationMode() async {
    simulationMode = true;
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      if (sharedPreferences.getBool("simulation_mode") != null) {
        simulationMode = sharedPreferences.getBool("simulation_mode");
      }
    });
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    super.initState();

    getSimulationMode();

    if (simulationMode) {
      dnaAll.dnaGetEpochResponse.result.currentPeriod = typeLaunchSession;
    }

    // Init choice
    if (dnaAll.dnaGetEpochResponse.result.currentPeriod ==
        EpochPeriod.ShortSession) {
      nbFlips = 5;
      checkFlipsQualityProcess = false;
      controllerChrono = AnimationController(
          vsync: this,
          duration: Duration(
              seconds: dnaAll
                  .dnaCeremonyIntervalsResponse.result.shortSessionDuration));
    }
    if (dnaAll.dnaGetEpochResponse.result.currentPeriod ==
        EpochPeriod.LongSession) {
      nbFlips = 18;
      if (checkFlipsQualityProcess == false) {
        controllerChrono = AnimationController(
            vsync: this,
            duration: Duration(
                seconds: dnaAll
                    .dnaCeremonyIntervalsResponse.result.longSessionDuration));
      } else {
        controllerChrono = AnimationController(
            vsync: this, duration: Duration(seconds: controllerChronoValue));
      }
    }

    if (checkFlipsQualityProcess == false) {
      selectionFlipList = new List();
      for (int i = 0; i < nbFlips; i++) {
        selectionFlipList.add(AnswerType.NONE);
        selectedIconList.add(0);
      }
    } else {
      for (int i = 0; i < nbFlips; i++) {
        relevantFlipList.add(RelevantType.RELEVANT);
        selectedIconList.add(0);
      }
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    controllerChrono.dispose();

    validationSessionInfo = null;
    selectionFlipList = new List();
    relevantFlipList = new List();
    iconList = new List();
    selectedIconList = new List();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getValidationSessionInfo(
            dnaAll.dnaGetEpochResponse.result.currentPeriod,
            validationSessionInfo),
        builder: (BuildContext context,
            AsyncSnapshot<ValidationSessionInfo> snapshot) {
          if (snapshot.hasData) {
            validationSessionInfo = snapshot.data;
            if (validationSessionInfo == null) {
              return Text("");
            } else {
              if (validationSessionInfo.listSessionValidationFlip == null) {
                return Text("");
              } else {
                List<ValidationSessionInfoFlips> listSessionValidationFlip =
                    validationSessionInfo.listSessionValidationFlip;

                return AnimatedBuilder(
                    animation: widget.mainScreenAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Container(
                        width: MediaQuery.of(context).size.width - 25,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      FadeTransition(
                                        opacity: widget.mainScreenAnimation,
                                        child: Transform(
                                            transform: Matrix4.translationValues(
                                                0.0,
                                                30 *
                                                    (1.0 -
                                                        widget
                                                            .mainScreenAnimation
                                                            .value),
                                                0.0),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  300,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30,
                                              child: ListView.builder(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0,
                                                          bottom: 0,
                                                          right: 16,
                                                          left: 16),
                                                  itemCount:
                                                      selectionFlipList.length,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final int count =
                                                        selectionFlipList
                                                                    .length >
                                                                25
                                                            ? 30
                                                            : selectionFlipList
                                                                .length;
                                                    final Animation<
                                                        double> animation = Tween<
                                                                double>(
                                                            begin: 0.0,
                                                            end: 1.0)
                                                        .animate(CurvedAnimation(
                                                            parent:
                                                                animationController,
                                                            curve: Interval(
                                                                (1 / count) *
                                                                    index,
                                                                1.0,
                                                                curve: Curves
                                                                    .fastOutSlowIn)));
                                                    animationController
                                                        .forward();
                                                    return AnimatedBuilder(
                                                        animation:
                                                            animationController,
                                                        builder: (BuildContext
                                                                context,
                                                            Widget child) {
                                                          return FadeTransition(
                                                              opacity:
                                                                  animation,
                                                              child: Transform(
                                                                transform: Matrix4
                                                                    .translationValues(
                                                                        100 *
                                                                            (1.0 -
                                                                                animation.value),
                                                                        0.0,
                                                                        0.0),
                                                                child: SizedBox(
                                                                  width: 400,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            height:
                                                                                ((MediaQuery.of(context).size.height - 340)).toDouble(),
                                                                            decoration: selectionFlipList[index] == AnswerType.LEFT
                                                                                ? new BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0), border: new Border.all(color: Colors.green, width: 5))
                                                                                : new BoxDecoration(border: new Border.all(color: Color.fromRGBO(255, 255, 255, 0), width: 5)),
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  selectedIconList[index] = 1;
                                                                                  selectionFlipList[index] = AnswerType.LEFT;
                                                                                });
                                                                              },
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Image(image: ResizeImage(MemoryImage(listSessionValidationFlip[index].listImagesLeft[0]), height: ((MediaQuery.of(context).size.height - 350) ~/ 4).toInt())),
                                                                                  Image(image: ResizeImage(MemoryImage(listSessionValidationFlip[index].listImagesLeft[1]), height: ((MediaQuery.of(context).size.height - 350) ~/ 4).toInt())),
                                                                                  Image(image: ResizeImage(MemoryImage(listSessionValidationFlip[index].listImagesLeft[2]), height: ((MediaQuery.of(context).size.height - 350) ~/ 4).toInt())),
                                                                                  Image(image: ResizeImage(MemoryImage(listSessionValidationFlip[index].listImagesLeft[3]), height: ((MediaQuery.of(context).size.height - 350) ~/ 4).toInt())),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                ((MediaQuery.of(context).size.height - 340)).toDouble(),
                                                                            decoration: selectionFlipList[index] == AnswerType.RIGHT
                                                                                ? new BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10.0), border: new Border.all(color: Colors.green, width: 5))
                                                                                : new BoxDecoration(border: new Border.all(color: Color.fromRGBO(255, 255, 255, 0), width: 5)),
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  selectedIconList[index] = 1;
                                                                                  selectionFlipList[index] = AnswerType.RIGHT;
                                                                                });
                                                                              },
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Image(image: ResizeImage(MemoryImage(listSessionValidationFlip[index].listImagesRight[0]), height: ((MediaQuery.of(context).size.height - 350) ~/ 4).toInt())),
                                                                                  Image(image: ResizeImage(MemoryImage(listSessionValidationFlip[index].listImagesRight[1]), height: ((MediaQuery.of(context).size.height - 350) ~/ 4).toInt())),
                                                                                  Image(image: ResizeImage(MemoryImage(listSessionValidationFlip[index].listImagesRight[2]), height: ((MediaQuery.of(context).size.height - 350) ~/ 4).toInt())),
                                                                                  Image(image: ResizeImage(MemoryImage(listSessionValidationFlip[index].listImagesRight[3]), height: ((MediaQuery.of(context).size.height - 350) ~/ 4).toInt())),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      getWords(
                                                                          listSessionValidationFlip[
                                                                              index],
                                                                          index),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            bottom:
                                                                                15),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              4,
                                                                          width:
                                                                              MediaQuery.of(context).size.width - 80,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                HexColor('#000000').withOpacity(0.2),
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(4.0)),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width - 80,
                                                                                height: 4,
                                                                                decoration: BoxDecoration(
                                                                                  gradient: LinearGradient(colors: [
                                                                                    HexColor('#000000').withOpacity(0.1),
                                                                                    HexColor('#000000'),
                                                                                  ]),
                                                                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ));
                                                        });
                                                  }),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                getThumbnails(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Container(child: getChrono()),
                                    Container(
                                        child:
                                            getStartCheckingKeywordsButton()),
                                    Container(
                                        child: validationShortSessionButton()),
                                    Container(
                                        child: validationLongSessionButton()),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              }
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget getWords(
      ValidationSessionInfoFlips validationSessionInfoFlips, int index) {
    if (dnaAll.dnaGetEpochResponse.result.currentPeriod ==
            EpochPeriod.LongSession &&
        checkFlipsQualityProcess) {
      String word1Name = "";
      String word2Name = "";
      String word1Desc = "";
      String word2Desc = "";

      if (validationSessionInfoFlips.listWords != null) {
        word1Name = validationSessionInfoFlips.listWords[0] != null
            ? validationSessionInfoFlips.listWords[0].name
            : "";
        word2Name = validationSessionInfoFlips.listWords[1] != null
            ? validationSessionInfoFlips.listWords[1].name
            : "";
        word1Desc = validationSessionInfoFlips.listWords[0] != null
            ? validationSessionInfoFlips.listWords[0].desc
            : "";
        word2Desc = validationSessionInfoFlips.listWords[1] != null
            ? validationSessionInfoFlips.listWords[1].desc
            : "";
      }
      return LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)
                        .translate("Are both keywords relevant to the flip ?"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    word1Name == ""
                        ? AppLocalizations.of(context)
                            .translate("No keywords available")
                        : word1Name,
                    style: TextStyle(
                        fontFamily: MyIdenaAppTheme.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: -0.1,
                        color: MyIdenaAppTheme.darkText),
                  ),
                  Text(
                    word1Desc == "" ? "" : word1Desc,
                    style: TextStyle(
                        fontFamily: MyIdenaAppTheme.fontName,
                        fontSize: 14,
                        letterSpacing: -0.1,
                        color: MyIdenaAppTheme.darkText),
                  ),
                  SizedBox(width: 1, height: 10),
                  Text(
                    word2Name == ""
                        ? AppLocalizations.of(context)
                            .translate("No keywords available")
                        : word2Name,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        fontFamily: MyIdenaAppTheme.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: -0.1,
                        color: MyIdenaAppTheme.darkText),
                  ),
                  Text(
                    word2Desc == "" ? "" : word2Desc,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        fontFamily: MyIdenaAppTheme.fontName,
                        fontSize: 14,
                        letterSpacing: -0.1,
                        color: MyIdenaAppTheme.darkText),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          elevation: 5.0,
                          onPressed: () {
                            setState(() {
                              relevantFlipList[index] = RelevantType.RELEVANT;
                              selectedIconList[index] = 2;
                            });
                          },
                          padding: EdgeInsets.all(5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: selectedIconList[index] == 2
                              ? Colors.blue
                              : Colors.white,
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate("Both relevant"),
                              style: TextStyle(
                                color: selectedIconList[index] == 2
                                    ? Colors.white
                                    : Colors.blue,
                                letterSpacing: 1.5,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: MyIdenaAppTheme.fontName,
                              )),
                        ),
                        SizedBox(
                          width: 30,
                          height: 1,
                        ),
                        RaisedButton(
                          elevation: 5.0,
                          onPressed: () {
                            setState(() {
                              relevantFlipList[index] = RelevantType.IRRELEVANT;
                              selectedIconList[index] = 3;
                            });
                          },
                          padding: EdgeInsets.all(5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: selectedIconList[index] == 3
                              ? Colors.red
                              : Colors.white,
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate("Irrelevant"),
                              style: TextStyle(
                                color: selectedIconList[index] == 3
                                    ? Colors.white
                                    : Colors.red,
                                letterSpacing: 1.5,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: MyIdenaAppTheme.fontName,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
    } else {
      return SizedBox();
    }
  }

  Widget getThumbnails() {
    iconList.clear();
    if (selectedIconList == null || selectedIconList.length == 0) {
      return Column(
        children: iconList,
      );
    }
    for (int i = 0; i < nbFlips; i++) {
      Widget text;
      Widget icon;
      switch (selectedIconList[i]) {
        case 1:
          {
            icon = Icon(
              FlevaIcons.checkmark_square_2_outline,
              color: Colors.green,
              size: 22,
            );
            break;
          }
        case 2:
          {
            icon = Icon(
              FlevaIcons.checkmark_square,
              color: Colors.blue,
              size: 22,
            );
            break;
          }
        case 3:
          {
            icon = Icon(
              FlevaIcons.close_square_outline,
              color: Colors.red,
              size: 22,
            );
            break;
          }
        default:
          {
            icon = Icon(
              FlevaIcons.copy_outline,
              color: Colors.grey[500],
              size: 22,
            );
            break;
          }
      }
      iconList.add(icon);
    }

    return Column(
      children: iconList,
    );
  }

  Widget getStartCheckingKeywordsButton() {
    if (dnaAll.dnaGetEpochResponse.result.currentPeriod ==
            EpochPeriod.LongSession &&
        checkFlipsQualityProcess == false) {
      for (int i = 0; i < selectionFlipList.length; i++) {
        if (selectionFlipList[i] == AnswerType.NONE) {
          return SizedBox();
        }
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            elevation: 5.0,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                        contentPadding: EdgeInsets.zero,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).translate(
                                      "Your answers are not yet submitted"),
                                  style: TextStyle(
                                      fontFamily: MyIdenaAppTheme.fontName,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: -0.1,
                                      color: MyIdenaAppTheme.darkText),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  AppLocalizations.of(context).translate(
                                      "Please qualify the keywords relevance and submit the answers."),
                                  style: TextStyle(
                                      fontFamily: MyIdenaAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      letterSpacing: -0.1,
                                      color: MyIdenaAppTheme.darkText),
                                ),
                                Text(
                                  AppLocalizations.of(context).translate(
                                      "The flips with relevant keywords will be penalized"),
                                  style: TextStyle(
                                      fontFamily: MyIdenaAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      letterSpacing: -0.1,
                                      color: MyIdenaAppTheme.darkText),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                RaisedButton(
                                  elevation: 5.0,
                                  onPressed: () {
                                    checkFlipsQualityProcess = true;
                                    Duration durationChrono =
                                        controllerChrono.duration *
                                            controllerChrono.value;
                                    controllerChronoValue =
                                        durationChrono.inSeconds;
                                    Navigator.push<dynamic>(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context) =>
                                              ValidationSessionScreen(
                                                  animationController:
                                                      animationController),
                                        ));
                                  },
                                  padding: EdgeInsets.all(5.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  color: Colors.white,
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .translate("Ok, I understand"),
                                      style: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: 1.5,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: MyIdenaAppTheme.fontName,
                                      )),
                                ),
                              ],
                            ),
                          )
                        ],
                      ));
            },
            padding: EdgeInsets.all(5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.white,
            child: Text(
                AppLocalizations.of(context)
                    .translate("Start checking keywords"),
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1.5,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: MyIdenaAppTheme.fontName,
                )),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  Widget validationShortSessionButton() {
    if (dnaAll.dnaGetEpochResponse.result.currentPeriod ==
        EpochPeriod.ShortSession) {
      for (int i = 0; i < selectionFlipList.length; i++) {
        if (selectionFlipList[i] == AnswerType.NONE) {
          return SizedBox();
        }
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            elevation: 5.0,
            onPressed: () {
              //submitShortAnswers(selectionFlipList, validationSessionInfo);
              typeLaunchSession = EpochPeriod.LongSession;
              validationSessionInfo = null;
              checkFlipsQualityProcess = false;
              selectedIconList.clear();
              Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => ValidationSessionScreen(
                        animationController: animationController),
                  ));
            },
            padding: EdgeInsets.all(5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.white,
            child:
                Text(AppLocalizations.of(context).translate("Submit answers"),
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.5,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: MyIdenaAppTheme.fontName,
                    )),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  Widget validationLongSessionButton() {
    if (dnaAll.dnaGetEpochResponse.result.currentPeriod ==
            EpochPeriod.LongSession &&
        checkFlipsQualityProcess) {
      for (int i = 0; i < selectionFlipList.length; i++) {
        if (selectedIconList[i] == 0 || selectedIconList[i] == 1) {
          return SizedBox();
        }
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            elevation: 5.0,
            onPressed: () {
              checkFlipsQualityProcess = false;
              //submitLongAnswers(
              //    selectionFlipList, relevantFlipList, validationSessionInfo);
              typeLaunchSession = EpochPeriod.ShortSession;
              validationSessionInfo = null;
              selectedIconList.clear();
              showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                        contentPadding: EdgeInsets.zero,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).translate(
                                      "Your answers for the validation session have been submitted successfully!"),
                                  style: TextStyle(
                                      fontFamily: MyIdenaAppTheme.fontName,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: -0.1,
                                      color: MyIdenaAppTheme.darkText),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                RaisedButton(
                                  elevation: 5.0,
                                  onPressed: () {
                                    typeLaunchSession =
                                        EpochPeriod.ShortSession;
                                    validationSessionInfo = null;
                                    checkFlipsQualityProcess = false;
                                    selectedIconList.clear();

                                    Navigator.push<dynamic>(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                            builder: (BuildContext context) =>
                                                Home()));
                                  },
                                  padding: EdgeInsets.all(5.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  color: Colors.white,
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .translate("Go to home"),
                                      style: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: 1.5,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: MyIdenaAppTheme.fontName,
                                      )),
                                ),
                              ],
                            ),
                          )
                        ],
                      ));
            },
            padding: EdgeInsets.all(5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.white,
            child:
                Text(AppLocalizations.of(context).translate("Submit answers"),
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.5,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: MyIdenaAppTheme.fontName,
                    )),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  Widget getChrono() {
    controllerChrono.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        if (dnaAll.dnaGetEpochResponse.result.currentPeriod ==
            EpochPeriod.ShortSession) {
          //submitShortAnswers(selectionFlipList, validationSessionInfo);
          typeLaunchSession = EpochPeriod.LongSession;
          validationSessionInfo = null;
          checkFlipsQualityProcess = false;
          Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => ValidationSessionScreen(
                    animationController: animationController),
              ));
        }
        if (dnaAll.dnaGetEpochResponse.result.currentPeriod ==
            EpochPeriod.LongSession) {
          //submitLongAnswers(selectionFlipList, validationSessionInfo);
          typeLaunchSession = EpochPeriod.ShortSession;
          validationSessionInfo = null;
          checkFlipsQualityProcess = false;
          Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) =>
                    HomeScreen(animationController: animationController),
              ));
        }
      }
    });
    controllerChrono.reverse(
        from: controllerChrono.value == 0.0 ? 1.0 : controllerChrono.value);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.access_time, color: Colors.red),
        AnimatedBuilder(
            animation: controllerChrono,
            builder: (BuildContext context, Widget child) {
              return Text(
                timerString,
                style: TextStyle(
                  fontFamily: MyIdenaAppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: -0.1,
                  color: Colors.red,
                ),
              );
            }),
      ],
    );
  }
}
