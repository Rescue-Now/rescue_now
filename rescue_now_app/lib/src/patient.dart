class Patient {
  String id;
  String firstName;
  String lastName;
  int age;
  String bloodGroup;
  List<String> knownAllergies;
  List<String> conditions;
  List<String> medicalHistory;
  double longitude;
  double latitude;

  Patient({
    this.id = 'gol lol',
    this.latitude = -0.0,
    this.longitude = -0.0,
    this.firstName= '',
    this.lastName = '',
    this.age = 0,
    this.bloodGroup = '',
    this.knownAllergies = const [],
    this.conditions = const [],
    this.medicalHistory = const [],
  });

  // Convert a Patient object to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'bloodGroup': bloodGroup,
      'knownAllergies': knownAllergies,
      'conditions': conditions,
      'medicalHistory': medicalHistory,
    };
  }

  // Create a Patient object from a Map
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? 'gol lol',
      firstName: json['firstName'],
      lastName: json['lastName'],
      age: json['age'],
      bloodGroup: json['bloodGroup'],
      knownAllergies: List<String>.from(json['knownAllergies']),
      conditions: List<String>.from(json['conditions']),
      medicalHistory: List<String>.from(json['medicalHistory']),
    );
  }

  //create a Map from a Patient
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'bloodGroup': bloodGroup,
      'knownAllergies': knownAllergies,
      'conditions': conditions,
      'medicalHistory': medicalHistory,
    };
  }
}
