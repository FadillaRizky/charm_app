import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:charm_app/not_found.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/LoginResponse.dart';
import '../../api/api.dart';
import '../../constants.dart';
import '../../utils/alerts.dart';
import '../../utils/shared_pref.dart';

import 'package:http/http.dart' as http;

import 'menu.dart';



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  bool isChecked = false;
  bool invisible = true;
  late Box box1;

  bool load = false;

  login() async {
    var email = controllerEmail.text;
    var password = controllerPassword.text;
    //validasi
    if (email.isEmpty) {
      Alerts.showMessage("Masukan Email Anda", context);
      return;
    }
    if (password.isEmpty) {
      Alerts.showMessage("Masukan Password Anda", context);
      return;
    }
    // var data = {
    //   "email": email,
    //   "password": password,
    // };
    var data = {
      "email": "demo@gmail.com",
      "password": "logistik123",
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Login ..",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        );
      },
    );

    try {
      var url = "https://tms-ucm.demo-web.pw/api/login";
      var response = await http
          .post(Uri.parse(url), body: data)
          .timeout(Duration(seconds: 3));
      var result = LoginResponse.fromJson(jsonDecode(response.body));
      if (isChecked) {
        box1.put('email', controllerEmail.text);
      }
      if (result.message == "Login success") {
        LoginPref.saveToSharedPref(result.data!.token!);
        Alerts.showMessage("Login Berhasil..", context);
        Navigator.pop(context);
        if(result.data!.level == "warehouse"){
          Navigator.of(context).pushReplacement(PageTransition(
              duration: Duration(seconds: 1),
              type: PageTransitionType.fade,
              child:
              Menu()
          ));
        }else{
          Navigator.of(context).pushReplacement(PageTransition(
              duration: Duration(seconds: 1),
              type: PageTransitionType.fade,
              child:
              NotFound()
          ));
        }
      } else if (result.message != "login success") {
        Alerts.showMessage("Login Gagal..", context);
        Navigator.pop(context);
      }
    } on TimeoutException catch (_) {
      Alerts.showMessage("Sinyal Buruk", context);
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }

  }


  launchWhatsApp() async {
    var whatsapp = "+6282122075284";
    var whatsappURl_android = "whatsapp://send?phone=" + whatsapp + "&text=";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatappURL_ios))) {
        await launchUrl(Uri.parse(whatappURL_ios));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      if (await canLaunchUrl(Uri.parse(whatsappURl_android))) {
        await launchUrl(Uri.parse(whatsappURl_android));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    createBox();
  }

  void createBox() async {
    box1 = await Hive.openBox("logindata");
    getData();
  }

  void getData() async {
    if (box1.get('email') != null) {
      controllerEmail.text = box1.get('email');
      isChecked = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Hero(
                      tag: "logo",
                      child: Image.asset(
                        'assets/logo_charm.png',
                        width: 250,
                        height: 150,
                      ),
                    ),
                    Text("unicharm",style: TextStyle(color: Color(0xff143685),fontWeight: FontWeight.bold,fontSize: 30),),
                    SizedBox(
                      height: 100,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerEmail,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 3, 1, 3),
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 0, style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextFormField(
                        obscureText: invisible,
                        keyboardType: TextInputType.text,
                        controller: controllerPassword,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 3, 1, 3),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 0, style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                              icon: Icon((invisible == true)
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  invisible = !invisible;
                                });
                              }),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.blue,
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = !isChecked;
                              });
                            }),
                        Text(
                          "Ingatkan Saya",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(225, 213, 143, 2),
                          Color.fromARGB(225, 248, 215, 110)
                        ]),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          login();
                        },
                        child: Text(
                          "Masuk",
                          style: TextStyle(fontSize: 17,color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // TextButton(
                    //     onPressed: () {
                    //       launchWhatsApp();
                    //     },
                    //     child: Text(
                    //       "Butuh Bantuan? Hubungi kami",
                    //       style: TextStyle(color: Colors.white, fontSize: 15),
                    //     ))
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}
