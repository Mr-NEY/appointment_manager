import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LandmarkService {
  static Future<String?> getNearbyLandmark(LatLng location) async {
    // Nominatim Reverse Geocoding URL
    // 'zoom=18' is high detail (building/landmark level)
    final url =
        'https://nominatim.openstreetmap.org/reverse'
        '?format=jsonv2'
        '&lat=${location.latitude}'
        '&lon=${location.longitude}'
        '&zoom=24'
        '&addressdetails=1';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent':
              'Appointment Manager App (contact: nayminnthank@gmail.com)',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // OSM returns 'name' for major landmarks, or parts of the 'address'
        if (data['display_name'] != null && data['display_name'] != "") {
          return data['display_name'];
        } else if (data['address'] != null) {
          // Fallback: Use the most specific part of the address
          final address = data['address'];
          return address['amenity'] ??
              address['building'] ??
              address['tourism'] ??
              address['road'];
        }
        return "Unknown Location";
      } else {
        if (kDebugMode) {
          print("OSM Error: ${response.statusCode}");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Network Error: $e");
      }
      return null;
    }
  }
}
