// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong/latlong.dart";
import "package:http/http.dart" as http;
import "dart:convert" as convert;
import "package:flutter_app/copyrights_page.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String apiKey = "YOUR_API_KEY";

  @override
  Widget build(BuildContext context) {
    final tomtomHQ = new LatLng(52.376372, 4.908066);
    return MaterialApp(
      title: "TomTom Map",
      home: Scaffold(
        body: Center(
            child: Stack(
          children: <Widget>[
            FlutterMap(
              options: new MapOptions(
                center: tomtomHQ,
                zoom: 13.0
              ),
              layers: [
                new TileLayerOptions(
                  urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/"
                      "{z}/{x}/{y}.png?key={apiKey}",
                  additionalOptions: {
                    "apiKey": apiKey,
                  },
                ),
                new MarkerLayerOptions(
                  markers: [
                    new Marker(
                      width: 80.0,
                      height: 80.0,
                      point: new LatLng(52.376372, 4.908066),
                      builder: (BuildContext context) => const Icon(
                        Icons.location_on,
                        size: 60.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomLeft,
              child: Image.asset("images/tt_logo.png"),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.copyright),
          onPressed: () async {
            http.Response response = await getCopyrightsJSONResponse();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CopyrightsPage(copyrightsText: parseCopyrightsResponse(response))));
          },
        ),
      ),
    );
  }

  Future<http.Response> getCopyrightsJSONResponse() async {
    var url = "https://api.tomtom.com/map/1/copyrights.json?key=$apiKey";
    var response = await http.get(url);
    return response;
  }

  String parseCopyrightsResponse(http.Response response) {
    if (response.statusCode == 200) {
      StringBuffer stringBuffer = StringBuffer();
      var jsonResponse = convert.jsonDecode(response.body);
      parseGeneralCopyrights(jsonResponse, stringBuffer);
      parseRegionsCopyrights(jsonResponse, stringBuffer);
      return stringBuffer.toString();
    }
    return "Can't get copyrights";
  }

  void parseRegionsCopyrights(jsonResponse, StringBuffer sb) {
    List<dynamic> copyrightsRegions = jsonResponse["regions"];
    copyrightsRegions.forEach((element) {
      sb.writeln(element["country"]["label"]);
      List<dynamic> cpy = element["copyrights"];
      cpy.forEach((e) {
        sb.writeln(e);
      });
      sb.writeln("");
    });
  }

  void parseGeneralCopyrights(jsonResponse, StringBuffer sb) {
    List<dynamic> generalCopyrights = jsonResponse["generalCopyrights"];
    generalCopyrights.forEach((element) {
      sb.writeln(element);
      sb.writeln("");
    });
    sb.writeln("");
  }
}
