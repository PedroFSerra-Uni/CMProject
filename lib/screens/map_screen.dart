import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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

  // Lista com morada + localização (sem coordenadas ainda)
  final List<Map<String, dynamic>> nearbyStalls = [
    {
      'id': '1',
      'name': 'Quinta do Zé',
      'morada': 'Rua A',
      'localizacao': 'Lisboa, Portugal',
      'produtos': ['Hortícolas', 'Frutas']
    },
    {
      'id': '2',
      'name': 'Horta da Maria',
      'morada': 'Av. B',
      'localizacao': 'Lisboa, Portugal',
      'produtos': ['Legumes', 'Ovos']
    },
    {
      'id': '3',
      'name': 'Banca do João',
      'morada': 'Travessa C',
      'localizacao': 'Lisboa, Portugal',
      'produtos': ['Queijos', 'Enchidos']
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
        errorMessage = 'Serviço de localização desativado.';
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
        errorMessage = 'Permissão permanentemente negada.';
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
        isLoading = false;
      });

      await _addStallMarkers();
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Erro ao obter localização: ${e.toString()}';
      });
    }
  }

  Future<void> _addStallMarkers() async {
    markers.clear();

    // Marcador da localização atual
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

    // Geocodificar cada banca e adicionar marcador
    for (var stall in nearbyStalls) {
      final endereco = '${stall['morada']}, ${stall['localizacao']}';
      try {
        List<Location> results = await locationFromAddress(endereco);
        if (results.isNotEmpty) {
          final location = results.first;
          final latLng = LatLng(location.latitude, location.longitude);

          markers.add(
            Marker(
              markerId: MarkerId(stall['id']),
              position: latLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              infoWindow: InfoWindow(
                title: stall['name'],
                snippet: stall['produtos'].join(', '),
              ),
              onTap: () => _showStallDetails(stall),
            ),
          );

          setState(() {}); // Atualiza o mapa a cada marcador
        }
      } catch (e) {
        print('Erro ao converter endereço: $endereco');
      }
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
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Morada: ${stall['morada']}'),
              Text('Localização: ${stall['localizacao']}'),
              const SizedBox(height: 8),
              const Text('Produtos:'),
              ...stall['produtos'].map<Widget>((p) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text('- $p'),
                  )),
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
                markers.clear();
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
            Text(errorMessage!, textAlign: TextAlign.center),
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
      onMapCreated: (controller) => mapController = controller,
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
