class BranchAtmModel {
  final String id;
  final String name;
  final String type; // 'BRANCH' or 'ATM'
  final String address;
  final double lat;
  final double lng;
  final bool isActive;
  final List<String> services;
  final String? phone;
  final String workingHours;

  BranchAtmModel({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.lat,
    required this.lng,
    required this.isActive,
    required this.services,
    this.phone,
    required this.workingHours,
  });

  factory BranchAtmModel.fromJson(Map<String, dynamic> json) {
    return BranchAtmModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      address: json['address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      isActive: json['is_active'] as bool? ?? false,
      services: json['services'] != null
          ? List<String>.from(json['services'] as List)
          : [],
      phone: json['phone'] as String?,
      workingHours: json['working_hours'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'address': address,
      'lat': lat,
      'lng': lng,
      'is_active': isActive,
      'services': services,
      'phone': phone,
      'working_hours': workingHours,
    };
  }

  bool get isBranch => type.toUpperCase() == 'BRANCH';
  bool get isAtm => type.toUpperCase() == 'ATM';
}

