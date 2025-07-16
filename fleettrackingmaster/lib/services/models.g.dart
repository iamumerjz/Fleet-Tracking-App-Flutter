// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trucker _$TruckerFromJson(Map<String, dynamic> json) => Trucker(
      name: json['name'] as String? ?? "nameless",
      email: json['email'] as String? ?? "unknown@nomail.com",
      numberPlate: json['numberPlate'] as String? ?? "xxzz",
      completedOrders: json['completedOrders'] as int? ?? 0,
      status: json['status'] as String? ?? "inactive",
    );

Map<String, dynamic> _$TruckerToJson(Trucker instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'numberPlate': instance.numberPlate,
      'completedOrders': instance.completedOrders,
      'status': instance.status,
    };
