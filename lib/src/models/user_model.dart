import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempo_dingo/src/config/register_config.dart' as config;
import '../config/language.dart';

class UserModel extends Model {
  int _stars;
  String _language;
  bool vibration = true;
  bool _darkTheme;
  double volume = 10;
  List<String> _tracks;
  List<String> _artists;
  List<String> _favorite;
  List<String> _history;
  int tabViewIndex = 1;
  int libraryTabIndex = 0;
  bool _isGameOver = false;

  int get stars => _stars;
  String get language => _language;
  List<String> get songs => _tracks;
  List<String> get artists => _artists;
  List<String> get favorite => _favorite;
  List<String> get history => _history;
  bool get darkTheme => _darkTheme;
  bool get isGameOver => _isGameOver;

  Future<void> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();

    // Stars prefs
    _stars = prefs.getInt('stars');
    if (_stars == null) {
      _stars = 11;
      prefs.setInt('stars', _stars);
    }

    // Tracks prefs
    _tracks = prefs.getStringList('tracks');
    if (_tracks == null) {
      _tracks = config.library["tracks"];
      prefs.setStringList('tracks', _tracks);
    }

    // Artists prefs
    _artists = prefs.getStringList('artists');
    if (_artists == null) {
      _artists = config.library["artists"];
      prefs.setStringList('artists', _artists);
    }

    // Favorite prefs
    _favorite = prefs.getStringList('favorite');
    if (_favorite == null) {
      _favorite = [];
      prefs.setStringList('favorite', []);
    }

    // History prefs
    _history = prefs.getStringList('history');
    if (_history == null) {
      _history = [];
      prefs.setStringList('history', []);
    }

    // Language prefs
    _language = prefs.getString('language');
    if (_language == null) {
      _language = "en";
      prefs.setString('language', "en");
    }
  }

  void addToHistory(String trackId) {
    if (_history.contains(trackId)) _history.remove(trackId);
    _history.insert(0, trackId);

    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('history', _history);
    });
  }

  bool isPurshased(String trackId) {
    return _tracks.contains(trackId) ? true : false;
  }

  bool isFavorite(String trackId) {
    return _favorite.contains(trackId) ? true : false;
  }

  void likeUnlikeTrack(String trackId) {
    isFavorite(trackId) ? _favorite.remove(trackId) : _favorite.add(trackId);

    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('favorite', _favorite);
    });
  }

  void addOrRemoveStars(int nb) {
    _stars += nb;

    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('stars', _stars);
    });
    notifyListeners();
  }

  void changeLanguage(String newLang) {
    _language = newLang;

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('language', newLang);
    });
    notifyListeners();
  }

  String intl(String key) => lang[key][_language];

  void reloadPage() => notifyListeners();

  List shuffleList(List items) {
    var random = Random();

    for (var i = items.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);
      var temp = items[i];

      items[i] = items[n];
      items[n] = temp;
    }
    return items;
  }

  void gameOver() {
    _isGameOver = true;
    notifyListeners();
  }

  void exitGame() => _isGameOver = false;

  void pushGameStats() async {
    final QuerySnapshot snapshot =
        await Firestore.instance.collection("stats").getDocuments();
    final int nbGames = snapshot.documents.first["nbGames"];

    Firestore.instance
        .collection('stats')
        .document('stats')
        .updateData({"nbGames": nbGames + 1});
  }
}
