import 'dart:convert';

SideBarEntity sideBarEntityFromJson(String str) =>
    SideBarEntity.fromJson(json.decode(str));

String sideBarEntityToJson(SideBarEntity data) => json.encode(data.toJson());

class SideBarEntity {
  bool isExpanded;

  SideBarEntity({this.isExpanded = true});

  factory SideBarEntity.fromJson(Map<String, dynamic> json) =>
      SideBarEntity(isExpanded: json['isExpanded'] ?? true);

  Map<String, dynamic> toJson() => {'isExpanded': isExpanded};
}
