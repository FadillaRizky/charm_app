/// response : {"orderid":3,"so_number":"UCM2024070003","customer_name":"BERDIRI MATAHARI LOGISTIK, PT","pickup_dt":"2024-07-28","eta":"2024-07-30","actual_date_arrival":null,"actual_time_arrival":null,"actual_date_loading":null,"actual_time_loading":null,"loading_checked":"0","actual_date_delivery":null,"actual_time_delivery":null,"actual_date_unloading":null,"actual_time_unloading":null,"armada_type":"TRONTON WINGBOX","commodity_name":"Others","origin":"Karawang","destination":"Lampung","vendor_name":"SINAR CAKRA BUANA, PT","police_number":"B 9317 TEZ","driver_name":"A FAQIH FADHOLI","driver_phone":"085692399503"}
/// level : "warehouse"
/// message : "success"

class GetDetailOrderResponse {
  GetDetailOrderResponse({
      Response? response, 
      String? level, 
      String? message,}){
    _response = response;
    _level = level;
    _message = message;
}

  GetDetailOrderResponse.fromJson(dynamic json) {
    _response = json['response'] != null ? Response.fromJson(json['response']) : null;
    _level = json['level'];
    _message = json['message'];
  }
  Response? _response;
  String? _level;
  String? _message;
GetDetailOrderResponse copyWith({  Response? response,
  String? level,
  String? message,
}) => GetDetailOrderResponse(  response: response ?? _response,
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

/// orderid : 3
/// so_number : "UCM2024070003"
/// customer_name : "BERDIRI MATAHARI LOGISTIK, PT"
/// pickup_dt : "2024-07-28"
/// eta : "2024-07-30"
/// actual_date_arrival : null
/// actual_time_arrival : null
/// actual_date_loading : null
/// actual_time_loading : null
/// loading_checked : "0"
/// actual_date_delivery : null
/// actual_time_delivery : null
/// actual_date_unloading : null
/// actual_time_unloading : null
/// armada_type : "TRONTON WINGBOX"
/// commodity_name : "Others"
/// origin : "Karawang"
/// destination : "Lampung"
/// vendor_name : "SINAR CAKRA BUANA, PT"
/// police_number : "B 9317 TEZ"
/// driver_name : "A FAQIH FADHOLI"
/// driver_phone : "085692399503"

class Response {
  Response({
      num? orderid, 
      String? soNumber, 
      String? customerName, 
      String? pickupDt, 
      String? eta, 
      dynamic actualDateArrival, 
      dynamic actualTimeArrival, 
      dynamic actualDateLoading, 
      dynamic actualTimeLoading, 
      String? loadingChecked, 
      dynamic actualDateDelivery, 
      dynamic actualTimeDelivery, 
      dynamic actualDateUnloading, 
      dynamic actualTimeUnloading, 
      String? armadaType, 
      String? commodityName, 
      String? origin, 
      String? destination, 
      String? vendorName, 
      String? policeNumber, 
      String? driverName, 
      String? driverPhone,}){
    _orderid = orderid;
    _soNumber = soNumber;
    _customerName = customerName;
    _pickupDt = pickupDt;
    _eta = eta;
    _actualDateArrival = actualDateArrival;
    _actualTimeArrival = actualTimeArrival;
    _actualDateLoading = actualDateLoading;
    _actualTimeLoading = actualTimeLoading;
    _loadingChecked = loadingChecked;
    _actualDateDelivery = actualDateDelivery;
    _actualTimeDelivery = actualTimeDelivery;
    _actualDateUnloading = actualDateUnloading;
    _actualTimeUnloading = actualTimeUnloading;
    _armadaType = armadaType;
    _commodityName = commodityName;
    _origin = origin;
    _destination = destination;
    _vendorName = vendorName;
    _policeNumber = policeNumber;
    _driverName = driverName;
    _driverPhone = driverPhone;
}

  Response.fromJson(dynamic json) {
    _orderid = json['orderid'];
    _soNumber = json['so_number'];
    _customerName = json['customer_name'];
    _pickupDt = json['pickup_dt'];
    _eta = json['eta'];
    _actualDateArrival = json['actual_date_arrival'];
    _actualTimeArrival = json['actual_time_arrival'];
    _actualDateLoading = json['actual_date_loading'];
    _actualTimeLoading = json['actual_time_loading'];
    _loadingChecked = json['loading_checked'];
    _actualDateDelivery = json['actual_date_delivery'];
    _actualTimeDelivery = json['actual_time_delivery'];
    _actualDateUnloading = json['actual_date_unloading'];
    _actualTimeUnloading = json['actual_time_unloading'];
    _armadaType = json['armada_type'];
    _commodityName = json['commodity_name'];
    _origin = json['origin'];
    _destination = json['destination'];
    _vendorName = json['vendor_name'];
    _policeNumber = json['police_number'];
    _driverName = json['driver_name'];
    _driverPhone = json['driver_phone'];
  }
  num? _orderid;
  String? _soNumber;
  String? _customerName;
  String? _pickupDt;
  String? _eta;
  dynamic _actualDateArrival;
  dynamic _actualTimeArrival;
  dynamic _actualDateLoading;
  dynamic _actualTimeLoading;
  String? _loadingChecked;
  dynamic _actualDateDelivery;
  dynamic _actualTimeDelivery;
  dynamic _actualDateUnloading;
  dynamic _actualTimeUnloading;
  String? _armadaType;
  String? _commodityName;
  String? _origin;
  String? _destination;
  String? _vendorName;
  String? _policeNumber;
  String? _driverName;
  String? _driverPhone;
Response copyWith({  num? orderid,
  String? soNumber,
  String? customerName,
  String? pickupDt,
  String? eta,
  dynamic actualDateArrival,
  dynamic actualTimeArrival,
  dynamic actualDateLoading,
  dynamic actualTimeLoading,
  String? loadingChecked,
  dynamic actualDateDelivery,
  dynamic actualTimeDelivery,
  dynamic actualDateUnloading,
  dynamic actualTimeUnloading,
  String? armadaType,
  String? commodityName,
  String? origin,
  String? destination,
  String? vendorName,
  String? policeNumber,
  String? driverName,
  String? driverPhone,
}) => Response(  orderid: orderid ?? _orderid,
  soNumber: soNumber ?? _soNumber,
  customerName: customerName ?? _customerName,
  pickupDt: pickupDt ?? _pickupDt,
  eta: eta ?? _eta,
  actualDateArrival: actualDateArrival ?? _actualDateArrival,
  actualTimeArrival: actualTimeArrival ?? _actualTimeArrival,
  actualDateLoading: actualDateLoading ?? _actualDateLoading,
  actualTimeLoading: actualTimeLoading ?? _actualTimeLoading,
  loadingChecked: loadingChecked ?? _loadingChecked,
  actualDateDelivery: actualDateDelivery ?? _actualDateDelivery,
  actualTimeDelivery: actualTimeDelivery ?? _actualTimeDelivery,
  actualDateUnloading: actualDateUnloading ?? _actualDateUnloading,
  actualTimeUnloading: actualTimeUnloading ?? _actualTimeUnloading,
  armadaType: armadaType ?? _armadaType,
  commodityName: commodityName ?? _commodityName,
  origin: origin ?? _origin,
  destination: destination ?? _destination,
  vendorName: vendorName ?? _vendorName,
  policeNumber: policeNumber ?? _policeNumber,
  driverName: driverName ?? _driverName,
  driverPhone: driverPhone ?? _driverPhone,
);
  num? get orderid => _orderid;
  String? get soNumber => _soNumber;
  String? get customerName => _customerName;
  String? get pickupDt => _pickupDt;
  String? get eta => _eta;
  dynamic get actualDateArrival => _actualDateArrival;
  dynamic get actualTimeArrival => _actualTimeArrival;
  dynamic get actualDateLoading => _actualDateLoading;
  dynamic get actualTimeLoading => _actualTimeLoading;
  String? get loadingChecked => _loadingChecked;
  dynamic get actualDateDelivery => _actualDateDelivery;
  dynamic get actualTimeDelivery => _actualTimeDelivery;
  dynamic get actualDateUnloading => _actualDateUnloading;
  dynamic get actualTimeUnloading => _actualTimeUnloading;
  String? get armadaType => _armadaType;
  String? get commodityName => _commodityName;
  String? get origin => _origin;
  String? get destination => _destination;
  String? get vendorName => _vendorName;
  String? get policeNumber => _policeNumber;
  String? get driverName => _driverName;
  String? get driverPhone => _driverPhone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderid'] = _orderid;
    map['so_number'] = _soNumber;
    map['customer_name'] = _customerName;
    map['pickup_dt'] = _pickupDt;
    map['eta'] = _eta;
    map['actual_date_arrival'] = _actualDateArrival;
    map['actual_time_arrival'] = _actualTimeArrival;
    map['actual_date_loading'] = _actualDateLoading;
    map['actual_time_loading'] = _actualTimeLoading;
    map['loading_checked'] = _loadingChecked;
    map['actual_date_delivery'] = _actualDateDelivery;
    map['actual_time_delivery'] = _actualTimeDelivery;
    map['actual_date_unloading'] = _actualDateUnloading;
    map['actual_time_unloading'] = _actualTimeUnloading;
    map['armada_type'] = _armadaType;
    map['commodity_name'] = _commodityName;
    map['origin'] = _origin;
    map['destination'] = _destination;
    map['vendor_name'] = _vendorName;
    map['police_number'] = _policeNumber;
    map['driver_name'] = _driverName;
    map['driver_phone'] = _driverPhone;
    return map;
  }

}