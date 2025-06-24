import 'package:flutter/material.dart';

class TramLinesScreen extends StatelessWidget {
  final Map<String, dynamic>? routeData;

  const TramLinesScreen({this.routeData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("خطوط الترام المتاحة"),
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.tealAccent,
      ),
      body: routeData == null || routeData!['directRoutes'] == null
          ? const Center(child: Text("لا توجد خيارات متاحة"))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: routeData!['directRoutes'].length,
              itemBuilder: (context, index) {
                final route = routeData!['directRoutes'][index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  color: const Color(0xFF2C2C2C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "خط: ${route['line']}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.tealAccent,
                              ),
                            ),
                            Text(
                              "التكلفة: ${route['cost']} جنيه",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "الوقت: ${route['time']} دقيقة",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const Divider(color: Colors.tealAccent, thickness: 1),
                        ...route['fullSteps']
                            .map<Widget>((step) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(Icons.train,
                                      color: Colors.tealAccent),
                                  title: Text(
                                    step['stationName'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    "خط: ${step['line']} - ${step['action']}",
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
