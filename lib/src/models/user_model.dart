import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
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

  Future<bool> login(String email, String password, bool stayLoggedIn) async {
    final QuerySnapshot snapshot = await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: _email)
        .getDocuments();

    if (snapshot.documents.isEmpty) return false;
    if (snapshot.documents[0].data["password"] == password) return true;
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
