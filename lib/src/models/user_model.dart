import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempo_dingo/src/config/register_config.dart' as config;

class UserModel extends Model {
  DocumentSnapshot _documentSnapshot;
  String _email;
  String _password;
  String _fullName;
  int _stars;
  String _language = "US";
  bool _staySignedIn;
  bool vibration = true;
  double volume = 10;
  List<String> _songs;
  List<String> _artists;
  List<String> _favorite;
  List<String> _history;
  bool _darkTheme;
  bool _isConnected = false;
  bool _isSigningOut = false;
  int tabViewIndex = 1;
  int libraryTabIndex = 0;

  DocumentSnapshot get documentSnapshot => _documentSnapshot;
  String get email => _email;
  String get password => _password;
  String get fullName => _fullName;
  int get stars => _stars;
  String get language => _language;
  bool get staySignedIn => _staySignedIn;
  List<String> get songs => _songs;
  List<String> get artists => _artists;
  List<String> get favorite => _favorite;
  List<String> get history => _history;
  bool get darkTheme => _darkTheme;
  bool get isConnected => _isConnected;
  bool get isSigningOut => _isSigningOut;

  void _storeLoginInfo() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('email', _email);
      prefs.setString('password', _password);
    });
  }

  List<String> _convertListDynamicToString(List<dynamic> dlist) =>
      dlist.map((item) => item as String).toList();

  void _fillModelData(DocumentSnapshot document, bool staySignedIn) {
    _documentSnapshot = document;
    _email = document.data["email"];
    _password = document.data["password"];
    _fullName = document.data["fullName"];
    _stars = document.data["stars"];
    _language = document.data["language"];
    _staySignedIn = staySignedIn;
    vibration = document.data["vibration"];
    _songs = _convertListDynamicToString(document.data["library"]["songs"]);
    _artists = _convertListDynamicToString(document.data["library"]["artists"]);
    _favorite =
        _convertListDynamicToString(document.data["library"]["favorite"]);
    _history = _convertListDynamicToString(document.data["library"]["history"]);
    _darkTheme = document.data["darkTheme"];
  }

  Future<bool> login(String email, String password, bool staySignedIn) async {
    final QuerySnapshot snapshot = await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .getDocuments();

    if (snapshot.documents.length == 0) {
      print("Login failed");
      return false;
    }
    if (snapshot.documents[0].data["password"] == password) {
      _fillModelData(snapshot.documents[0], staySignedIn);
      _storeLoginInfo();
      _isConnected = true;
      _isSigningOut = false;
      print("Login success");
      notifyListeners();
      return true;
    } else {
      print("Wrong passord: $password");
    }
    return false;
  }

  Future<void> loginGuest() async {
    print("loginGuest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    // Stars prefs
    int stars = prefs.getInt('stars');
    if (stars == null) {
      _stars = 11;
      prefs.setInt('stars', _stars);
    } else
      _stars = stars;
    // Favorite prefs
    List<String> favorite = prefs.getStringList('favorite');
    if (favorite == null) {
      _favorite = [];
      prefs.setStringList('favorite', []);
    } else
      _favorite = favorite;
    // History prefs
    List<String> history = prefs.getStringList('history');
    if (history == null) {
      _history = [];
      prefs.setStringList('history', []);
    } else
      _history = history;
    // Language prefs
    String language = prefs.getString('language');
    if (language == null) {
      _language = "US";
      prefs.setString('language', "US");
    } else
      _language = language;

    _songs = config.library["songs"];
    _artists = config.library["artists"];
    _language = config.language;
  }

  Future<void> register(String fullName, String email, String password,
      Map<String, dynamic> data) async {
    Firestore.instance
        .collection('users')
        .document(email)
        .setData(data)
        .catchError((err) => print(err));
  }

  Future<bool> emailAlreadyExists(String email) async {
    final DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(email).get();

    return snapshot.data == null ? false : true;
  }

  void logout() async {
    _documentSnapshot = null;
    _email = null;
    _password = null;
    _fullName = "";
    _stars = 0;
    _language = "US";
    _staySignedIn = false;
    volume = 10;
    vibration = true;
    _songs = [];
    _artists = [];
    _favorite = [];
    _darkTheme = true;
    _isConnected = false;
    _isSigningOut = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", null);
    prefs.setString("password", null);
    notifyListeners();
  }

  void addToHistory(String trackId) {
    if (_history.contains(trackId)) _history.remove(trackId);
    _history.insert(0, trackId);
    if (_isConnected) {
      Map<String, dynamic> library = {
        "songs": _songs,
        "artists": _artists,
        "favorite": _favorite,
        "history": _history
      };
      Firestore.instance
          .collection('users')
          .document(_email)
          .updateData({"library": library});
    } else {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setStringList('history', _history);
      });
    }
  }

  bool isPurshased(String trackId) {
    return _songs.contains(trackId) ? true : false;
  }

  bool isFavorite(String trackId) {
    return _favorite.contains(trackId) ? true : false;
  }

  void likeUnlikeTrack(String trackId) {
    isFavorite(trackId) ? _favorite.remove(trackId) : _favorite.add(trackId);
    if (_isConnected) {
      Map<String, dynamic> library = {
        "songs": _songs,
        "artists": _artists,
        "favorite": _favorite,
        "history": _history
      };
      Firestore.instance
          .collection('users')
          .document(_email)
          .updateData({"library": library});
    } else {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setStringList('favorite', _favorite);
      });
    }
  }

  void addOrRemoveStars(int nb) {
    _stars += nb;
    if (_isConnected) {
      Firestore.instance
          .collection('users')
          .document(_email)
          .updateData({"stars": _stars});
    } else {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setInt('stars', _stars);
      });
    }
    notifyListeners();
  }

  void reloadPage() => notifyListeners();
}
