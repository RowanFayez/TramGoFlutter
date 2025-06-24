import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../data/stops.dart';

class NearestStationScreen extends StatefulWidget {
  @override
  State<NearestStationScreen> createState() => _NearestStationScreenState();
}

class _NearestStationScreenState extends State<NearestStationScreen> {
  Position? currentPosition;
  String? nearestStation;
  double? distance;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    setState(() {
      errorMessage = null;
      currentPosition = null;
      nearestStation = null;
      distance = null;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => errorMessage = "خدمة الموقع غير مفعلة");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() => errorMessage = "تم رفض إذن الموقع");
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final result = findNearestStop(pos.latitude, pos.longitude);

      setState(() {
        currentPosition = pos;
        nearestStation = result['name'];
        distance = result['distance'];
      });
    } catch (e) {
      setState(() => errorMessage = "تعذر الحصول على الموقع الحالي");
    }
  }

  Map<String, dynamic> findNearestStop(double lat, double lon) {
    double minDist = double.infinity;
    Stop? closest;

    for (final stop in stops) {
      final d = Geolocator.distanceBetween(lat, lon, stop.lat, stop.lon);
      if (d < minDist) {
        minDist = d;
        closest = stop;
      }
    }

    return {
      'name': closest?.nameAr ?? 'غير معروف',
      'distance': minDist,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("أقرب محطة")),
      body: errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 64, color: Colors.orangeAccent),
                  const SizedBox(height: 20),
                  Text(errorMessage!, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await Geolocator
                          .openLocationSettings();
                    },
                    child: const Text("فتح إعدادات الموقع"),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: getLocation,
                    child: const Text("إعادة المحاولة"),
                  )
                ],
              ),
            )
          : currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on,
                          size: 64, color: Colors.tealAccent),
                      const SizedBox(height: 16),
                      Text("أقرب محطة: $nearestStation",
                          style: const TextStyle(fontSize: 20)),
                      Text(
                          "المسافة التقريبية: ${distance?.toStringAsFixed(0)} متر",
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
    );
  }
}
