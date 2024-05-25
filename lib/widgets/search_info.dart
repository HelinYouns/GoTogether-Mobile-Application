// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  List<Feature>? features;
  String? type;

  Welcome({
    this.features,
    this.type,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    features: json["features"] == null ? [] : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "features": features == null ? [] : List<dynamic>.from(features!.map((x) => x.toJson())),
    "type": type,
  };
}

class Feature {
  Geometry? geometry;
  String? type;
  Properties? properties;

  Feature({
    this.geometry,
    this.type,
    this.properties,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
    type: json["type"],
    properties: json["properties"] == null ? null : Properties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "geometry": geometry?.toJson(),
    "type": type,
    "properties": properties?.toJson(),
  };
}

class Geometry {
  List<double>? coordinates;
  String? type;

  Geometry({
    this.coordinates,
    this.type,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    coordinates: json["coordinates"] == null ? [] : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
    "type": type,
  };
}

class Properties {
  int? osmId;
  List<double>? extent;
  String? country;
  String? city;
  String? countrycode;
  String? postcode;
  String? county;
  String? type;
  String? osmType;
  String? osmKey;
  String? street;
  String? osmValue;
  String? name;
  String? state;

  Properties({
    this.osmId,
    this.extent,
    this.country,
    this.city,
    this.countrycode,
    this.postcode,
    this.county,
    this.type,
    this.osmType,
    this.osmKey,
    this.street,
    this.osmValue,
    this.name,
    this.state,
  });

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    osmId: json["osm_id"],
    extent: json["extent"] == null ? [] : List<double>.from(json["extent"]!.map((x) => x?.toDouble())),
    country: json["country"],
    city: json["city"],
    countrycode: json["countrycode"],
    postcode: json["postcode"],
    county: json["county"],
    type: json["type"],
    osmType: json["osm_type"],
    osmKey: json["osm_key"],
    street: json["street"],
    osmValue: json["osm_value"],
    name: json["name"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "osm_id": osmId,
    "extent": extent == null ? [] : List<dynamic>.from(extent!.map((x) => x)),
    "country": country,
    "city": city,
    "countrycode": countrycode,
    "postcode": postcode,
    "county": county,
    "type": type,
    "osm_type": osmType,
    "osm_key": osmKey,
    "street": street,
    "osm_value": osmValue,
    "name": name,
    "state": state,
  };
}
