import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';

class DataSaveUtils {
  Future<bool> saveUserData(
    SharedPreferences prefs,
    Persondata data,
  ) async{
    if (prefs != null) {
      try {
        prefs.setString("basicData", jsonEncode(data));
        prefs.setInt(Strings.userId, data.id);
        for (var item in data.institutions) {
          if (item.personType == "T" ||
              item.personType == "S" ||
              item.personType == "P" ||
              item.personType == "M" ||
              item.personType == "O" ||
              item.personType == "A" ||
              item.personType == "L") {
            prefs.setString(Strings.ownerType, "person");
            prefs.setInt(Strings.instituteId, item.id);
            prefs.setString(Strings.personType, item.personType);
          } else {
            prefs.setInt(Strings.adminInstitute, item.id);
          }
        }
        if (data.institutions != null && data.institutions.isNotEmpty) {
          print("******************************* here ");
          prefs.setString(Strings.ownerType, "person");
          prefs.setInt(Strings.instituteId, data.institutions[0].id);
          prefs.setString(Strings.personType, data.institutions[0].personType);
        }

        prefs.setBool(Strings.isVerified, data.isVerified ??= false);
        prefs.setString(Strings.profileImage, data.profileImage ?? "");
        prefs.setString(Strings.coverImage, data.coverImage ?? "");
        prefs.setInt(Strings.userIdOriginal, data.userId);
        prefs.setString(Strings.slug, data.slug);
        prefs.setString(Strings.basicData, jsonEncode(data));
        prefs.setString(Strings.firstName, data.firstName);
        prefs.setString(Strings.lastName, data.lastName);
        String userName = data.firstName ?? "";
        var location = "";
        if (data.middleName != null)
          userName = userName + " " + data.middleName ?? "";
        if (data.lastName != null)
          userName = userName + " " + data.lastName ?? "";
        if (data.userLocation != null) {
          location = data.userLocation.locality ?? "";
          prefs.setString(Strings.location, location);
        }
        prefs.setString(Strings.userName, userName);
        if (data.permissions != null && data.permissions.isNotEmpty) {

          prefs.setStringList(
              Strings.adminInstituteIds,
              List<String>.generate(data.permissions.length, (index) {
                return data.permissions[index].id.toString();
              }));
        }


        if (data.institutions != null && data.institutions.isNotEmpty) {
          prefs.setStringList(
              Strings.institutionImageList,
              List<String>.generate(data.institutions.length, (index) {
                return data.institutions[index].profileImage ??= "";
              }));
          prefs.setStringList(
              Strings.institutionIdList,
              List<String>.generate(data.institutions.length, (index) {
                return data.institutions[index].id.toString();
              }));
          prefs.setStringList(
              Strings.roleTypeList,
              List<String>.generate(data.institutions.length, (index) {
                return data.institutions[index].role ??= "";
              }));
          prefs.setStringList(
              Strings.institutionNameList,
              List<String>.generate(data.institutions.length, (index) {
                return data.institutions[index].name ??= "";
              }));
          prefs.setStringList(
              Strings.personTypeList,
              List<String>.generate(data.institutions.length, (index) {
                return data.institutions[index].personType ??= "";
              }));
        } else {
          prefs.setInt(Strings.instituteId, data.institutionId);
        }
        return true;
      } catch (onError) {
        print(onError);
        return false;
      }
    } else {
      return false;
    }
  }

  Future<Persondata> getUserData(BuildContext context, SharedPreferences prefs) async {
    prefs ??= await SharedPreferences.getInstance();
    final body = jsonEncode({"person_id": null});
    var value = await Calls().call(body, context, Config.PERSONAL_PROFILE);
    var data = PersonalProfile.fromJson(value);
    saveUserData(prefs, data.rows);
    return data.rows;
  }
}
