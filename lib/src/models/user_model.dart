import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends Model {
  SharedPreferences _prefs;
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

  SharedPreferences get prefs => _prefs;
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

  Future<SharedPreferences> initSharedPrefs() async {
    print("init prefs");
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  void _storeLoginInfo() {
    _prefs.setString('email', _email);
    _prefs.setString('password', _password);
  }

  void _fillModelData(DocumentSnapshot document, bool staySignedIn) {
    _documentSnapshot = document;
    _email = document.data["email"];
    _password = document.data["password"];
    _fullName = document.data["fullName"];
    _stars = document.data["stars"];
    _language = document.data["language"];
    _staySignedIn = staySignedIn;
    _vibration = document.data["vibration"];
    _songs = document.data["songs"];
    _artists = document.data["artists"];
    _favorite = document.data["favorite"];
    _darkTheme = document.data["darkTheme"];
  }

  Future<bool> login(String email, String password, bool staySignedIn) async {
    print("login");
    final QuerySnapshot snapshot = await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: _email)
        .getDocuments();

    if (snapshot.documents.isEmpty) return false;
    if (snapshot.documents[0].data["password"] == password) {
      _fillModelData(snapshot.documents[0], staySignedIn);
      _storeLoginInfo();
      return true;
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
}
