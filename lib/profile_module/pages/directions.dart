import 'dart:async';
import 'dart:convert';


import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/models/country_code_response.dart';
import 'package:oho_works_app/models/latlogfromaddress.dart';
import 'package:oho_works_app/models/locationDataresponse.dart';
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


import 'package:geolocator/geolocator.dart';


const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;

class MapPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() =>
      MapPageState();

  MapPage(

  );
}

class MapPageState extends State<MapPage> {
    double? lat=0;
    double? long=0;
   LatLng SOURCE_LOCATION=LatLng(0, 0);
  String firstLocation="";
  bool isSuggestionsVisible=false;
  String secondVlaue="";
  CameraPosition? initialLocation;
    GoogleMapController ?_controller ;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
    List<Predictions> ?predictions;
  final _debouncer = Debouncer(600);
  Completer<GoogleMapController> _mapController = Completer();
  late BitmapDescriptor sourceIcon;
bool isSearching=false;
    GoogleMap? map;


  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;



  @override
  initState() {
    super.initState();
    _getCurrentPosition();
    setSourceAndDestinationIcons();
  }
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
   setState(() {

     print(position.latitude.toString()+"-------------------------------------------------++++++");
     lat=position.latitude;
     long=position.longitude;
     SOURCE_LOCATION=LatLng(lat!, long!);
   });
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();


    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {


        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {

      return false;
    }


    return true;
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
        isSuggestionsVisible=false;
        isSearching = false;
      });

    }
    else {
      _debouncer.run(() {
        getSuggestions(text);
      });
      setState(() {
        isSearching = true;
      });
    }
  }

  void getSuggestions(
      String searchVal
      ) async {
var apiKey="AIzaSyAle_QlZpymzB-DmbtpqHNrnZYyFQeNjwQ";
    final request = "https://maps.googleapis.com/maps/api/place/queryautocomplete/json?key=$apiKey&input=$searchVal&types=address";
    Calls().getRequest(context, request).then((value) async {
      if (value != null) {
        var data = LocationsData.fromJson(value);
        print(value);

        setState(() {
          predictions=data.predictions??[];
          if(predictions!=null && predictions!.isNotEmpty)
            isSuggestionsVisible=true;
        });
      }
    }).catchError((onError) {

    });

  }

    void getLatLon(
        String address
        ) async {
      var apiKey="AIzaSyAle_QlZpymzB-DmbtpqHNrnZYyFQeNjwQ";
      final request = "https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey";
      Calls().getRequest(context, request).then((value) async {
        if (value != null) {
          var data = LatLongAddress.fromJson(value);
          print(value);

          setState(() {
            firstLocation=data.results![0].formattedAddress!;
secondVlaue="";
            lat=data.results![0].geometry!.location!.lat;
            long=data.results![0].geometry!.location!.lng;
            SOURCE_LOCATION=LatLng(lat!, long!);

            _moveTo(lat!,long!);

          });
        }
      }).catchError((onError) {

      });

    }

    _moveTo(double latitude, double longitude) async {

    print(latitude.toString()+"--------------------66t78ehionrivrrvrvrvrvrvrvrv");

      await _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 16,
          ),
        ),
      );
    }
  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    if (lat!=0  && long !=0) {
      initialLocation = CameraPosition(
          zoom: CAMERA_ZOOM,
          bearing: CAMERA_BEARING,
          tilt: CAMERA_TILT,
          target: SOURCE_LOCATION);



      map= GoogleMap(
        markers: Set<Marker>.of(_markers.values),
        onMapCreated: _onMapCreated,
        initialCameraPosition:initialLocation!,
        myLocationEnabled: false,


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
      );
      return Scaffold(

        body: Stack(
          children: [

            lat!=0?
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child:
map


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
                      clearText: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.cancel_outlined,color: HexColor(AppColors.appMainColor),size: 30,),
                        ),
                      ),
                      onvalueChanged: onsearchValueChanged,
                      hintText: AppLocalizations.of(context)!.translate('search'),
                    ),

                    Visibility(
                      visible: isSearching && isSuggestionsVisible,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: appCard(
                          color: HexColor(AppColors.appColorWhite),
                          child:predictions!=null && predictions!.isNotEmpty? SizedBox(
                            height: 300,
                            child: ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: predictions!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: (){
                                      setState(() {
                                        //firstLocation=predictions![index].structuredFormatting!.mainText!;
                                        //secondVlaue=predictions![index].structuredFormatting!.secondaryText!;
                                        isSuggestionsVisible=false;
                                        getLatLon(predictions![index].description!);
                                      });

                                    },
                                    child: ListTile(
                                      title: Text(predictions![index].structuredFormatting!.mainText!),
                                      subtitle: Text(predictions![index].structuredFormatting!.secondaryText!),
                                    ),
                                  );
                                }
                            ),
                          ):Container(),
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
                  visible: !isSuggestionsVisible,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: appCard(
                      color: HexColor(AppColors.appColorWhite),
                      child: Stack(
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
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                                child: Text(AppLocalizations.of(context)!.translate("next")),
                                onPressed: () {
                                  print('Pressed');
                                }
                            ),
                          )

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
    return Container();

  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller=controller;
    _mapController.complete(controller);
    if (lat!=0) {
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




}


