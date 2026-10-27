class Ambulance {
  final String id;
  final String name;
  final String location;
  final String charges;
  final bool available;

  Ambulance({
    required this.id,
    required this.name,
    required this.location,
    required this.charges,
    required this.available,
  });

  factory Ambulance.fromFirestore(Map<String, dynamic> data) {
    return Ambulance(
      id: data['id'],
      name: data['name'],
      location: data['location'],
      charges: data['charges'],
      available: data['available'],
    );
  }
}
