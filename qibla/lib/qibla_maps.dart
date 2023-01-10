import 'dart:async';

import 'package:core/widgets/loading_indicator.dart';
import 'package:core/widgets/location_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class QiblaMaps extends StatefulWidget {
  final meccaMarker = Marker(
    markerId: const MarkerId("mecca"),
    position: const LatLng(21.422487, 39.826206),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    draggable: false,
  );
  QiblaMaps({super.key});

  @override
  State<QiblaMaps> createState() => _QiblaMapsState();
}

class _QiblaMapsState extends State<QiblaMaps> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng position = const LatLng(36.800636, 10.180358);

  late Future<Position?> _future;
  final _positionStream = StreamController<LatLng>.broadcast();

  @override
  void initState() {
    _future = _checkLocationStatus();
    super.initState();
  }

  @override
  void dispose() {
    _positionStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position?>(
      future: _future,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }
        if (snapshot.hasError) {
          return LocationErrorWidget(
            error: snapshot.error.toString(),
          );
        }

        if (snapshot.data != null) {
          final loc = LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
          position = loc;
        } else {
          _positionStream.sink.add(position);
        }

        return StreamBuilder(
          stream: _positionStream.stream,
          builder: (_, AsyncSnapshot<LatLng> snapshot) => GoogleMap(
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            compassEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition(
              target: position,
              zoom: 11,
            ),
            markers: <Marker>{
              widget.meccaMarker,
              Marker(
                draggable: true,
                markerId: const MarkerId('Marker'),
                position: position,
                icon: BitmapDescriptor.defaultMarker,
                onTap: _updateCamera,
                onDragEnd: (LatLng value) {
                  position = value;
                  _positionStream.sink.add(value);
                },
                zIndex: 5,
              ),
            },
            circles: <Circle>{
              Circle(
                circleId: const CircleId("Circle"),
                radius: 10,
                center: position,
                fillColor: Theme.of(context).primaryColorLight.withAlpha(100),
                strokeWidth: 1,
                strokeColor: Theme.of(context).primaryColorDark.withAlpha(100),
                zIndex: 3,
              )
            },
            polylines: <Polyline>{
              Polyline(
                polylineId: const PolylineId("Line"),
                points: [position, const LatLng(21.422487, 39.826206)],
                color: Theme.of(context).primaryColor,
                width: 5,
                zIndex: 4,
              )
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        );
      },
    );
  }

  Future<Position?> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled) {
      return await Geolocator.getCurrentPosition();
    }
    return null;
  }

  void _updateCamera() async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(position, 20));
  }
}