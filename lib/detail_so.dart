import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:slider_button/slider_button.dart';

import 'api/GetDetailOrderResponse.dart';
import 'api/api.dart';
import 'constants.dart';

class DetailSO extends StatefulWidget {
  String SoNumber;
  num OrderId;
  String status;

  DetailSO(
      {super.key,
      required this.SoNumber,
      required this.OrderId,
      required this.status});

  @override
  State<DetailSO> createState() => _DetailSOState();
}

class _DetailSOState extends State<DetailSO> {
  Future<GetDetailOrderResponse>? detailOrder;
  TextEditingController issueController = TextEditingController();
  bool checkIssue = false;

  DateTime now = DateTime.now();

  // Format the date and time as needed

  convertDate(String datetime){
    DateTime date = DateTime.parse(datetime);
    String formattedDate = DateFormat('dd MMMM yyyy').format(date);
    return formattedDate;
  }

  slideUpdate(String status) {
    String dateNow = "${now.year}-${now.month}-${now.day}";
    String timeNow = "${now.hour}:${now.minute}:${now.second}";
    String idOrder = widget.OrderId.toString();
    var commonFields = {
      "orderid": widget.OrderId,
      "status": status,
    };
    var data = <String, dynamic>{};

    if (status == "arrival") {
      data = {
        ...commonFields,
        "actual_date_arrival": dateNow,
        "actual_time_arrival": timeNow
      };
    } else if (status == "loading") {
      data = {
        ...commonFields,
        "actual_date_loading": dateNow,
        "actual_time_loading": timeNow,
        "loading_checked": 1
      };
    } else if (status == "delivery") {
      data = {
        ...commonFields,
        "actual_date_delivery": dateNow,
        "actual_time_delivery": timeNow
      };
    } else if (status == "unloading") {
      data = {
        ...commonFields,
        "actual_date_unloading": dateNow,
        "actual_time_unloading": timeNow
      };
    }
    print(data);

    // var data = {
    // if (status == "arrival") ...{
    //   "actual_date_arrival": dateNow,
    //   "actual_time_arrival": timeNow
    // } ,
    // if (status == "loading") ... {
    //   "actual_date_loading": dateNow,
    //   "actual_time_loading": timeNow,
    //   "loading_checked": 1
    // },
    // if (status == "delivery") ...{
    //   "actual_date_delivery": dateNow,
    //   "actual_time_delivery": timeNow
    // },
    // if (status == "unloading") ...{
    //   "actual_date_unloading": dateNow,
    //   "actual_time_unloading": timeNow
    // }
    // };

    print(data);
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
                "Loading ..",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        );
      },
    );
    Api.updateOrder(data).then((value) {
      if (value.message == "success") {
        Navigator.pop(context);
        EasyLoading.showSuccess("Update Success");

        setState(() {
          getDetail();
        });
        print("Success");
      } else {
        Navigator.pop(context);
        EasyLoading.showError("Update Gagal");
      }
    });
  }

  getDetail() {
    detailOrder = Api.getDetailOrder(widget.OrderId);
  }

  @override
  void initState() {
    getDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
            child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              color: Constants.primaryColor,
              height: height,
              width: width,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                      height: height,
                      width: width,
                      padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                      child: FutureBuilder(
                          future: detailOrder,
                          builder: (context,
                              AsyncSnapshot<GetDetailOrderResponse> snapshot) {
                            if (snapshot.hasData) {
                              return detailOrderItem(snapshot, context);
                            }
                            if (snapshot.hasError) {
                              return Center(child: Text("Coba Lagi.."));
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }));
                },
              ),
            ),
          ],
        ))
        // Padding(
        //     padding: const EdgeInsets.all(10),
        //     child: FutureBuilder(
        //         future: detailOrder,
        //         builder:
        //             (context, AsyncSnapshot<GetDetailOrderResponse> snapshot) {
        //           if (snapshot.hasData) {
        //             return detailOrderItem(snapshot, context);
        //           }
        //           if (snapshot.hasError) {
        //             return Center(child: Text("Coba Lagi.."));
        //           }
        //           return Center(
        //             child: CircularProgressIndicator(),
        //           );
        //         })),
        );
  }

  Widget detailOrderItem(
      AsyncSnapshot<GetDetailOrderResponse> snapshot, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "SO Number : ${snapshot.data!.response!.soNumber!}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          "${snapshot.data!.response!.policeNumber!}",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(),
        SizedBox(
          height: 10,
        ),
        (widget.status == "loading")
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Datetime Arrival",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (snapshot.data!.response!.actualDateArrival == null)
                      ? SliderButton(
                          width: double.infinity,
                          action: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    insetPadding: EdgeInsets.all(10),
                                    backgroundColor: Colors.white,
                                    elevation: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Are you sure ?",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                  style: ButtonStyle(
                                                      foregroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.black54),
                                                      shape: MaterialStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))))),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Cancel"),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      foregroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.white),
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors
                                                                  .blueAccent),
                                                      shape: MaterialStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))))),
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    slideUpdate("arrival");
                                                  },
                                                  child: Text("Submit"),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              },
                            );
                          },
                          alignLabel: Alignment.center,
                          label: Text(
                            "Slide to Confirm",
                            style: TextStyle(
                                color: Color(0xff4a4a4a),
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                          buttonColor: Colors.blueAccent,
                          icon: Icon(
                            BoxIcons.bxs_truck,
                            color: Colors.white,
                          ))
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(convertDate(snapshot.data!.response!.actualDateArrival) +
                              " - " +
                              "${snapshot.data!.response!.actualTimeArrival}"),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Datetime Loading",
                              style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          (snapshot.data!.response!.actualDateLoading == null)
                              ? SliderButton(
                              width: double.infinity,
                              action: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            insetPadding: EdgeInsets.all(10),
                                            backgroundColor: Colors.white,
                                            elevation: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Are you sure ?",
                                                    style: TextStyle(fontSize: 20),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                    children: [
                                                      Expanded(
                                                        child: OutlinedButton(
                                                          style: ButtonStyle(
                                                              foregroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Colors.black54),
                                                              shape: MaterialStatePropertyAll(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius
                                                                          .all(Radius
                                                                          .circular(
                                                                          5))))),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text("Cancel"),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              foregroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Colors.white),
                                                              backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Colors
                                                                      .blueAccent),
                                                              shape: MaterialStatePropertyAll(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius
                                                                          .all(Radius
                                                                          .circular(
                                                                          5))))),
                                                          onPressed: () async {
                                                            Navigator.pop(context);
                                                            slideUpdate("loading");
                                                          },
                                                          child: Text("Submit"),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                );
                              },
                              alignLabel: Alignment.center,
                              label: Text(
                                "Slide to Confirm",
                                style: TextStyle(
                                    color: Color(0xff4a4a4a),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17),
                              ),
                              buttonColor: Colors.blueAccent,
                              icon: Icon(
                                BoxIcons.bxs_truck,
                                color: Colors.white,
                              ))
                              : Text(convertDate(snapshot.data!.response!.actualDateLoading) +
                              " - " +
                              "${snapshot.data!.response!.actualTimeLoading}")
                        ],
                      ),
                  SizedBox(
                    height: 20,
                  ),

                ],
              )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Datetime Delivery",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (snapshot.data!.response!.actualDateDelivery == null)
                      ? SliderButton(
                          width: double.infinity,
                          action: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    insetPadding: EdgeInsets.all(10),
                                    backgroundColor: Colors.white,
                                    elevation: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Are you sure ?",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                  style: ButtonStyle(
                                                      foregroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.black54),
                                                      shape: MaterialStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))))),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Cancel"),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      foregroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.white),
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors
                                                                  .blueAccent),
                                                      shape: MaterialStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))))),
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    slideUpdate("delivery");
                                                  },
                                                  child: Text("Submit"),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              },
                            );
                          },
                          alignLabel: Alignment.center,
                          label: Text(
                            "Slide to Confirm",
                            style: TextStyle(
                                color: Color(0xff4a4a4a),
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                          buttonColor: Colors.blueAccent,
                          icon: Icon(
                            BoxIcons.bxs_truck,
                            color: Colors.white,
                          ))
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(convertDate(snapshot.data!.response!.actualDateDelivery) +
                              " - " +
                              "${snapshot.data!.response!.actualTimeDelivery}"),
                          SizedBox(height: 20,),
                          Text("Datetime Unloading",
                              style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          (snapshot.data!.response!.actualDateUnloading == null)
                              ? SliderButton(
                              width: double.infinity,
                              action: () async {

                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            insetPadding: EdgeInsets.all(10),
                                            backgroundColor: Colors.white,
                                            elevation: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "is there a problem?",
                                                    style: TextStyle(fontSize: 20),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Checkbox(
                                                          activeColor: Colors.blue,
                                                          value: checkIssue,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              checkIssue = !checkIssue;
                                                            });
                                                          }),
                                                      Text(
                                                        "No",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Checkbox(
                                                              activeColor: Colors.blue,
                                                              value: !checkIssue,
                                                              onChanged: (value) {
                                                                setState(() {
                                                                  checkIssue = !checkIssue;
                                                                });
                                                              }),
                                                          Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white),
                                                          ),
                                                        ],
                                                      ),
                                                      TextField(
                                                        maxLines: 5,
                                                        controller: issueController,
                                                        decoration: InputDecoration(
                                                          labelText: "Note",
                                                          floatingLabelBehavior:
                                                          FloatingLabelBehavior.always,
                                                          contentPadding:
                                                          EdgeInsets.fromLTRB(8, 20, 5, 3),
                                                          border: OutlineInputBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(5),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                    children: [
                                                      Expanded(
                                                        child: OutlinedButton(
                                                          style: ButtonStyle(
                                                              foregroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Colors.black54),
                                                              shape: MaterialStatePropertyAll(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius
                                                                          .all(Radius
                                                                          .circular(
                                                                          5))))),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text("Cancel"),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              foregroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Colors.white),
                                                              backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  Colors
                                                                      .blueAccent),
                                                              shape: MaterialStatePropertyAll(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius
                                                                          .all(Radius
                                                                          .circular(
                                                                          5))))),
                                                          onPressed: () async {
                                                            Navigator.pop(context);
                                                            slideUpdate("unloading");
                                                          },
                                                          child: Text("Submit"),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                );

                                // showDialog(
                                //   context: context,
                                //   barrierDismissible: true,
                                //   builder: (BuildContext context) {
                                //     return StatefulBuilder(
                                //         builder: (context, setState) {
                                //           return Dialog(
                                //             shape: RoundedRectangleBorder(
                                //                 borderRadius: BorderRadius.all(
                                //                     Radius.circular(10))),
                                //             insetPadding: EdgeInsets.all(10),
                                //             backgroundColor: Colors.white,
                                //             elevation: 1,
                                //             child: Padding(
                                //               padding: const EdgeInsets.all(15),
                                //               child: Column(
                                //                 mainAxisSize: MainAxisSize.min,
                                //                 crossAxisAlignment:
                                //                 CrossAxisAlignment.center,
                                //                 children: [
                                //                   Text(
                                //                     "Are you sure ?",
                                //                     style: TextStyle(fontSize: 20),
                                //                   ),
                                //                   SizedBox(
                                //                     height: 10,
                                //                   ),
                                //                   Row(
                                //                     mainAxisAlignment:
                                //                     MainAxisAlignment.end,
                                //                     children: [
                                //                       Expanded(
                                //                         child: OutlinedButton(
                                //                           style: ButtonStyle(
                                //                               foregroundColor:
                                //                               MaterialStatePropertyAll(
                                //                                   Colors.black54),
                                //                               shape: MaterialStatePropertyAll(
                                //                                   RoundedRectangleBorder(
                                //                                       borderRadius: BorderRadius
                                //                                           .all(Radius
                                //                                           .circular(
                                //                                           5))))),
                                //                           onPressed: () {
                                //                             Navigator.pop(context);
                                //                           },
                                //                           child: Text("Cancel"),
                                //                         ),
                                //                       ),
                                //                       SizedBox(
                                //                         width: 10,
                                //                       ),
                                //                       Expanded(
                                //                         child: ElevatedButton(
                                //                           style: ButtonStyle(
                                //                               foregroundColor:
                                //                               MaterialStatePropertyAll(
                                //                                   Colors.white),
                                //                               backgroundColor:
                                //                               MaterialStatePropertyAll(
                                //                                   Colors
                                //                                       .blueAccent),
                                //                               shape: MaterialStatePropertyAll(
                                //                                   RoundedRectangleBorder(
                                //                                       borderRadius: BorderRadius
                                //                                           .all(Radius
                                //                                           .circular(
                                //                                           5))))),
                                //                           onPressed: () async {
                                //                             Navigator.pop(context);
                                //                             slideUpdate("unloading");
                                //                           },
                                //                           child: Text("Submit"),
                                //                         ),
                                //                       )
                                //                     ],
                                //                   )
                                //                 ],
                                //               ),
                                //             ),
                                //           );
                                //         });
                                //   },
                                // );
                              },
                              alignLabel: Alignment.center,
                              label: Text(
                                "Slide to Confirm",
                                style: TextStyle(
                                    color: Color(0xff4a4a4a),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17),
                              ),
                              buttonColor: Colors.blueAccent,
                              icon: Icon(
                                BoxIcons.bxs_truck,
                                color: Colors.white,
                              ))
                              : Text(convertDate(snapshot.data!.response!.actualDateUnloading) +
                              " - " +
                              "${snapshot.data!.response!.actualTimeUnloading}")
                        ],
                      ),
                  SizedBox(
                    height: 20,
                  ),


                ],
              )
      ],
    );
  }
}
