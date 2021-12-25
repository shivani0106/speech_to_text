import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speech/sceech/speech_view.dart';
import 'package:flutter_speech/sceech/speech_view_model.dart';
import 'package:provider/provider.dart';

import 'model/app_model.dart';
import 'no_internet_view.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

final GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();
final routeObserver = RouteObserver<PageRoute>();

class AppState extends State<App> /*with WidgetsBindingObserver*/ {
  static BuildContext appContext;
  final _app = AppModel();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  var id;
  StreamSubscription<ConnectivityResult> subscription;

  var isLaunch = true;

  AppState() {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      print("network changed: " + result.toString());

      if (!isLaunch) {
        if (result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile) {
          print("back");
          Navigator.pop(mainNavigatorKey.currentContext);
        } else {
          print("push");
          Navigator.push(
            mainNavigatorKey.currentContext,
            MaterialPageRoute(builder: (context) => NoInternetView()),
          );
        }
      } else {
        print("is firsttime false");
        isLaunch = false;
        if (result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile) {
        } else {
          print("push");
          Navigator.push(
            mainNavigatorKey.currentContext,
            MaterialPageRoute(builder: (context) => NoInternetView()),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    appContext = context;
    return ChangeNotifierProvider<AppModel>.value(
      value: _app,
      child: Consumer<AppModel>(
        builder: (context, value, child) {
          value.isLoading = false;
          if (value.isLoading) {
            return Container(
              color: Theme.of(context).backgroundColor,
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<SpeechViewModel>(
                  create: (_) => SpeechViewModel()),
            ],
            child: MaterialApp(
              builder: (context, child) {
                return MediaQuery(
                  child: child,
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                );
              },
              navigatorKey: mainNavigatorKey,
              navigatorObservers: [routeObserver],
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  visualDensity: VisualDensity.adaptivePlatformDensity),
              home: SpeechScreen(),
            ),
          );
        },
      ),
    );
  }
}
