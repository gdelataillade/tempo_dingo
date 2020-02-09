class UserModel {
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

  UserModel.fromJson(Map<String, dynamic> parsedJson) {
    _email = parsedJson['email'];
    _password = parsedJson['password'];
    _fullName = parsedJson['fullName'];
    _stars = parsedJson['stars'];
    _language = parsedJson['language'];
    _staySignedIn = parsedJson['staySignedIn'];
    _vibration = parsedJson['vibration'];
    _songs = parsedJson['songs'];
    _artists = parsedJson['artists'];
    _favorite = parsedJson['favorite'];
    _darkTheme = parsedJson['darkTheme'];
  }

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
