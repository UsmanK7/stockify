//  Future<List<String>> getCountries() async {
//     try {
//       final db = await database;
//       final List<Map<String, dynamic>> countryMaps = await db.query('country');
//       return List.generate(countryMaps.length, (i) {
//         return countryMaps[i]['sCountryName'] as String;
//       });
//     } catch (e) {
//       print('Error getting countries: $e');
//       throw Exception('Failed to get countries from database');
//     }
//   }

//   Future<List<String>> getStates({required int countryID}) async {
//     try {
//       final db = await database;
//       final List<Map<String, dynamic>> stateMaps = await db
//           .query('state', where: 'countryID = ?', whereArgs: [countryID]);
//       return List.generate(stateMaps.length, (i) {
//         return stateMaps[i]['sStateName'] as String;
//       });
//     } catch (e) {
//       print('Error getting states: $e');
//       throw Exception('Failed to get states from database');
//     }
//   }

//   Future<List<String>> getCities({required int countryStateID}) async {
//     try {
//       final db = await database;
//       final List<Map<String, dynamic>> cityMaps = await db
//           .query('city', where: 'stateID = ?', whereArgs: [countryStateID]);
//       return List.generate(cityMaps.length, (i) {
//         return cityMaps[i]['sCityName'] as String;
//       });
//     } catch (e) {
//       print('Error getting cities: $e');
//       throw Exception('Failed to get cities from database');
//     }
//   }