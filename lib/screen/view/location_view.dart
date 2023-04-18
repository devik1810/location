import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/screen/controller/location_cantroller.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Live Location"),
          backgroundColor: Colors.black26,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    var status = await Permission.location.status;
                    if (status.isDenied) {
                      await Permission.location.request();
                    }
                  },
                  child: Text("Location "),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black26),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    locationController.lan.value = position.longitude;
                    locationController.lat.value = position.latitude;
                  },
                  child: Text("Longitude & Latitude "),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black26),
                ),
                SizedBox(height: 20),
                Obx(
                  () => Text(
                    "Longitude  =>  ${locationController.lan}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 20),
                Obx(
                  () => Text(
                    "Latitude  =>  ${locationController.lat}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    List<Placemark> placeMarkList =
                        await placemarkFromCoordinates(
                            locationController.lat.value,
                            locationController.lan.value);
                    locationController.placeList.value = placeMarkList;
                  },
                  child: Text("Addres "),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black26),
                ),SizedBox(height: 20),
                Obx(() => Text("${locationController.placeList}")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
