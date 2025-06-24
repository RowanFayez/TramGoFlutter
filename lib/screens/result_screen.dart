import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'tram_lines_screen.dart';

class ResultScreen extends StatefulWidget {
  final String from;
  final String to;

  const ResultScreen({required this.from, required this.to});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Map<String, dynamic>? routeData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRoute();
  }

  Future<void> fetchRoute() async {
    try {
      if (widget.from.isEmpty || widget.to.isEmpty) {
        throw Exception('المعرفات (start/end) فارغة');
      }

      final uri = Uri(
        scheme: 'http',
        // host: '192.168..', if using real mobile simulation
        host: '10.0.2.2', //if using elimenator android studio
        port: 3000,
        path: '/getPath',
        queryParameters: {
          'start': widget.from,
          'end': widget.to,
          'mode': 'precomputed',
        },
      );
      print("Requesting URI: $uri");
  

      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['found'] == true && data['optimalRoute'] != null) {
          setState(() {
            routeData = data;
            isLoading = false;
          });
        } else {
          setState(() {
            routeData = data;
            isLoading = false;
          });
        }
      } else {
        throw Exception('خطأ في الاتصال: ${res.statusCode} - ${res.body}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (e.toString().contains('SocketException')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('الخادم غير متاح. تأكد من تشغيل Docker.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تفاصيل رحلتك")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : routeData == null
              ? const Center(child: Text("لم يتم العثور على مسار"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Text(
                        "${widget.from} ➝ ${widget.to}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      if (routeData!['optimalRoute'] != null) ...[
                        Text(
                          "الوقت التقديري: ${routeData!['optimalRoute']['time']} دقيقة",
                        ),
                        Text(
                          "عدد المحطات: ${routeData!['optimalRoute']['fullSteps'].length - 1}",
                        ),
                        Text(
                          "السعر: ${routeData!['optimalRoute']['cost']} جنيه",
                        ),
                        const Divider(),
                        ...routeData!['optimalRoute']['fullSteps']
                            .map<Widget>((step) => ListTile(
                                  title: Text(step['stationName']),
                                  subtitle: Text(
                                      "خط: ${step['line']} - ${step['action']}"),
                                ))
                            .toList(),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TramLinesScreen(routeData: routeData),
                              ),
                            );
                          },
                          child: const Text("عرض جميع الخيارات"),
                        ),
                      ] else ...[
                        Text(
                          "لم يتم العثور على مسار: ${routeData!['message'] ?? 'لا يوجد مسار'}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}
