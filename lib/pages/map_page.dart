import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oua_bootcamp/repositories/repo_business_detail.dart';

class GoogleMaps extends ConsumerWidget {
  late GoogleMapController mapController;
  final Set<Marker> markers = new Set();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessRepoProvider = ref.watch(businessDetailPageProvider);
    LatLng showLocation = LatLng(double.parse(businessRepoProvider.address),
        double.parse(businessRepoProvider.subtitle));

    //latitude , longitude

    return Scaffold(
      appBar: AppBar(
        title: Text(businessRepoProvider.companyName),
        automaticallyImplyLeading: true,
      ),
      body: GoogleMap(
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: showLocation,
          zoom: 15.0,
        ),
        markers: getmarkers(businessRepoProvider, showLocation),
        mapType: MapType.normal,
      ),
    );
  }

  Set<Marker> getmarkers(
      BusinessDetailRepository businessRepoProvider, showLocation) {
    markers.add(Marker(
      markerId: MarkerId(showLocation.toString()),
      position: showLocation,
      infoWindow: InfoWindow(
          title: businessRepoProvider.companyName,
          snippet: businessRepoProvider.address),
      icon: BitmapDescriptor.defaultMarker,
    ));

    return markers;
  }
}
