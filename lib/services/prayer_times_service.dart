import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';

class PrayerTimesService {
  static Future<PrayerTimes?> getPrayerTimes() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Fallback to Ashgabat coordinates if permission is denied
          return _calculateForCoords(37.95, 58.38);
        }
      }

      final position = await Geolocator.getCurrentPosition().timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('Location timeout'),
      );
      return _calculateForCoords(position.latitude, position.longitude);
    } catch (e) {
      // Fallback to Ashgabat coordinates if location fails
      return _calculateForCoords(37.95, 58.38);
    }
  }

  static PrayerTimes _calculateForCoords(double lat, double lng) {
    final coordinates = Coordinates(lat, lng);
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;
    return PrayerTimes.today(coordinates, params);
  }
}
