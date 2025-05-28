import 'package:flutter/material.dart';
import '../services/api_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<String> countries = [
    'Bangladesh',
    'China',
    'Japan',
    'South Korea',
  ];

  final Map<String, List<String>> citiesByCountry = {
    'Bangladesh': ['Dhaka', 'Chittagong', 'Khulna', 'Sylhet', 'Rajshahi'],
    'China': ['Beijing', 'Shanghai', 'Guangzhou', 'Shenzhen', 'Chengdu'],
    'Japan': ['Tokyo', 'Osaka', 'Kyoto', 'Hiroshima', 'Nagoya'],
    'South Korea': ['Seoul', 'Busan', 'Incheon', 'Daegu', 'Daejeon'],
  };

  String? selectedCountry;
  String? selectedCity;
  bool isLoading = false;
  List<dynamic> spots = [];
  String? errorMessage;

  void _findSpots() async {
    if (selectedCountry == null || selectedCity == null) {
      setState(() {
        errorMessage = 'Please select both country and city.';
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = null;
      spots = [];
    });
    final result = await ApiService.getLocations(selectedCountry!, selectedCity!);
    setState(() {
      isLoading = false;
      if (result['success']) {
        spots = result['locations'] ?? [];
        if (spots.isEmpty) {
          errorMessage = 'No spots found for this city.';
        }
      } else {
        errorMessage = result['message'] ?? 'Failed to fetch spots.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D5DF6), Color(0xFF3D8BFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                // Header with icon and title
                Row(
                  children: [
                    // App logo or icon
//                    CircleAvatar(
//                      radius: 30,
//                      backgroundColor: Colors.white,
//                      child: Icon(Icons.travel_explore, size: 36, color: Color(0xFF6D5DF6)),
//                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Spot Finder',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Card for form
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Select Country',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.flag),
                          ),
                          value: selectedCountry,
                          items: countries
                              .map((country) => DropdownMenuItem(
                                    value: country,
                                    child: Text(country),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCountry = value;
                              selectedCity = null;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Select City',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.location_city),
                          ),
                          value: selectedCity,
                          items: (selectedCountry == null
                                  ? <String>[]
                                  : citiesByCountry[selectedCountry!] ?? [])
                              .map((city) => DropdownMenuItem(
                                    value: city,
                                    child: Text(city),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCity = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _findSpots,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6D5DF6),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Find Spots', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 16)),
                  ),
                if (spots.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: spots.length,
                      itemBuilder: (context, index) {
                        final spot = spots[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn,
                          child: Card(
                            elevation: 8,
                            margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: spot['image_url'] != null
                                          ? FadeInImage.assetNetwork(
                                              placeholder: 'assets/placeholder.png',
                                              image: spot['image_url'],
                                              width: double.infinity,
                                              height: 140,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: double.infinity,
                                              height: 140,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image, size: 60),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          spot['place_name'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF3D8BFF),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Chip(
                                              label: Text(
                                                selectedCountry ?? '',
                                                style: const TextStyle(color: Colors.white),
                                              ),
                                              backgroundColor: const Color(0xFF6D5DF6),
                                            ),
                                            const SizedBox(width: 8),
                                            Chip(
                                              label: Text(
                                                selectedCity ?? '',
                                                style: const TextStyle(color: Colors.white),
                                              ),
                                              backgroundColor: const Color(0xFF3D8BFF),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 