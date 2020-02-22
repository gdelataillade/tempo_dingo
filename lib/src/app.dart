import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tempo_dingo/src/tab_view.dart';
import 'package:tempo_dingo/src/screens/log_in.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';

import 'models/user_model.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tempo Dingo',
      debugShowCheckedModeBanner: false,
      theme: themeConfig,
      home: Scaffold(
        backgroundColor: mainTheme,
        body: ScopedModel<UserModel>(
          model: UserModel(),
          child: _CheckLogIn(),
        ),
      ),
    );
  }
}

class _CheckLogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return FutureBuilder(
            future: model.initSharedPrefs(),
            builder: (context, snapshotPrefs) {
              switch (snapshotPrefs.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: loadingMainTheme);
                default:
                  if (snapshotPrefs.hasError) return Container();
                  return FutureBuilder(
                      future: model.login(
                        model.prefs.getString('email'),
                        model.prefs.getString('password'),
                        true,
                      ),
                      initialData: false,
                      builder: (context, snapshotLogin) {
                        switch (snapshotLogin.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: loadingWhite);
                          default:
                            if (snapshotLogin.hasError) return Container();
                            print(snapshotLogin.data);
                            return snapshotLogin.data == true
                                ? TabView()
                                : LogIn();
                        }
                      });
              }
            });
      },
    );
  }
}
