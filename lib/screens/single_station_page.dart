import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wa_fuel/models/fuel_station.dart';
import 'package:wa_fuel/style.dart';

///CLASS: SingleStationPage
///Displays info and location of a station
class SingleStationPage extends StatefulWidget {
  SingleStationPage({this.station}) : super();

  final FuelStation station;

  @override
  _SingleStationPageState createState() => _SingleStationPageState();
}

class _SingleStationPageState extends State<SingleStationPage>  {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.station.tradingName),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(widget.station.tradingName, style: ThemeText.textStationTitle,),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('${widget.station.address}, ${widget.station.locationName}', style: ThemeText.textStationNormal,),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    _launchTel(widget.station.phone);
                  },
                    child: Text(widget.station.phone, style: ThemeText.textStationNormal,),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 300,
                  child: GoogleMap(
                    rotateGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                      zoom: 15,
                      target: LatLng(
                        double.parse(widget.station.latitude),
                        double.parse(widget.station.longitude),
                      ),
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('temp'),
                        position: LatLng(
                          double.parse(widget.station.latitude),
                          double.parse(widget.station.longitude),
                        ),
                      ),
                    },
                  ),
                ),
              ),
              TextButton(child: Text('Get Directions'), onPressed: () {
                MapsLauncher.launchCoordinates(double.parse(widget.station.latitude), double.parse(widget.station.longitude));
              },)
            ],
          ),
        ],
      ),
    );
  }

  ///Opens telephone number in selected telephone application
  void _launchTel(String phoneNumber) async {
    await canLaunch('tel:$phoneNumber') ? launch('tel:$phoneNumber') : throw 'Could not launch "tel:$phoneNumber"';
  }
}
