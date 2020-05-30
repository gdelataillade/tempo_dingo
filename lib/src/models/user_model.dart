import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify_io.dart';

import 'package:tempo_dingo/src/resources/spotify_repository.dart';
import '../config/language.dart';

class UserModel extends Model {
  SpotifyRepository _spotifyRepository;
  int _stars;
  String _language;
  bool vibration = true;
  bool _darkTheme;
  double volume = 10;
  List<String> _tracks;
  List<String> _artists;
  List<String> _favorite;
  List<String> _history;
  List<String> _highscores;
  int tabViewIndex = 1;
  int libraryTabIndex = 0;
  bool _isGameOver = false;
  bool _showIntro;

  UserModel(SpotifyApiCredentials credentials) {
    _spotifyRepository = SpotifyRepository();
    _spotifyRepository.init(credentials);
  }

  SpotifyRepository get spotifyRepository => _spotifyRepository;
  int get stars => _stars;
  String get language => _language;
  List<String> get songs => _tracks;
  List<String> get artists => _artists;
  List<String> get favorite => _favorite;
  List<String> get history => _history;
  List<String> get highscores => _highscores;
  bool get darkTheme => _darkTheme;
  bool get isGameOver => _isGameOver;
  bool get showIntro => _showIntro;

  Future<void> getSharedPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    await _prefs.clear();

    // Stars prefs
    _stars = _prefs.getInt('stars');
    if (_stars == null) {
      _stars = 11;
      _prefs.setInt('stars', _stars);
    }

    // Tracks prefs
    _tracks = _prefs.getStringList('tracks');
    if (_tracks == null) {
      _tracks = [];
      _prefs.setStringList('tracks', _tracks);
    }

    // Artists prefs
    _artists = _prefs.getStringList('artists');
    if (_artists == null) {
      _artists = [];
      _prefs.setStringList('artists', _artists);
    }

    // Favorite prefs
    _favorite = _prefs.getStringList('favorite');
    if (_favorite == null) {
      _favorite = [];
      _prefs.setStringList('favorite', []);
    }

    // History prefs
    _history = _prefs.getStringList('history');
    if (_history == null) {
      _history = [];
      _prefs.setStringList('history', []);
    }

    // Language prefs
    _language = _prefs.getString('language');
    if (_language == null) {
      _language = "en";
      _prefs.setString('language', "en");
    }

    // Highscores
    _highscores = _prefs.getStringList('highscores');
    if (_highscores == null) {
      _highscores = List<String>();
      for (var i = 0; i < _tracks.length; i++) _highscores.add('0');
      _prefs.setStringList('highscores', _highscores);
    }

    // Is first visit
    _showIntro = _prefs.getBool('showIntro');
    if (_showIntro == null) {
      _showIntro = true;
      _prefs.setBool('showIntro', true);
    }
  }

  Future _customizeLibrary(List<bool> genres, int nbSelected) {
    // override library
  }

  void introFinished(List<bool> genres, int nbSelected) async {
    _showIntro = false;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('showIntro', false);
    });
    print("notify");
    await _customizeLibrary(genres, nbSelected);
    notifyListeners();
  }

  void addToHistory(String trackId) {
    print("Add track to history");
    if (_history.contains(trackId)) _history.remove(trackId);
    _history.insert(0, trackId);

    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('history', _history);
    });
  }

  bool isPurshased(String trackId) {
    return _tracks.contains(trackId) ? true : false;
  }

  void purchaseTrack(String trackId, String artistId, int price) {
    if (_tracks.contains(trackId)) return;
    _tracks.add(trackId);
    if (!_artists.contains(artistId)) _artists.add(artistId);
    _highscores.add("0");
    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('tracks', _tracks);
      prefs.setStringList('artists', _artists);
      prefs.setStringList('highscores', _highscores);
      addOrRemoveStars(price * -1);
      getSharedPrefs();
    });
    notifyListeners();
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
    // print("stars: $_stars = $_stars + $nb = ${_stars + nb}");
    _stars += nb;

    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('stars', _stars);
    });
    notifyListeners();
  }

  bool isHighscore(String nbStr, String trackId) {
    double _nb = double.parse(nbStr);
    int _index = _tracks.indexOf(trackId);

    // Check if highscore
    if (_nb > double.parse(_highscores[_index])) {
      // Save highscore
      _highscores[_index] = nbStr;
      SharedPreferences.getInstance().then((prefs) {
        prefs.setStringList('highscores', _highscores);
        return true;
      });

      return true;
    }
    return false;
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

const List<String> genres = [
  "pop",
  "rock",
  "electro",
  "rap",
  "metal",
  "raggae",
];
