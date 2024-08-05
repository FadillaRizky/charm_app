

import 'dart:convert';

import 'package:charm_app/api/GetDetailOrderResponse.dart';
import 'package:charm_app/api/GetTotalOrderResponse.dart';
import 'package:charm_app/api/UpdateOrderResponse.dart';

import '../utils/shared_pref.dart';
import 'package:http/http.dart' as http;

import 'GetListOrderResponse.dart';

const BASE_URL = "https://tms-ucm.demo-web.pw";

class Api{
  static Future<GetListOrderResponse> getAllOrderList(int currentPage, String nopol,status) async {
    var datatoken = await LoginPref.getPref();
    var token = datatoken.token!;

    var url =
        "$BASE_URL/api/orders?page=$currentPage&nopol=$nopol&status=$status";
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      // currentPage++;
      return GetListOrderResponse.fromJson(jsonDecode(response.body));
    }
    if (response.statusCode == 401) {
      return GetListOrderResponse.fromJson(jsonDecode(response.body));
    }
    //jika tidak,muncul pesan error
    throw "Gagal request order:\n${response.body}";
  }
  static Future<GetDetailOrderResponse> getDetailOrder(num orderId) async {
    var url = "$BASE_URL/api/orders/detail?orderid=$orderId";
    var datatoken = await LoginPref.getPref();
    var token = datatoken.token!;
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return GetDetailOrderResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request detail order:\n${response.body}";

  }
  static Future<UpdateOrderResponse> updateOrder(Map<String, dynamic> dataUser) async {
    var url = "$BASE_URL/api/orders/detail/update";
    var datatoken = await LoginPref.getPref();
    var token = datatoken.token!;
    var response = await http.post(
      Uri.parse(url),
      body: json.encode(dataUser),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return UpdateOrderResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request detail order:\n${response.body}";

  }

  static Future<GetTotalOrderResponse> getTotalOrder() async {
    var url = "$BASE_URL/api/orders/total";
    var datatoken = await LoginPref.getPref();
    var token = datatoken.token!;
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return GetTotalOrderResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request detail order:\n${response.body}";

  }

}