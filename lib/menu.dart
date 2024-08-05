import 'package:charm_app/daily_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../utils/alerts.dart';
import 'api/GetListOrderResponse.dart';
import 'api/api.dart';
import 'constants.dart';
import 'daily_unloading.dart';
import 'detail_so.dart';
import 'grid_menu.dart';
import 'not_found.dart';

class Menu extends StatefulWidget {
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  TextEditingController nopolController = TextEditingController();
  RefreshController refreshC = RefreshController();

  bool isDailyLoading = true;
  bool loading = true;
  List<Data> result = [];
  int currentPage = 1;
  num? totalOrder;

  num totalLoading = 0;
  num totalUnloading = 0;

  initOrderlist(String status) async {
    result.clear();
    setState(() {
      loading = true;
    });
    currentPage = 1;
    Api.getTotalOrder().then((value) {

      if (value.message == "success") {
        setState(() {
          totalLoading = value.response!.totalLoading!;
          totalUnloading = value.response!.totalUnloading!;
        });
      }

      Api.getAllOrderList(
        currentPage,
        "",
        status,
      ).then((value) {

        if (value.response!.total == 0) {
          setState(() {
            loading = false;
            result = [];
            totalOrder = value.response!.total;
          });
        }
        if (value.response!.total! > 0) {
          setState(() {
            loading = false;
            result.addAll(value.response!.data!);
            totalOrder = value.response!.total;
          });
        }
      });
    });

  }

  refreshSpklist() {
    try {
      setState(() {});
      loading = true;
      initOrderlist(isDailyLoading ? "loading" : "unloading");
      refreshC.refreshCompleted();
    } catch (e) {
      refreshC.refreshFailed();
    }
  }

  void loadData() async {
    try {
      if (result.length >= totalOrder!) {
        refreshC.loadNoData();
      } else {
        currentPage++;
        await Api.getAllOrderList(
          currentPage,
          "",
          isDailyLoading ? "loading" : "unloading",
        ).then((value) {
          result.addAll(value.response!.data!);
          setState(() {});
        });
        refreshC.loadComplete();
      }
    } catch (e) {
      print(e);
      refreshC.loadFailed();
    }
  }

