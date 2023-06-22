import 'dart:io';
import 'package:battery_plus/battery_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/secreens/homeSecreen.dart';
import 'package:disk_space/disk_space.dart';
import 'package:system_info_plus/system_info_plus.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  Future<User?> register(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;
      if (user != null) {
        await saveMobileSpecifications(user.uid);
        await saveSoftwareSpecifications(user.uid);
        // await saveInstalledApplications(user.uid);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<User?> login(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;
      if (user != null) {
        await saveMobileSpecifications(user.uid);
        await saveSoftwareSpecifications(user.uid);
        // await saveInstalledApplications(user.uid);

        print("Login successful!");
        print(user.email);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeSecreen(user),
          ),
        );

        return user;
      } else {
        print("Login failed!");
        return null;
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          await saveMobileSpecifications(user.uid);
          await saveSoftwareSpecifications(user.uid);
          // await saveInstalledApplications(user.uid);
        }
        return user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveMobileSpecifications(String userId) async {
    final Battery battery = Battery();
    // final BatteryState batteryState = await battery.batteryState;
    final int batteryLevel = await battery.batteryLevel;

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
      final String mobileModel = androidInfo.model;
      final String mobileCompany = androidInfo.manufacturer;
      final int? mobileRAM = await SystemInfoPlus.physicalMemory;
      final double? mobileStorage = await DiskSpace.getTotalDiskSpace;
      final String mobileBatteryCapacity = batteryLevel.toString();

      await FirebaseFirestore.instance
          .collection('mobile_specs')
          .doc(userId)
          .set({
        'mobileModel': mobileModel,
        'mobileCompany': mobileCompany,
        'mobileRAM': mobileRAM,
        'mobileStorage': mobileStorage,
        'mobileBatteryCapacity': mobileBatteryCapacity,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> saveSoftwareSpecifications(String userId) async {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
      final String androidVersion = androidInfo.version.release;

      await FirebaseFirestore.instance
          .collection('software_specs')
          .doc(userId)
          .set({
        'androidVersion': androidVersion,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  // Future<void> saveInstalledApplications(String userId) async {
  //   // Implement the logic to get the list of installed applications
  //   final List<String> installedApps = ['App 1', 'App 2', 'App 3']; // Replace with the actual list of installed applications

  //   await FirebaseFirestore.instance.collection('installed_apps').doc(userId).set({
  //     'installedApps': installedApps,
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });
  // }

  FirebaseAuth get firebaseAuth => _firebaseAuth;
}
