import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify_io.dart';

import 'package:tempo_dingo/src/models/user_model.dart';
import 'package:tempo_dingo/src/resources/spotify_repository.dart';
import 'package:tempo_dingo/src/tab_view.dart';
import 'package:tempo_dingo/src/screens/log_in.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/widgets/loading_screen.dart';

SpotifyRepository spotifyRepository = SpotifyRepository();

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

class _CheckLogIn extends StatefulWidget {
  @override
  __CheckLogInState createState() => __CheckLogInState();
}

class __CheckLogInState extends State<_CheckLogIn> {
  String _email;
  String _password;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _email = prefs.getString('email');
        _password = prefs.getString('password');
      });
    });
    super.initState();
  }

  void _resetData() {
    _email = null;
    _password = null;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      print("Build scoped model");
      if (model.isSigningOut) _resetData();
      if ((_email == null || _password == null) && !model.isConnected)
        return LogIn();
      return model.isConnected
          ? _tabsFutureBuilders()
          : FutureBuilder(
              future: model.login(_email, _password, false),
              builder: (context, snapshot) => Center(child: loadingWhite));
    });
  }

  Widget _tabsFutureBuilders() {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return FutureBuilder<List<Track>>(
          future: spotifyRepository.getTrackList(model.songs),
          builder: (context, tracks) {
            switch (tracks.connectionState) {
              case ConnectionState.waiting:
                return LoadingScreen("Loading tracks...");
              default:
                if (tracks.hasError) return Container();
                return FutureBuilder<List<Artist>>(
                  future: spotifyRepository.getArtistsList(model.artists),
                  builder: (context, artists) {
                    switch (artists.connectionState) {
                      case ConnectionState.waiting:
                        return LoadingScreen("Loading artists...");
                      default:
                        if (artists.hasError) return Container();
                        return FutureBuilder<List<Track>>(
                          future:
                              spotifyRepository.getTrackList(model.favorite),
                          builder: (context, favorite) {
                            switch (favorite.connectionState) {
                              case ConnectionState.waiting:
                                return LoadingScreen("Loading favorite...");
                              default:
                                if (favorite.hasError) return Container();
                                return TabView(
                                  tracks.data,
                                  artists.data,
                                  favorite.data,
                                );
                            }
                          },
                        );
                    }
                  },
                );
            }
          },
        );
      },
    );
  }
}
