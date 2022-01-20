// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:anbesaye/controller/UserLocationController.dart';
import 'package:anbesaye/controller/notificationController.dart';
import 'package:anbesaye/pages/bus_list_page.dart';
import 'package:anbesaye/util/showDialog.dart';
import 'package:anbesaye/util/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatelessWidget {
  final ulController = Get.put(UserLocationController());
  final nc = Get.put(NotificationController());

  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //Text("please enter your destination"),

          Container(
            height: MediaQuery.of(context).size.height * .21,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(0xFFFF9B37),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 40, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await NotificationController
                              .scheduleNotificationController(
                                  title: "Bus arrive ",
                                  body: "selam",
                                  payload: "load",
                                  dateTime: DateTime.now()
                                      .add(Duration(seconds: 15)));
                        },
                        icon: Icon(
                          Icons.menu,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.01)
                          ..rotateX(0.6),
                        alignment: FractionalOffset.center,
                        child: Text(
                          "home",
                          style: MyTextStyle().title,
                        ),
                      ),
                      Spacer(
                        flex: 10,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 25,
                        ),
                      )
                    ],
                  ),
                  textFieldPart(context)
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.white,
            height: 5,
          ),

          Expanded(child: googleM(context)),
        ],
      ),
    );
  }

  Widget textFieldPart(context) {
    return Obx(() {
      if (!ulController.isLoadedAutoText.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: SizedBox(
          child: Autocomplete(
            onSelected: (String text) {
              Get.to(BusListPage(destination: text));
            },
            optionsBuilder: ((textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return Iterable<String>.empty();
              } else {
                return ulController.autoList.where((p0) => p0
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              }
            }),
            fieldViewBuilder:
                (context, controller, focusnode, onEditingComplete) {
              return TextField(
                controller: controller,
                focusNode: focusnode,
                onEditingComplete: onEditingComplete,
                decoration: InputDecoration(
                    //labelText: "destination",
                    hintText: "destination",
                    hintStyle: MyTextStyle().subtitle2,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue))),
              );
            },
          ),
        ),
      );
    });
  }

  Obx googleM(BuildContext context) {
    return Obx(() {
      return SizedBox(
        child: ulController.isLoadedMap.value
            ? GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                      ulController.user.value.latitude ?? 19.041061,
                      ulController.user.value.longitude ?? 38.762909,
                    ),
                    zoom: 14),
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
                markers: ulController.isIconLoaded.value
                    ? Set<Marker>.of(ulController.markers.values)
                    : {
                        Marker(
                          markerId: MarkerId("melat"),
                        )
                      })
            : Center(
                child: CircularProgressIndicator(),
              ),
      );
    });
  }
}
