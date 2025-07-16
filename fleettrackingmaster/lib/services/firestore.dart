import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleettrackingmaster/services/models.dart';
import 'auth.dart';


class FirestoreService{

  Future<void> completeUser(String name, String numberPlate, String email) async {

    await AuthService().user?.updateDisplayName(name);
    final ref = FirebaseFirestore.instance.collection("truckers").doc(email);
    var data = {
      "name" : name,
      "numberPlate": numberPlate,
      "email": email,
      "completedOrders": 0,
      "status": "inactive"
    };
    return ref.set(data, SetOptions(merge: true));
  }

  Future<int> AdminLogin(String username, String secretkey, String password) async {
    final querySnapshot =  await FirebaseFirestore.instance.collection('admin')
        .limit(1)
        .where('name', isEqualTo: username)
        .where('secretkey', isEqualTo: secretkey)
        .where('password', isEqualTo: password)
        .get();

    return querySnapshot.size;
  }

  Future<int> checkIfActive(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('active')
        .where("status", isEqualTo: "active")
        .where("email", isEqualTo: email)
        .get();
    return querySnapshot.size;
  }



  Future<List<Trucker>> getTruckers() async {
    var ref = FirebaseFirestore.instance.collection('truckers'); // truckers/smthng
    var snapshot = await ref.get(); // get gets a document only once (not realtime)
    var data = snapshot.docs.map((s) => s.data()); // foreach loop is used
    var truckers = data.map((d) => Trucker.fromJson(d));
    //log(topics.toString());
    return truckers.toList();
  }

  Future<void> startDelivery(String sLat, String sLong, eLat, eLong)async {
    await FirebaseFirestore.instance
        .collection('active')
        .doc(AuthService().user?.email)
        .set({
      "email": AuthService().user?.email,
      "startLocation": GeoPoint(double.tryParse(sLat!)!, double.tryParse(sLong!)!), //33.6777844, 33.6777167
      "currentLocation": GeoPoint(double.tryParse(sLat!)!, double.tryParse(sLong!)!),
      "endLocation": GeoPoint(double.tryParse(eLat!)!, double.tryParse(eLong!)!),
      "status": "active",

    }, SetOptions(merge: true));


    final ref = FirebaseFirestore.instance.collection("truckers").doc(AuthService().user?.email);
    var data = {
      "status": "active"
    };
    return ref.set(data, SetOptions(merge: true));

  }


  Future<List<GeoPoint>> getInitials({required String email}) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('active')
        .limit(1)
        .where('email', isEqualTo: email)
        .get();

    GeoPoint? start;
    GeoPoint? end;
    GeoPoint? current;

    try{
      for (var doc in querySnapshot.docs) {
        // Getting data directly
        Map<String, dynamic> data = doc.data();
        data.forEach((k,v){
          log("$k  $v");
          if(k.toString() == "startLocation"){
            log("start");
            start = v as GeoPoint?;
          }
          if (k.toString() == "endLocation"){
            end = v as GeoPoint?;
          }
          if (k.toString() == "currentLocation"){
            current = v as GeoPoint?;
          }
        });
      }
    }
    catch(e){
      log(e.toString());
    }
    return [start!, end!, current!];
  }



  Future<void> updateLocationFireStore(double lat, double long ) async {
    log("before timer loop function");
    final ref = FirebaseFirestore.instance.collection('active').doc(AuthService().user?.email);
    var data = {
      "currentLocation": GeoPoint(lat, long)
    };

    ref.set(data, SetOptions(merge: true));
  }


  Future<void> endTask() async {
    final ref = FirebaseFirestore.instance.collection('active').doc(AuthService().user?.email);
    final ref2 =  FirebaseFirestore.instance.collection("truckers").doc(AuthService().user?.email);

    var data = {
      "status": "inactive",
    };
    var data2 = {
      "status": "inactive",
      "completedOrders": FieldValue.increment(1)
    };

    try{
      ref.set(data, SetOptions(merge: true));
      ref2.set(data2, SetOptions(merge: true));
    }catch(e){
      log('error');
      log(e.toString());
    }

  }

}