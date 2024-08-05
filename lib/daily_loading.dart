import 'package:charm_app/detail_so.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'api/GetListOrderResponse.dart';
import 'api/api.dart';

class DailyLoading extends StatefulWidget {
  String status;

  DailyLoading({super.key, required this.status});

  @override
  State<DailyLoading> createState() => _DailyLoadingState();
}

class _DailyLoadingState extends State<DailyLoading> {
  RefreshController refreshC = RefreshController();
  bool loading = true;
  List<Data> result = [];
  int currentPage = 1;
  num? totalOrder;

  initOrderlist() async {
    result.clear();
    setState(() {
      loading = true;
    });
    currentPage = 1;
    Api.getAllOrderList(
      currentPage,
      "",
      widget.status,
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
  }

  refreshSpklist() {
    try {
      setState(() {});
      loading = true;
      initOrderlist();
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
          widget.status,
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
    initOrderlist();
  }

  @override
  Widget build(BuildContext context) {
    return (loading == true)
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
                        return AnimationConfiguration.staggeredList(
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
                                                builder: (ctx) => DetailSO(
                                                    SoNumber:
                                                        order.soNumber!, OrderId: order.orderid!,
                                                status: "",
                                                )));
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 10, 15, 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black26),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "SO Number: ${order.soNumber}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(
                                                  "Status",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text("Nopol : ${order.policeNumber} ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "15 Februari 2024",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black54),
                                                ),
                                                Container(
                                                  // width: 140,
                                                  // height: 25,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      color: Color.fromARGB(
                                                          225, 195, 229, 255)),
                                                  child: Text(
                                                    widget.status,
                                                    style: TextStyle(
                                                      overflow:
                                                          TextOverflow.fade,
                                                      color: Colors.blue,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.black26,
                                            ),
                                            Text("-",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            Text(
                                              "Keterangan:",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black54),
                                            ),
                                            SizedBox(
                                              height: 30,
                                              width: double.infinity,
                                              child: Text(
                                                "-",
                                                maxLines: 3,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.black54),
                                              ),
                                            ),
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
              ));
  }
}
