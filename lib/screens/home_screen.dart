import 'package:flutter/material.dart';
import 'result_screen.dart';
import '../data/stops.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fromStopId; 
  String? toStopId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TramGo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "✨ اعرف تفاصيل رحلتك ✨",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: fromStopId,
              decoration: const InputDecoration(labelText: 'من'),
              items: stops
                  .map((stop) => DropdownMenuItem(
                        value: stop.id, // API uses stop.id
                        child: Text(stop.nameAr), // Display name for user
                      ))
                  .toList(),
              onChanged: (val) => setState(() => fromStopId = val),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: toStopId,
              decoration: const InputDecoration(labelText: 'إلى'),
              items: stops
                  .map((stop) => DropdownMenuItem(
                        value: stop.id, // API uses stop.id
                        child: Text(stop.nameAr),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => toStopId = val),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                if (fromStopId != null && toStopId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultScreen(
                        from: fromStopId!,
                        to: toStopId!,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("من فضلك اختر المحطتين")),
                  );
                }
              },
              child: const Text("عرفني"),
            )
          ],
        ),
      ),
    );
  }
}
