import 'package:json_annotation/json_annotation.dart';

part 'new_parameters.g.dart';

@JsonSerializable()
class NewParameters {
  final int page;
  final int pageSize;
  NewParameters({
    required this.page,
    required this.pageSize,
  });

  factory NewParameters.fromJson(Map<String, dynamic> json) =>
      _$NewParametersFromJson(json);

  Map<String, dynamic> toJson() => _$NewParametersToJson(this);
}
