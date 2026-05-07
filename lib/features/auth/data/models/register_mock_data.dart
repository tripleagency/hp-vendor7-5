/// Mock city/area data (to be replaced with lookups API later)
class CityMockData {
  static const List<Map<String, dynamic>> cities = [
    {'id': 1, 'name': 'Cairo'},
    {'id': 2, 'name': 'Giza'},
    {'id': 3, 'name': 'Alexandria'},
    {'id': 4, 'name': 'Mansoura'},
  ];

  static const Map<int, List<Map<String, dynamic>>> areas = {
    1: [
      {'id': 1, 'name': 'Nasr City'},
      {'id': 2, 'name': 'Heliopolis'},
      {'id': 3, 'name': 'Maadi'},
      {'id': 4, 'name': 'New Cairo'},
      {'id': 5, 'name': 'Downtown'},
    ],
    2: [
      {'id': 6, 'name': 'Dokki'},
      {'id': 7, 'name': 'Mohandessin'},
      {'id': 8, 'name': '6th of October'},
    ],
    3: [
      {'id': 9, 'name': 'Smouha'},
      {'id': 10, 'name': 'Miami'},
      {'id': 11, 'name': 'Montazah'},
    ],
    4: [
      {'id': 12, 'name': 'Mansoura Center'},
      {'id': 13, 'name': 'Talkha'},
    ],
  };
}