  @override
  void initState() {
    super.initState();
    initOrderlist("loading");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.primaryColor,
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
                      height: constraints.maxHeight * 0.8,
                      width: width,
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 3 / 2.5),
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (index == 0) {
                                      setState(() {
                                        isDailyLoading = true;
                                        refreshC.refreshFailed();
                                        initOrderlist("loading");
                                      });
                                    } else {
                                      setState(() {
                                        isDailyLoading = false;
                                        refreshC.refreshFailed();
                                        initOrderlist("unloading");
                                      });
                                    }
                                    print(index);
                                    print(currentPage);
                                    print(totalOrder);
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  (index == 0)
                                                      ? "Daily Loading"
                                                      : "Daily Unloading",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  (index == 0)
                                                      ? totalLoading.toString()
                                                      : totalUnloading
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          (isDailyLoading)
                                              ? (index == 0)
                                                  ? Container(
                                                      height: 3,
                                                      width: 50,
                                                      color: Colors.blue,
                                                    )
                                                  : SizedBox()
                                              : (index == 1)
                                                  ? Container(
                                                      height: 3,
                                                      width: 50,
                                                      color: Colors.blue,
                                                    )
                                                  : SizedBox()
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                insetPadding: EdgeInsets.all(10),
                                backgroundColor: Colors.white,
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Filter",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 2),
                                        width: double.infinity,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TextFormField(
                                          controller: nopolController,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      10, 3, 1, 3),
                                              hintText: "X 1234 XX",
                                              labelText: "Nopol",
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    style: BorderStyle.none),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              nopolController.clear();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Batal"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Cari"),
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
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 15, 0),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 0.5, color: Colors.black54),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Filter",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54),
                              ),
                              Icon(
                                Icons.filter_alt_sharp,
                                color: Colors.blue,
                                size: 23,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // (isDailyLoading) ? DailyLoading(status: 'loading',) : DailyLoading(status: 'unloading',)
                    (loading == true)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : (result.isNotEmpty)
                            ? Expanded(
                                child: SmartRefresher(
                                  controller: refreshC,
                                  enablePullDown: true,
                                  enablePullUp: false,
                                  onRefresh: refreshSpklist,
                                  // onLoading: loadData,
                                  child: ListView.builder(
                                      itemCount: result.length,
                                      itemBuilder: (context, index) {
                                        final order = result[index];
                                        return AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          duration: const Duration(seconds: 1),
                                          child: SlideAnimation(
                                            verticalOffset: 44.0,
                                            child: FadeInAnimation(
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (ctx) =>
                                                                DetailSO(
                                                              SoNumber: order
                                                                  .soNumber!,
                                                              OrderId: order
                                                                  .orderid!,
                                                              status: (isDailyLoading)
                                                                  ? "loading"
                                                                  : "unloading",
                                                            ),
                                                          ),
                                                        ).then((value) {
                                                          (isDailyLoading)
                                                         ? initOrderlist("loading")
                                                              : initOrderlist("unloading");
                                                        });
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                15, 10, 15, 10),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black26),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "SO Number: ${order.soNumber}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black87,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                                order
                                                                    .policeNumber!,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .black87,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700)),
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Divider(
                                                              color: Colors
                                                                  .black26,
                                                            ),
                                                            Text(
                                                                "Driver : ${order.driverName}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            Text(
                                                                order
                                                                    .driverPhone!,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            : Center(
                                child: Column(
                                children: [
                                  Text("BELUM ADA DATA"),
                                ],
                              ))
                  ],
                ),
              )
            ],
          ),
        )
        //     SafeArea(
        //   child: Padding(
        //     padding: const EdgeInsets.all(10),
        //     child: Column(
        //       children: [
        //         Row(
        //           children: [
        //             Expanded(
        //               child: GridView.builder(
        //                   shrinkWrap: true,
        //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //                     crossAxisCount: 2,
        //                   ),
        //                   itemCount: 2,
        //                   itemBuilder: (context, index) {
        //                     return GestureDetector(
        //                       onTap: () {
        //                         if (index == 0) {
        //                           isDailyLoading = true;
        //                           setState(() {});
        //                         } else {
        //                           isDailyLoading = false;
        //                           setState(() {});
        //                         }
        //                         print(index);
        //                         print(isDailyLoading);
        //                       },
        //                       child: Card(
        //                         color: Colors.white,
        //                         elevation: 2,
        //                         child: Padding(
        //                           padding: EdgeInsets.all(10),
        //                           child: Column(
        //                             children: [
        //                               Expanded(
        //                                 child: Column(
        //                                   mainAxisAlignment: MainAxisAlignment.center,
        //                                   children: [
        //                                     Text(
        //                                       (index == 0)
        //                                           ? "Daily Loading"
        //                                           : "Daily Unloading",
        //                                       style: TextStyle(
        //                                           fontSize: 17,
        //                                           fontWeight: FontWeight.bold),
        //                                     ),
        //                                     SizedBox(
        //                                       height: 10,
        //                                     ),
        //                                     Text(
        //                                       "10",
        //                                       style: TextStyle(
        //                                           fontSize: 30,
        //                                           fontWeight: FontWeight.bold),
        //                                     ),
        //
        //                                   ],
        //                                 ),
        //                               ),
        //                               (isDailyLoading)
        //                                   ? (index == 0)
        //                                   ? Container(
        //                                 height: 3,
        //                                 width: 50,
        //                                 color: Colors.blue,
        //                               )
        //                                   : SizedBox()
        //                                   : (index == 1)
        //                                   ? Container(
        //                                 height: 3,
        //                                 width: 50,
        //                                 color: Colors.blue,
        //                               )
        //                                   : SizedBox()
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                     );
        //                   }),
        //             ),
        //           ],
        //         ),

        //         SizedBox(
        //           height: 10,
        //         ),
        //         (isDailyLoading) ? DailyLoading() : DailyUnloading()
        //       ],
        //     ),
        //   ),
        // )

        // SafeArea(
        //   child: Stack(
        //     children: [
        //       Container(
        //         decoration: BoxDecoration(
        //           image: DecorationImage(
        //             image: AssetImage("assets/background.jpg"),
        //             fit: BoxFit.fill,
        //           ),
        //         ),
        //       ),
        //       Padding(
        //         padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             SizedBox(
        //               height: 50,
        //             ),
        //             Hero(
        //               tag: 'logo_jpp',
        //               child: Image.asset(
        //                 'assets/logo_charm.png',
        //                 width: 250,
        //                 height: 150,
        //               ),
        //             ),
        //             SizedBox(
        //               height: 70,
        //             ),
        //
        //             Expanded(
        //               child: GridView.builder(
        //                 itemCount: 12,
        //                 itemBuilder: (context, index) {
        //                   final item = menu[index];
        //                   return Column(
        //                     children: [
        //                       GestureDetector(
        //                         onTap: () {
        //                           tapped(index,context);
        //                         },
        //                         child: Container(
        //                           height: 60,
        //                           width: 60,
        //                           decoration: BoxDecoration(
        //                               color: Colors.white,
        //                               borderRadius: BorderRadius.circular(10)),
        //                           child: Image.asset(
        //                             item.imagePath,
        //                             fit: BoxFit.cover,
        //                           ),
        //                         ),
        //                       ),
        //                       SizedBox(
        //                         height: 2,
        //                       ),
        //                       Text(
        //                         item.name,
        //                         style: TextStyle(
        //                             fontSize: 14, fontWeight: FontWeight.w500),
        //                         maxLines: 1,
        //                         overflow: TextOverflow.ellipsis,
        //                       )
        //                     ],
        //                   );
        //                 },
        //
        //                 // GestureDetector(
        //                 //     onTap: () => tapped(index),
        //                 //     child: Container(decoration: BoxDecoration(
        //                 //         color: Colors.white70, shape: BoxShape.circle))),
        //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //                   crossAxisCount: 4,
        //                   // mainAxisSpacing: 10,
        //                   // crossAxisSpacing: 10,
        //                   // childAspectRatio: 3 / 2,
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        );
  }
}
