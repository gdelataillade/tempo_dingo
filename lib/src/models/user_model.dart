import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends Model {
  DocumentSnapshot _documentSnapshot;
  String _email;
  String _password;
  String _fullName;
  int _stars;
  String _language;
  bool _staySignedIn;
  bool _vibration;
  List<String> _songs;
  List<String> _artists;
  List<String> _favorite;
  bool _darkTheme;
  bool _isConnected = false;
  bool _isSigningOut = false;

  DocumentSnapshot get documentSnapshot => _documentSnapshot;
  String get email => _email;
  String get password => _password;
  String get fullName => _fullName;
  int get stars => _stars;
  String get language => _language;
  bool get staySignedIn => _staySignedIn;
  bool get vibration => _vibration;
  List<String> get songs => _songs;
  List<String> get artists => _artists;
  List<String> get favorite => _favorite;
  bool get darkTheme => _darkTheme;
  bool get isConnected => _isConnected;
  bool get isSigningOut => _isSigningOut;

  void _storeLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('email', _email);
    prefs.setString('password', _password);
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
    _vibration = document.data["vibration"];
    _songs = _convertListDynamicToString(document.data["library"]["songs"]);
    _artists = _convertListDynamicToString(document.data["library"]["artists"]);
    _favorite =
        _convertListDynamicToString(document.data["library"]["favorite"]);
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

  Future<void> register(String fullName, String email, String password,
      Map<String, dynamic> data) async {
    Firestore.instance
        .collection('users')
        .document(_email)
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
    _email = "";
    _password = "";
    _fullName = "";
    _stars = 0;
    _language = "US";
    _staySignedIn = false;
    _vibration = true;
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

  bool isFavorite(String trackId) {
    return _favorite.contains(trackId) ? true : false;
  }

  void likeUnlikeTrack(String trackId) {
    isFavorite(trackId) ? _favorite.remove(trackId) : _favorite.add(trackId);
    notifyListeners();
    Map<String, dynamic> library = {
      "songs": _songs,
      "artists": _artists,
      "favorite": _favorite
    };
    Firestore.instance
        .collection('users')
        .document(_email)
        .updateData({"library": library});
  }
}
