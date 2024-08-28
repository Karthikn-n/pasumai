class RegionModel{
  final int regionId;
  final String regionName;
  final List<LocationModel> locationData;

  RegionModel({
    required this.regionId,
    required this.regionName,
    required this.locationData
  });

  Map<String, dynamic> toMap(){
    final results = <String, dynamic>{};
    
    results.addAll({'region_id': regionId});
    results.addAll({'name': regionName});
    results.addAll({'location_data': locationData.map((location) => location.toMap()).toList()});
    return results;
  }

  factory RegionModel.fromMap(Map<String, dynamic> map){
    return RegionModel(
      regionId: map['region_id'], 
      regionName: map['name'],
      locationData: List<LocationModel>.from(
        map['location_data']?.map((x) => LocationModel.fromMap(x))
      )
    );
  }
}



class LocationModel{
  final int locationId;
  final String locationName;

  LocationModel({
    required this.locationId,
    required this.locationName
  });

  Map<String, dynamic> toMap(){
    final results = <String, dynamic>{};
    
    results.addAll({'location_id': locationId});
    results.addAll({'name': locationName});
    return results;
  }

  factory LocationModel.fromMap(Map<String, dynamic> map){
    return LocationModel(
      locationId: map['location_id'], 
      locationName: map['name']
    );
  }
}