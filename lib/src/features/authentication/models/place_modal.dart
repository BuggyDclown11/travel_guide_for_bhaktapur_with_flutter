import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../constants/constants.dart';

class PlaceInfo {
  final String imageUrl, name, desc, address, city, title, latitude, longitude;
  final int id;
  final String? videoUrl;

  PlaceInfo(
      {required this.id,
      required this.name,
      required this.address,
      required this.city,
      required this.imageUrl,
      required this.desc,
      required this.title,
      required this.latitude,
      required this.longitude,
      this.videoUrl});

  factory PlaceInfo.fromJson(Map<String, dynamic> json) {
    return PlaceInfo(
      title: json['title'] ?? '',
      id: json['TempleID'] ?? 0,
      name: json['Name'] ?? '',
      address: json['Address'] ?? '',
      city: json['City'] ?? '',
      imageUrl: json['ImageURL'] ?? '',
      desc: json['Description'] ?? '',
      latitude: json['Latitude'] ?? '',
      longitude: json['Longitude'] ?? '',
    );
  }
}

class PlacesService {
  // List<PlaceInfo> places = [];
  Future<List<PlaceInfo>> getTemples() async {
    List<PlaceInfo> temples = [];
    final String url = ApiString.showTemple;

    var response = await http.get(Uri.parse(url));
    var results = jsonDecode(response.body);

    for (var result in results) {
      PlaceInfo place = PlaceInfo.fromJson(result);
      temples.add(place);
    }

    return temples;
  }

  Future<List<PlaceInfo>> getPonds() async {
    List<PlaceInfo> ponds = [];
    final String url = ApiString.showPond;

    var response = await http.get(Uri.parse(url));
    var results1 = jsonDecode(response.body);

    for (var result in results1) {
      PlaceInfo place = PlaceInfo.fromJson(result);
      ponds.add(place);
    }

    return ponds;
  }

  Future<List<PlaceInfo>> getchowks() async {
    List<PlaceInfo> chowks = [];
    final String url = ApiString.showChwoks;

    var response = await http.get(Uri.parse(url));
    var results = jsonDecode(response.body);

    for (var result in results) {
      PlaceInfo place = PlaceInfo.fromJson(result);
      chowks.add(place);
    }

    return chowks;
  }

  Future<List<PlaceInfo>> getmeseums() async {
    List<PlaceInfo> meseums = [];
    final String url = ApiString.showMueseum;

    var response = await http.get(Uri.parse(url));
    var results2 = jsonDecode(response.body);

    for (var result in results2) {
      PlaceInfo place = PlaceInfo.fromJson(result);
      meseums.add(place);
    }

    return meseums;
  }

  Future<List<PlaceInfo>> getstatues() async {
    List<PlaceInfo> statues = [];
    final String url = ApiString.showStatue;

    var response = await http.get(Uri.parse(url));
    var results1 = jsonDecode(response.body);

    for (var result in results1) {
      PlaceInfo place = PlaceInfo.fromJson(result);
      statues.add(place);
    }

    return statues;
  }

  Future<List<PlaceInfo>> getAllEvents() async {
    List<PlaceInfo> events = [];
    final String url = ApiString.showEvents;

    var response = await http.get(Uri.parse(url));
    var results = jsonDecode(response.body);

    for (var result in results) {
      // Perform null checks for each property before assigning the values
      PlaceInfo event = PlaceInfo.fromJson(result);
      events.add(event);
    }

    return events;
  }

  Future<List<PlaceInfo>> getUpcomingEvents() async {
    List<PlaceInfo> upcomingEvents = [];
    final String url = ApiString.showUpcomingEvents;

    var response = await http.get(Uri.parse(url));
    var results = jsonDecode(response.body);

    for (var result in results) {
      // Perform null checks for each property before assigning the values
      PlaceInfo event = PlaceInfo.fromJson(result);
      upcomingEvents.add(event);
    }

    return upcomingEvents;
  }

  Future<List<PlaceInfo>> getFavTempleDetails(String uid) async {
    final response = await http.post(
      Uri.parse("http://192.168.1.66/api/show_userFav.php"),
      body: {
        'uid': uid,
      },
    );
    var results = jsonDecode(response.body);

    List<int> templeIds = [];
    for (var result in results) {
      int templeId = result['TempleID'] ?? 0;
      templeIds.add(templeId);
    }

    // Fetch details for all the temples using Future.wait
    List<PlaceInfo?> getFavTemple = await Future.wait(
      templeIds.map((templeId) => getTempleDetailsById(templeId)).toList(),
    );

    // Filter out any null values in case the details were not found for some temples
    List<PlaceInfo> templesDetails =
        getFavTemple.whereType<PlaceInfo>().toList();

    // Print the list of templeIds
    print('List of templeIds: $templeIds');

    return templesDetails;
  }

  Future<PlaceInfo?> getTempleDetailsById(int templeId) async {
    final String url = 'http://192.168.1.66/api/show_fav_by_id.php';
    var response = await http.post(Uri.parse(url), body: {
      'templeId': templeId.toString(),
    });

    if (response.statusCode == 200) {
      try {
        var result = jsonDecode(response.body);
        if (result != null && result is Map<String, dynamic>) {
          return PlaceInfo.fromJson(result);
        }
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      print('Error fetching temple details: ${response.statusCode}');
    }

    return null;
  }
}
