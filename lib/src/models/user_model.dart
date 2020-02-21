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
}
