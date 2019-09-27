// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final tomtomHQ = new LatLng(52.376372, 4.908066);

    return MaterialApp(
      title: 'TomTom Map',
      home: Scaffold(
        appBar: AppBar(
          title: Text('TomTom Map with Flutter Map Package'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Image.asset(
                  'images/maps_apis_logo.png'
              ),
              Expanded(
                child: FlutterMap(
                  options: new MapOptions(
                    center: tomtomHQ,
                    zoom: 13.0,
                  ),
                  layers: [
                    new TileLayerOptions(
                      urlTemplate: "https://api.tomtom.com/map/1/tile/basic/main/"
                          "{z}/{x}/{y}.png?key={apiKey}",
                      additionalOptions: {
                        'apiKey': 'YOUR_API_KEY',
                      },
                    ),
                  ],
                )
              ),
            ],
          )
        ),
      ),
    );
  }
}
