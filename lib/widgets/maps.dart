import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Coordinates for Islamabad
    final islamabadLocation = LatLng(33.6844, 73.0479);

    return Container(
      height: screenHeight * 0.45, // Adjust height as needed
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(30.3753, 69.3451), // Center of the map around Pakistan
          initialZoom: 6.0, // Adjust zoom level as needed
          onTap: (tapPosition, point) {
            // Handle map tap event here
            print('Map tapped at: $point');
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://api.maptiler.com/maps/basic/{z}/{x}/{y}.png?key=bEanfKClnutrxBwAgyhv',
            additionalOptions: {
              'tileSize': '512',
              'zoomOffset': '-1',
              'minZoom': '1',
              'tms': 'false',
            },
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: islamabadLocation,
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}