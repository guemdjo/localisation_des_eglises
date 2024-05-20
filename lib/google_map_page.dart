import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  var locationController = Location();
  final googlePlex = LatLng(37.4223, -122.0848);
  late StreamSubscription _getPositionSubscription;
  final box = GetStorage();
  final CameraPosition _KGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<void> initializeMap() async {
    await fetchLocationUpdates();
    final coordinates = await fetchPolylinePoints();
    generatePolyLineFromPoints(coordinates);
  }

  Future<void> fetchLocationUpdates() async {
    _getPositionSubscription =
        locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        box.write("currentLatitude", currentLocation.latitude!);
        box.write("currentlongitude", currentLocation.longitude!);
        setState(() {
          currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
        print("Current Position ${currentLocation}");
      }
    });
  }

  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {};

  final mountainView = const LatLng(4.055503192359394, 9.695375698985707);

  final CameraPosition _KLake = const CameraPosition(
    bearing: 192.83334901395799,
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await initializeMap());
  }

  @override
  Widget build(BuildContext context) {
    return currentPosition == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentPosition!,
              zoom: 13,
            ),
            markers: {
              Marker(
                markerId: MarkerId('currentLocation'),
                icon: BitmapDescriptor.defaultMarker,
                position: currentPosition!,
              ),
              Marker(
                markerId: MarkerId('destinationLocation'),
                icon: BitmapDescriptor.defaultMarker,
                position: mountainView,
              ),
            },
            polylines: Set<Polyline>.of(polylines.values),
          );
  }

  Future<List<LatLng>> fetchPolylinePoints() async {
    final polylinePoints = PolylinePoints();
    final result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyD2Co5HrGYkPXOn9nliHe5xi9FtR17LdOc',
        PointLatLng(box.read('currentLatitude'), box.read('currentlongitude')),
        PointLatLng(mountainView.latitude, mountainView.longitude));

    if (result.points.isNotEmpty) {
      print(result.points);
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      debugPrint(result.errorMessage);
      return [];
    }
  }

  Future<void> generatePolyLineFromPoints(
      List<LatLng> polylineCoordinates) async {
    const id = PolylineId('polyline');

    final polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 5);

    setState(() {
      polylines[id] = polyline;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _getPositionSubscription?.cancel();
    super.dispose();
  }
}
