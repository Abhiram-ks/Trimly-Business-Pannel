import 'dart:convert';
import 'dart:developer';

import 'package:barber_pannel/service/security/sensitive_keys.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class AddressFormatter {
  static String reverseFormatAddress(Placemark place) {
    String address = "";

    if (place.street != null && place.street!.isNotEmpty) {
      address = place.street!;
    } else if (place.name != null &&
        place.name!.isNotEmpty &&
        !place.name!.contains('+')) {
      address = place.name!;
    }

    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      address +=
          address.isEmpty ? place.subLocality! : ", ${place.subLocality!}";
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      address += address.isEmpty ? place.locality! : ", ${place.locality}";
    }
    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      address +=
          address.isEmpty
              ? place.administrativeArea!
              : ", ${place.administrativeArea}";
    }
    if (place.country != null && place.country!.isNotEmpty) {
      address += address.isEmpty ? place.country! : ", ${place.country}";
    }

    return address;
  }

  static Future<String> formatAddress(double lat, double lng) async {
    log("lat: $lat, lng: $lng", name: "latlng");
    try {
      final response = await http.get(
        Uri.parse(
          "https://api.opencagedata.com/geocode/v1/json?q=$lat+$lng&key=${SensitiveKeys.openCageDataApiKey}&pretty=1&no_annotations=1",
        ),
      );
      log("${response.body}response", name: "response${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["results"] != null && data["results"].isNotEmpty) {
          final formattedAddress = data["results"][0]["formatted"];
          log("Formatted Address: $formattedAddress", name: "reverseGeo");
          return formattedAddress;
        } else {
          return "Address not found";
        }
      } else {
        return backupFormatAddress(lat, lng);
      }
    } catch (e) {
      return backupFormatAddress(lat, lng);
    }
  }

  static Future<String> backupFormatAddress(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        return AddressFormatter.reverseFormatAddress(placemarks.first);
      } else {
        return "Address not found";
      }
    } catch (e) {
      return "Error getting address";
    }
  }
}
