/// success : true
/// message : "Login success"
/// data : {"token":"35|7SQ2tcuGxZrK6iCusO7KfdP3GcgblVvb1ycuIYQZ","name":"Demo","level":"warehouse"}

class LoginResponse {
  LoginResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  LoginResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
LoginResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => LoginResponse(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// token : "35|7SQ2tcuGxZrK6iCusO7KfdP3GcgblVvb1ycuIYQZ"
/// name : "Demo"
/// level : "warehouse"

class Data {
  Data({
      String? token, 
      String? name, 
      String? level,}){
    _token = token;
    _name = name;
    _level = level;
}

  Data.fromJson(dynamic json) {
    _token = json['token'];
    _name = json['name'];
    _level = json['level'];
  }
  String? _token;
  String? _name;
  String? _level;
Data copyWith({  String? token,
  String? name,
  String? level,
}) => Data(  token: token ?? _token,
  name: name ?? _name,
  level: level ?? _level,
);
  String? get token => _token;
  String? get name => _name;
  String? get level => _level;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['name'] = _name;
    map['level'] = _level;
    return map;
  }

}