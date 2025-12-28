import 'package:url_launcher/url_launcher.dart';

class MapLauncherHelper {
  static Future<void> openGoogleMaps({
    required double latitude,
    required double longitude,
  }) async {
    final query = '$latitude,$longitude';

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open Google Maps';
    }
  }
}
