import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List of stations with their coordinates
  final List<Map<String, dynamic>> stations = [
    {
      'name': 'Campo Sioco Jeepney Station',
      'coordinates': LatLng(16.40152, 120.59051),
    },
    {
      'name': 'Gabriela Silang Jeepney Station',
      'coordinates': LatLng(16.39628, 120.60492),
    },
    {
      'name': 'Green Valley Jeepney Terminal',
      'coordinates': LatLng(16.41368, 120.59348),
    },
  ];

  // Controller for the map
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Row(
        children: [
          // Reduced height for the List of stations
          Container(
            width: 200,
            color: Colors.blueGrey.withOpacity(0.4), // Fixed width for the ListView
            child: ListView.builder(
              itemCount: stations.length,
              itemBuilder: (context, index) {
                final station = stations[index];
                return ListTile(
                  title: Text(station['name']),
                  onTap: () {
                    // Zoom into the selected station
                    mapController.move(station['coordinates'], 17.2);
                  },
                );
              },
            ),
          ),
          // Map
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: const MapOptions(
                    initialCenter: LatLng(16.397248543178023, 120.59632312999167),
                    initialZoom: 17.2,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: stations.map((station) {
                        return buildMarker(station['coordinates'], station['name']);
                      }).toList(),
                    ),
                  ],
                ),
                // Recenter button
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      // Recenter the map to the initial position
                      mapController.move(
                        LatLng(16.397248543178023, 120.59632312999167),
                        17.2,
                      );
                    },
                    backgroundColor: Colors.deepPurple,
                    child: const Icon(Icons.my_location, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Marker buildMarker(LatLng coordinates, String name) {
    return Marker(
      point: coordinates,
      width: 200, // Reduced width
      height: 50, // Reduced height
      child: buildTextWidget(name),
    );
  }

  Container buildTextWidget(String word) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        word,
        textAlign: TextAlign.center,
        style: getDefaultTextStyle(),
      ),
    );
  }

  TextStyle getDefaultTextStyle() {
    return TextStyle(
      fontSize: 15, // Reduced font size
      backgroundColor: Colors.blue.withOpacity(0.8),
      color: Colors.white,
    );
  }
}
