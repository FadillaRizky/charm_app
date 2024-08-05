/// response : {"total_loading":2,"total_unloading":3}
/// level : "warehouse"
/// message : "success"

class GetTotalOrderResponse {
  GetTotalOrderResponse({
      Response? response, 
      String? level, 
      String? message,}){
    _response = response;
    _level = level;
    _message = message;
}

  GetTotalOrderResponse.fromJson(dynamic json) {
    _response = json['response'] != null ? Response.fromJson(json['response']) : null;
    _level = json['level'];
    _message = json['message'];
  }
  Response? _response;
  String? _level;
  String? _message;
GetTotalOrderResponse copyWith({  Response? response,
  String? level,
  String? message,
}) => GetTotalOrderResponse(  response: response ?? _response,
  level: level ?? _level,
  message: message ?? _message,
);
  Response? get response => _response;
  String? get level => _level;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_response != null) {
      map['response'] = _response?.toJson();
    }
    map['level'] = _level;
    map['message'] = _message;
    return map;
  }

}

/// total_loading : 2
/// total_unloading : 3

class Response {
  Response({
      num? totalLoading, 
      num? totalUnloading,}){
    _totalLoading = totalLoading;
    _totalUnloading = totalUnloading;
}

  Response.fromJson(dynamic json) {
    _totalLoading = json['total_loading'];
    _totalUnloading = json['total_unloading'];
  }
  num? _totalLoading;
  num? _totalUnloading;
Response copyWith({  num? totalLoading,
  num? totalUnloading,
}) => Response(  totalLoading: totalLoading ?? _totalLoading,
  totalUnloading: totalUnloading ?? _totalUnloading,
);
  num? get totalLoading => _totalLoading;
  num? get totalUnloading => _totalUnloading;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_loading'] = _totalLoading;
    map['total_unloading'] = _totalUnloading;
    return map;
  }

}