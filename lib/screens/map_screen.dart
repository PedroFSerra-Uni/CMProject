import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Position? currentPosition;
  final Set<Marker> markers = {};
  bool isLoading = true;
  String? errorMessage;

  final List<Map<String, dynamic>> nearbyStalls = [
    {
      'id': '1',
      'name': 'Quinta do Zé',
      'position': const LatLng(38.7071, -9.13549),
      'distance': 0.5,
      'products': ['Hortícolas', 'Frutas']
    },
    {
      'id': '2',
      'name': 'Horta da Maria',
      'position': const LatLng(38.7102, -9.1367),
      'distance': 1.2,
      'products': ['Legumes', 'Ovos']
    },
    {
      'id': '3',
      'name': 'Banca do João',
      'position': const LatLng(38.7053, -9.1328),
      'distance': 0.8,
      'products': ['Queijos', 'Enchidos']
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkLocationPermissions();
  }

  Future<void> _checkLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        isLoading = false;
        errorMessage = 'Serviço de localização desativado. Por favor, ative nas configurações.';
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          isLoading = false;
          errorMessage = 'Permissão de localização negada.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        isLoading = false;
        errorMessage = 'Permissão permanentemente negada. Ative nas configurações do app.';
      });
      return;
    }

    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPosition = position;
        _updateMarkers();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Erro ao obter localização: ${e.toString()}';
      });
    }
  }

  void _updateMarkers() {
    markers.clear();

    if (currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Sua Localização'),
        ),
      );
    }

    for (var stall in nearbyStalls) {
      markers.add(
        Marker(
          markerId: MarkerId(stall['id']),
          position: stall['position'],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(
            title: stall['name'],
            snippet: '${stall['distance']} km - ${stall['products'].join(', ')}',
          ),
          onTap: () => _showStallDetails(stall),
        ),
      );
    }
  }

  void _showStallDetails(Map<String, dynamic> stall) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stall['name'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Distância: ${stall['distance']} km'),
              const SizedBox(height: 8),
              const Text('Produtos:'),
              ...stall['products'].map<Widget>((product) =>
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('- $product'),
                ),
              ).toList(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ver Detalhes'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bancas Próximas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
                errorMessage = null;
              });
              _checkLocationPermissions();
            },
          ),
        ],
      ),
      body: _buildMapContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentPosition != null) {
            mapController.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(currentPosition!.latitude, currentPosition!.longitude),
              ),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildMapContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 50, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Geolocator.openLocationSettings(),
              child: const Text('Abrir Configurações'),
            ),
          ],
        ),
      );
    }

    if (currentPosition == null) {
      return const Center(child: Text('Localização não disponível'));
    }

    return GoogleMap(
      onMapCreated: (controller) {
        mapController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
        zoom: 14,
      ),
      markers: markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      onTap: (LatLng position) {},
    );
  }
}
