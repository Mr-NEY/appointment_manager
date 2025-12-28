import 'package:appointment_manager/data/services/api_services/landmark_service.dart';
import 'package:appointment_manager/domain/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? mapController;
  LatLng? selectedLocation;
  String selectedAddress = '';
  bool locationGranted = false;
  bool locationLoaded = false;
  LatLng initialLocation = const LatLng(16.8661, 96.1951);

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      setState(() {
        locationGranted = true;
      });

      Position position = await Geolocator.getCurrentPosition();
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng, 15),
      );

      _getAddressFromLatLng(currentLatLng);
    }

    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required.')),
      );
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDialog();
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      final landmark = await LandmarkService.getNearbyLandmark(position);

      if (landmark != null) {
        setState(() {
          selectedAddress = landmark;
          locationLoaded = true;
        });
        return;
      }

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          selectedAddress =
              '${place.street}, ${place.subLocality}, ${place.locality}'.trim();
          locationLoaded = true;
        });
      }
    } catch (e) {
      debugPrint('Reverse geocode error: $e');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Please enable location permission from app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestLocationPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          TextButton(
            onPressed: !locationLoaded
                ? null
                : () {
                    Navigator.pop(
                      context,
                      LocationModel(
                        latitude: selectedLocation!.latitude,
                        longitude: selectedLocation!.longitude,
                        address: selectedAddress,
                      ),
                    );
                  },
            child: Text(
              'DONE',
              style: TextStyle(
                color: locationLoaded ? Colors.blue : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            compassEnabled: true,
            initialCameraPosition: CameraPosition(
              target: initialLocation,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              mapController = controller;
            },
            myLocationEnabled: locationGranted,
            myLocationButtonEnabled: locationGranted,
            onTap: (latLng) async {
              setState(() {
                locationLoaded = false;
                selectedLocation = latLng;
              });
              await _getAddressFromLatLng(latLng);
            },
            markers: selectedLocation == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('selected_location'),
                      position: selectedLocation!,
                    ),
                  },
          ),
          if (selectedAddress.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 10,
              right: 10,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    selectedAddress,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
