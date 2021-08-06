import 'dart:async';
import 'dart:convert';


import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/models/country_code_response.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/debouncer.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';
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
  String firstLocation="";
  String secondVlaue="";
  CameraPosition? initialLocation;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  final _debouncer = Debouncer(600);
  Completer<GoogleMapController> _mapController = Completer();
  late BitmapDescriptor sourceIcon;
bool isSearching=false;
  @override
  initState() {
    super.initState();
    setSourceAndDestinationIcons();
  }
  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }
  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/appimages/locations.png');
  }
  void onsearchValueChanged(String text) {
    if (text.length < 3) {
      setState(() {
        isSearching = false;
      });
    }
    else {
      setState(() {
        isSearching = true;
      });
    }
  }

  void getCounrtyCode() async {


    Calls().getRequest(context, "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Museum%20of%20Contemporary%20Art%20Australia&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAle_QlZpymzB-DmbtpqHNrnZYyFQeNjwQ").then((value) async {
      if (value != null) {

        print(value);

        setState(() {});
      }
    }).catchError((onError) {

    });

  }


  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
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

SOURCE_LOCATION!=null?
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              markers: Set<Marker>.of(_markers.values),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: SOURCE_LOCATION,
                zoom: 12.0,
              ),
              myLocationEnabled: true,
              onCameraMove: (CameraPosition newPosition) async {
                if(_markers.length > 0) {
                  MarkerId markerId = MarkerId(_markerIdVal());
                  Marker? marker = _markers[markerId];
                  Marker updatedMarker = marker!.copyWith(
                    positionParam: newPosition.target,
                  );

                  setState(() {
                    _markers[markerId] = updatedMarker;
                  });
                }

                _debouncer.run(() async {
                  List<Placemark> placemarks = await placemarkFromCoordinates(newPosition.target.latitude, newPosition.target.longitude);
                  setState(() {
                    firstLocation=   placemarks[0].street.toString()+" ,"+ placemarks[0].administrativeArea.toString()+", "+ placemarks[0].subAdministrativeArea.toString();
                    secondVlaue=   placemarks[0].subLocality.toString()+" ,"+placemarks[0].country.toString()+"\n"+placemarks[0].postalCode.toString();

                  });
                });


                print(newPosition.target.latitude);

              },
            ),
          ):Container(),
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
Align(
  alignment: Alignment.topCenter,
  child:  Padding(
    padding: const EdgeInsets.only(top:80.0),
    child: Column(
      children: [
        SearchBox(
          onvalueChanged: onsearchValueChanged,
          hintText: AppLocalizations.of(context)!.translate('search'),
        ),

        Visibility(
          visible: isSearching,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: appCard(
              color: HexColor(AppColors.appColorWhite),
              child: Column(
                children: [
                  ListTile(
                    title:Text("Kauna"),
                    subtitle: Text("Plamapur,Himachal,Indoa"),

                  ),
                  ListTile(
                    title:Text("Delhi"),
                    subtitle: Text("Plamapur,Himachal,Indoa"),

                  ),
                  ListTile(
                    title:Text("Hamirpur"),
                    subtitle: Text("Plamapur,Himachal,Indoa"),

                  ),
                  ListTile(
                    title:Text("Jaisinhpur"),
                    subtitle: Text("Plamapur,Himachal,Indoa"),

                  ),
                  ListTile(
                    title:Text("Kolalampur"),
                    subtitle: Text("Plamapur,Himachal,Indoa"),

                  ),




                ],
              ),
            ),
          ),
        ),

      ],
    ),
  ),
),
          Align(
            alignment: Alignment.bottomCenter,
            child:  Container(
              height: 200,
              child: Visibility(
visible: firstLocation!="",
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: appCard(
                    color: HexColor(AppColors.appColorWhite),
                    child: Column(
                      children: [
                        ListTile(
                          title:Text(firstLocation, style: styleElements
                              .headline6ThemeScalable(context)
                              .copyWith(
                              fontWeight: FontWeight.bold,
                              color: HexColor(AppColors.appColorBlack85)),),
                          subtitle: Text(secondVlaue,style: styleElements
        .subtitle2ThemeScalable(context)
      ),),







                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    if ([SOURCE_LOCATION] != null) {
      MarkerId markerId = MarkerId(_markerIdVal());
      LatLng position = SOURCE_LOCATION;
      Marker marker = Marker(
        markerId: markerId,
        position: position,
        draggable: false,
      );
      setState(() {
        _markers[markerId] = marker;
      });

      Future.delayed(Duration(seconds: 1), () async {
        GoogleMapController controller = await _mapController.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: position,
              zoom: 17.0,
            ),
          ),
        );
      });
    }
  }

  void setMapPins() {
    setState(() {
      // source pin


     /* _markers.add( Marker(
          onTap: () {
            ToastBuilder().showToast(
                "chanfed", context, HexColor(AppColors.information));
            print('Tapped');
          },
          draggable: true,
          icon: sourceIcon,
          markerId: MarkerId('Marker'),
          position: SOURCE_LOCATION,
          onDragEnd: ((newPosition) async {


            List<Placemark> placemarks = await placemarkFromCoordinates(newPosition.latitude, newPosition.longitude);

            ToastBuilder().showToast(
                "${placemarks[0].name} : ${placemarks[0].locality}", context, HexColor(AppColors.information));

            setState(() {
              firstLocation=   placemarks[0].street.toString();
              secondVlaue=   placemarks[0].subLocality.toString()+" "+placemarks[0].country.toString()+"\n"+placemarks[0].postalCode.toString();

            });

            print(newPosition.latitude);
            print(newPosition.longitude);
          })));*/
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
