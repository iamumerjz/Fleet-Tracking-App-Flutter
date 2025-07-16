
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';


@JsonSerializable()

class Trucker{
  String name;
  String email;
  String numberPlate;
  int completedOrders;
  String status;
  Trucker({ this.name="nameless", this.email="unknown@nomail.com", this.numberPlate= "xxzz", this.completedOrders = 0
  , this.status ="inactive"});
  factory Trucker.fromJson(Map<String, dynamic> json) => _$TruckerFromJson(json);
  Map<String, dynamic> toJson() => _$TruckerToJson(this);
}

