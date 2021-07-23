
import 'package:oho_works_app/models/campus_talk/participant_list.dart';
import 'package:oho_works_app/tri_cycle_database/data_base_helper.dart';
import 'package:flutter/material.dart';

class ParticipantNotifier extends ChangeNotifier {
  BuildContext? context;
  // int _pageNumber = 1;
  List<ParticipantListItem>? _listParticipantsFloor;
  List<ParticipantListItem>? _listParticipantsStage;
  // bool _loading = false;
  bool isDisposed = false;

  List<ParticipantListItem>? get value => _value;
  List<ParticipantListItem>? _value;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  List<ParticipantListItem>? getStageParticipants() {
    return _listParticipantsStage;
  }

  List<ParticipantListItem>? getFloorsParticipants() {
    return _listParticipantsFloor;
  }



/*  Future<void> getMore(DatabaseHelper db, AudioSocketService audioSocketService,
      int eventId, int personId) async {
    _loading = true;
    await getSpeakers(audioSocketService, eventId, personId);
    await getMembers(audioSocketService, eventId, personId);
    _loading = false;
  }*/

  Future<void> getOlderMessages(DatabaseHelper db) async {
    _listParticipantsFloor ??= <ParticipantListItem>[];
    _listParticipantsStage ??= <ParticipantListItem>[];
    _listParticipantsFloor = await db.getFloorParticipants("floor");
    _listParticipantsStage = await db.getFloorParticipants("stage");
    notifyListeners();
  }

  Future<void> deleteMessage(DatabaseHelper db, int participantId) async {
    _listParticipantsFloor ??= <ParticipantListItem>[];
    _listParticipantsStage ??= <ParticipantListItem>[];
    if (participantId != null) {
      await db.deleteParticipant(participantId);
      getOlderMessages(db);
    } else
      await db.deleteParticipants();

    notifyListeners();
  }
  Future<void> update(
      DatabaseHelper db, int? id, int? isMute) async {
    await db.updateMuteStatus(isMute,id);
    getOlderMessages(db);
  }
  Future<void> updateVideoStatus(
      DatabaseHelper db, int? id, int isVideoOnd) async {

    print("step 3=-----------------------------------------------------");
     await db.updateVideoStatus(isVideoOnd,id);
    getOlderMessages(db);
  }


  Future<void> updateSpeaking(
      DatabaseHelper db, int id, int isSpeaking) async {
    await db.updateSpeakingStatus(isSpeaking,id);
    getOlderMessages(db);
  }
  Future<void> updateSpeakingAll(
      DatabaseHelper db) async {
    await db.updateSpeakingStatusAll();
    getOlderMessages(db);
  }
  Future<void> updateModerators(
      DatabaseHelper db, int? id, int? isModerators) async {
    await db.updateModeratorStatus(isModerators,id);
    getOlderMessages(db);
  }

  Future<void> updateRole(
      DatabaseHelper db, ParticipantListItem participantListItem,String type) async {
    // participantListItem.type=type;
    await db.updateRole(participantListItem.role, type,participantListItem.participantId);
    // await db.deleteParticipant(participantListItem.participantId);
    // await db.insertParticipant(participantListItem);
    getOlderMessages(db);
  }
  Future<void> updateSpeaker(DatabaseHelper db, ParticipantListItem participantListItem,String type) async {
    participantListItem.type=type;
    await db.deleteParticipant(participantListItem.participantId);
    await db.insertParticipant(participantListItem);
    getOlderMessages(db);
  }


  Future<void> saveSingleItem(
      DatabaseHelper db, ParticipantListItem item,String type) async {
    item.type=type;

    await db.insertParticipant(item);

    getOlderMessages(db);
  }

  Future<void> deleteSingleItem(
      DatabaseHelper db, int? id,String? type) async {
    await db.deleteParticipant(id);

    getOlderMessages(db);
  }


  Future<void> saveData(
      DatabaseHelper db, List<ParticipantListItem> list,String? type) async {
      for (var item in list) {
        item.type = type;
        await db.insertParticipant(item);
      }
      getOlderMessages(db);
  }

  Future<void> saveSingleData(
      DatabaseHelper db, ParticipantListItem participantListItem) async {
    await db.insertParticipant(participantListItem);
    getOlderMessages(db);
  }
}
