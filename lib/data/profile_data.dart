class Attributes {
  int id;
  String name;
  List<OptionData> optionData;

  Attributes({
    required this.id,
    required this.name,
    required this.optionData,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) {
    List<OptionData> options = (json['option_data'] as List).map((option) => OptionData.fromJson(option)).toList();
    return Attributes(
      id: json['att_id'],
      name: json['att_name'],
      optionData: options,
    );
  }
}

class OptionData {
  int id;
  String name;

  OptionData({
    required this.id,
    required this.name,
  });

  factory OptionData.fromJson(Map<String, dynamic> json) {
    return OptionData(
      id: json['option_id'],
      name: json['option_name'],
    );
  }
}

class DropdownValue {
  Attributes? attribute;
  OptionData? option;

  DropdownValue({this.attribute, this.option});
}

