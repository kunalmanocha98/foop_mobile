import 'dart:async';

import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;

class MapPage extends StatefulWidget {
  final LatLng SOURCE_LOCATION;
  final double? lat;
  final double? long;

  @override
  State<StatefulWidget> createState() =>
      MapPageState(this.SOURCE_LOCATION, this.lat, this.long);

  MapPage(
    this.SOURCE_LOCATION,
    this.lat,
    this.long,
  );
}

class MapPageState extends State<MapPage> {
  final double? lat;
  final double? long;
  LatLng SOURCE_LOCATION;
  CameraPosition? initialLocation;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  late BitmapDescriptor sourceIcon;

  @override
  initState() {
    super.initState();
    setSourceAndDestinationIcons();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/appimages/locations.png');
  }

  @override
  Widget build(BuildContext context) {
    if (SOURCE_LOCATION != null) {
      initialLocation = CameraPosition(
          zoom: CAMERA_ZOOM,
          bearing: CAMERA_BEARING,
          tilt: CAMERA_TILT,
          target: SOURCE_LOCATION);
    }

    return Scaffold(

      body: Stack(
        children: [


          initialLocation != null
              ? GoogleMap(
                  myLocationEnabled: true,
                  compassEnabled: true,
                  tiltGesturesEnabled: false,
                  markers: _markers,
                  mapType: MapType.terrain,
                  initialCameraPosition: initialLocation!,
                  onMapCreated: onMapCreated)
              : Container(),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left :20.0,top: 50.0),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).pop({'result': "update"});
                },
                child: Icon(
                  Icons.keyboard_backspace_rounded,
                  size: 20.0,
                  color: HexColor(AppColors.appColorBlack),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 100.0),
              child: GestureDetector(
                onTap: () {
                  String googleUrl =
                      'https://www.google.com/maps/search/?api=1&query=$lat,$long';
                  if (canLaunch(googleUrl) != null) {
                    launch(googleUrl);
                  } else {
                    throw 'Could not open the map.';
                  }
                },
                child: Container(
                  child: Icon(
                    Icons.directions,
                    size: 52,
                    color: HexColor(AppColors.appColorBlack),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);
    setMapPins();
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: SOURCE_LOCATION,
          icon: sourceIcon));
    });
  }

  MapPageState(
    this.SOURCE_LOCATION,
    this.lat,
    this.long,
  );
}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
