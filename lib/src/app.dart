import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart';

import 'package:tempo_dingo/src/models/user_model.dart';
import 'package:tempo_dingo/src/screens/intro.dart';
import 'package:tempo_dingo/src/tab_view.dart';
import 'package:tempo_dingo/src/config/theme_config.dart';
import 'package:tempo_dingo/src/widgets/loading_screen.dart';

class MyApp extends StatelessWidget {
  Future<SpotifyApiCredentials> _getSpotifyCredentials() async {
    print("Init spotify credentials");
    final String _clientId = "f3ac271ff9d540b3a69f9e4b58c2d0d5";
    final QuerySnapshot _snapshot =
        await Firestore.instance.collection("config").getDocuments();
    return SpotifyApiCredentials(_clientId, _snapshot.documents.first["key"]);
  }

  @override
  Widget build(BuildContext context) {
    // Dismiss keyboard when hot reload (debug)
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return MaterialApp(
      title: 'Tempo Dingo',
      debugShowCheckedModeBanner: false,
      theme: themeConfig,
      color: mainTheme,
      home: Scaffold(
        backgroundColor: mainTheme,
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<SpotifyApiCredentials>(
            future: _getSpotifyCredentials(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: loadingWhite);
                default:
                  return ScopedModel<UserModel>(
                    model: UserModel(snapshot.data),
                    child: _CheckLogIn(),
                  );
              }
            }),
      ),
    );
  }
}

class _CheckLogIn extends StatefulWidget {
  @override
  __CheckLogInState createState() => __CheckLogInState();
}

class __CheckLogInState extends State<_CheckLogIn> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      print("Build scoped model");
      return FutureBuilder<void>(
        future: model.getSharedPrefs(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: loadingWhite);
            default:
              return model.showIntro ? Intro() : _tabsFutureBuilders();
          }
        },
      );
    });
  }

  Widget _tabsFutureBuilders() {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return FutureBuilder<List<Track>>(
          future: model.spotifyRepository.getTrackList(model.songs),
          builder: (context, tracks) {
            switch (tracks.connectionState) {
              case ConnectionState.waiting:
                return LoadingScreen(model.intl('loading_tracks'));
              default:
                if (tracks.hasError) return _Error();
                return FutureBuilder<List<Artist>>(
                  future: model.spotifyRepository.getArtistsList(model.artists),
                  builder: (context, artists) {
                    switch (artists.connectionState) {
                      case ConnectionState.waiting:
                        return LoadingScreen(model.intl('loading_artists'));
                      default:
                        if (artists.hasError) return _Error();
                        return FutureBuilder<List<Track>>(
                          future: model.spotifyRepository
                              .getTrackList(model.history),
                          builder: (context, history) {
                            switch (history.connectionState) {
                              case ConnectionState.waiting:
                                return LoadingScreen(
                                    model.intl('loading_history'));
                              default:
                                if (history.hasError) return _Error();
                                return TabView(
                                  tracks.data,
                                  artists.data,
                                  history.data,
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

class _Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(model.intl('network_error'),
                  style: Theme.of(context).textTheme.body1),
              const SizedBox(height: 100),
              IconButton(
                icon: Icon(
                  FeatherIcons.refreshCcw,
                  color: Colors.white,
                ),
                onPressed: () => model.reloadPage(),
              ),
            ],
          ),
        );
      },
    );
  }
}
