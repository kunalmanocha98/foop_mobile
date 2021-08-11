import 'dart:async';
import 'dart:io';

import 'package:oho_works_app/messenger_module/entities/conversation_list_reponse.dart';
import 'package:oho_works_app/messenger_module/entities/message_database.dart';
import 'package:oho_works_app/models/campus_talk/participant_list.dart';
import 'package:oho_works_app/models/email_module/compose_email.dart';
import 'package:oho_works_app/models/user_contacts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "tricycle_db.db";
  static final _databaseVersion = 3;
  static final columnId = '_id';

  //=============================================Conversation List Table
  static final tableConversations = 'conversations_table';
  static final ids = '_id';
  static final id = 'id';
  static final isOnline = 'isOnline';
  static final unreadCount = 'unreadCount';
  static final conversationOwnerType = 'conversationOwnerType';
  static final conversationOwnerId = 'conversationOwnerId';
  static final conversationId = 'conversationId';
  static final conversationWithType = 'conversationWithType';
  static final conversationWithTypeId = 'conversationWithTypeId';
  static final conversationWithName = 'conversationWithName';
  static final conversationImageThumbnail = 'conversationImageThumbnail';
  static final conversationImage = 'conversationImage';
  static final conversationName = 'conversationName';
  static final lastMessage = 'lastMessage';
  static final lastMessageByType = 'lastMessageByType';
  static final lastMessageById = 'lastMessageById';
  static final lastMessageByName = 'lastMessageByName';
  static final lastMessageTime = 'lastMessageTime';
  static final lastMessageUTCTime = 'lastMessageUTCTime';
  static final mcId = 'mcId';
  static final lastMessageIcon = 'lastMessageIcon';
  static final isRoomAvailable = 'isRoomAvailable';

  //==============================================================Messages Table
  static final tableMessages = 'table_messages';
  static final date = 'date';
  static final allRoomsId = 'allRoomsId';
  static final eventId = 'eventId';
  static final messageToId = 'messageToId';
  static final messageToType = 'messageToType';
  static final updatedDateTime = 'updatedDateTime';
  static final updatedDateByType = 'updatedDateByType';
  static final updatedDateById = 'updatedDateById';
  static final isGroupConversation = 'isGroupConversation';
  static final sId = '_id';
  static final myConversationId = 'myConversationId';
  static final messageId = 'messageId';
  static final message = 'message';
  static final messageAttachment = 'messageAttachment';
  static final messageAttachmentThumbnail = 'messageAttachmentThumbnail';
  static final messageAttachmentType = 'messageAttachmentType';
  static final messageAttachmentMIMEType = 'messageAttachmentMIMEType';
  static final messageAttachmentName = 'messageAttachmentName';
  static final messageSentByName = 'messageSentByName';
  static final messageAction = 'messageAction';
  static final messageByType = 'messageByType';
  static final messageById = 'messageById';
  static final messageSentTime = 'messageSentTime';
  static final messageDeliveredTime = 'messageDeliveredTime';
  static final messageReadTime = 'messageReadTime';
  static final messageSentUTCTime = 'messageSentUTCTime';
  static final messageDeliveredUTCTime = 'messageDeliveredUTCTime';
  static final messageReadUTCTime = 'messageReadUTCTime';
  static final messageStatus = 'messageStatus';
  static final isReply = 'isReply';
  static final replyToMessageId = 'replyToMessageId';
  static final originalMessage = 'originalMessage';
  static final originalMessageSenderType = 'originalMessageSenderType';
  static final originalMessageSenderName = 'originalMessageSenderName';
  static final originalMessageSenderId = 'originalMessageSenderId';
  static final originalMessageAttachment = 'originalMessageAttachment';
  static final originalMessageAttachmentType = 'originalMessageAttachmentType';
  static final originalMessageAttachmentMIMEType =
      'originalMessageAttachmentMIMEType';
  static final originalMessageAttachmentName = 'originalMessageAttachmentName';
  static final originalMessageAttachmentThumbnail =
      'originalMessageAttachmentThumbnail';
  static final originalConversationId = 'originalConversationId';
  static final isForwarded = 'isForwarded';
  static final forwardedFromMessageId = 'forwardedFromMessageId';
  static final flagCode = 'flagCode';
  static final flagName = 'flagName';
  static final flagColorCode = 'flagColorCode';
  static final flagIcon = 'flagIcon';
  static final messageDataType = 'messageDataType';
  static final messageType = 'messageType';
  static final messageSubType = 'messageSubType';
  static final createdOn = 'createdOn';
  static final isBroadcastType = 'isBroadcastType';
  static final isUploading = 'isUploading';
  static final isFailed = 'isFailed';

  //============================================================Contacts
  static final tableContacts = 'userContacts';
  static final columnName = 'name';
  static final columnMobile = 'mobileNumber';
  static final columnIsSync = 'isSync';
  static final columnIsSelected = 'isSelected';
  static final columnFirstName = 'firstName';
  static final columnLastName = 'lastName';
  static final columnEmail = 'email';

  //============================================================user Profile Cards
  static final tableUserProfileData = 'tableUserProfileData';
  static final cardData = 'cardData';

  //=================================================
  //============================================================TALK
  static final participantTable = 'participantTable';
  static final name = 'name';
  static final profileImage = 'profile_image';
  static final role = 'role';
  static final type = 'type';
  static final participantType = 'participant_type';
  static final participantId = 'participant_id';
  static final isSpeakerOn = 'is_speaker_on';
  static final isVideoOn = 'is_video_on';
  static final isModerator = 'is_moderator';
  static final personType = 'person_type';
  static final joinedDate = 'joined_date';
  static final isSpeaking = 'isSpeaking';

  //==========================================================EmailTable
  static final emailTable = 'emailTable';
  static final personId = 'person_id';
  static final username = 'username';
  static final from_address = 'from_address';
  static final to_addresses = 'to_addresses';
  static final cc_addresses = 'cc_addresses';
  static final bcc_addresses = 'bcc_addresses';
  static final email_subject = 'email_subject';
  static final email_text = 'email_text';
  static final original_message_uid = 'original_message_uid';
  static final files = 'files';
  static final folder = 'folder';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1) {
      await db
          .execute("ALTER TABLE userContacts ADD COLUMN isSelected INTEGER;");
    }
    if (newVersion > 2) {
      await _conversations(db, newVersion);
      await _messages(db, newVersion);
      await _talk(db, newVersion);
    }
  }

  Future _onCreate(Database db, int version) async {
    await _contactsDatabase(db, version);
    await _conversations(db, version);
    await _messages(db, version);
    await _talk(db, version);
    await _email(db, version);
  }

  _email(Database db, int version) async{
    await db.execute('''
CREATE TABLE $emailTable (
$id INTEGER PRIMARY KEY AUTOINCREMENT,
$personId TEXT,
$username TEXT,
$from_address TEXT,
$to_addresses TEXT,
$cc_addresses TEXT,
$bcc_addresses TEXT,
$email_subject TEXT,
$email_text TEXT,
$original_message_uid TEXT,
$files TEXT,      
$folder TEXT
)
''');
  }

  _talk(Database db, int version) async {
    await db.execute('''
CREATE TABLE $participantTable (
$id INTEGER PRIMARY KEY,
$name TEXT ,
$role TEXT ,
$profileImage TEXT,
$participantType TEXT,
$participantId INTEGER ,
$isSpeakerOn INTEGER ,
$isVideoOn INTEGER ,
$isSpeaking INTEGER ,
$type TEXT,
$isModerator INTEGER,
$personType TEXT,
$joinedDate INTEGER
)
''');
  }

  _messages(Database db, int version) async {
    await db.execute('''
CREATE TABLE $tableMessages (
$id INTEGER PRIMARY KEY,
$messageToId TEXT ,
$date TEXT ,
$allRoomsId INTEGER,
$eventId INTEGER,
$messageToType TEXT ,
$updatedDateTime INTEGER ,
$updatedDateByType TEXT ,
$updatedDateById TEXT ,
$isGroupConversation INTEGER ,
$sId TEXT ,
$mcId TEXT ,
$conversationId TEXT ,
$myConversationId TEXT ,
$messageId TEXT ,
$message TEXT ,
$messageAttachment TEXT ,
$messageAttachmentThumbnail TEXT ,
$messageAttachmentType TEXT ,
$messageAttachmentMIMEType TEXT ,
$messageAttachmentName TEXT ,
$messageSentByName TEXT ,
$messageAction TEXT ,
$messageByType TEXT ,
$messageById TEXT ,
$messageSentTime INTEGER ,
$messageDeliveredTime INTEGER ,
$messageReadTime INTEGER ,
$messageSentUTCTime TEXT ,
$messageDeliveredUTCTime TEXT ,
$messageReadUTCTime TEXT ,
$messageStatus TEXT ,
$isReply INTEGER ,
$replyToMessageId TEXT ,
$originalMessage TEXT ,
$originalMessageSenderType TEXT ,
$originalMessageSenderName TEXT ,
$originalMessageSenderId TEXT ,
$originalMessageAttachment TEXT ,
$originalMessageAttachmentType TEXT ,
$originalMessageAttachmentMIMEType TEXT ,
$originalMessageAttachmentName TEXT ,
$originalMessageAttachmentThumbnail TEXT ,
$originalConversationId TEXT ,
$isForwarded INTEGER ,
$forwardedFromMessageId TEXT ,
$flagCode TEXT ,
$flagName TEXT ,
$flagColorCode TEXT ,
$flagIcon TEXT ,
$messageDataType TEXT ,
$messageType TEXT ,
$messageSubType TEXT ,
$createdOn TEXT ,
$isBroadcastType INTEGER ,
$isUploading INTEGER ,
$isFailed INTEGER 
)
''');
  }

  _conversations(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableConversations (
            $id INTEGER PRIMARY KEY,
            $unreadCount INTEGER ,
            $ids TEXT ,
             $isGroupConversation INTEGER,
                $isRoomAvailable INTEGER,
            $isOnline INTEGER,
            $conversationOwnerType TEXT ,
            $conversationOwnerId TEXT ,
            $conversationId TEXT ,
            $conversationWithTypeId TEXT ,
            $conversationWithType TEXT ,
            $conversationWithName TEXT ,
            $conversationImageThumbnail TEXT ,
            $conversationImage TEXT ,
            $conversationName TEXT ,
            $lastMessage TEXT ,
            $lastMessageByType TEXT ,
            $lastMessageById TEXT ,
            $lastMessageByName TEXT ,
           $lastMessageTime INTEGER ,
           $lastMessageUTCTime TEXT ,
           $mcId TEXT ,
           $lastMessageIcon TEXT
                                     
        )
          ''');
  }

  _contactsDatabase(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableContacts (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnMobile TEXT NOT NULL,
            $columnLastName TEXT ,
            $columnFirstName TEXT ,
            $columnEmail TEXT ,
            $columnIsSync INTEGER ,
             $columnIsSelected INTEGER 
          )
          ''');
  }

  // _useProfileData(Database db, int version) async {
  //   await db.execute('''
  //         CREATE TABLE $tableUserProfileData (
  //           $columnId INTEGER PRIMARY KEY,
  //           $cardData TEXT NOT NULL,
  //         )
  //         ''');
  // }

  //=====================================================================TALK queries
  insertParticipants(List<ParticipantListItem> row) async {
    Database? db = await (instance.database );
    Batch batch = db!.batch();
    batch.insert('Test', {'name': 'item'});
    batch.rawInsert(participantTable, row);
    return await batch.commit();
  }

  Future<int> insertParticipant(ParticipantListItem row) async {
  Database? db = await (instance.database );
    return await db!.insert(participantTable, row.toJson());
  }

  updateMuteStatus(int? isOn, int? _participantId) async {
    Database? db = await (instance.database );
    return await db!.rawUpdate(
        'UPDATE $participantTable SET $isSpeakerOn = ? WHERE $participantId = ?',
        [isOn, _participantId]);
  }

  updateVideoStatus(int? isOn, int? _participantId) async {
    print("step 3=-----------------------------------------------------");
    Database? db = await (instance.database );
    return await db!.rawUpdate(
        'UPDATE $participantTable SET $isVideoOn = ? WHERE $participantId = ?',
        [isOn, _participantId]);
  }

  updateSpeakingStatus(int isSpeak, int _participantId) async {
    Database? db = await (instance.database );
    return await db!.rawUpdate(
        'UPDATE $participantTable SET $isSpeaking = ? WHERE $participantId = ?',
        [isSpeak, _participantId]);
  }

  updateSpeakingStatusAll() async {
    Database? db = await (instance.database );
    return await db!
        .rawUpdate('UPDATE $participantTable SET $isSpeaking = ?', [0]);
  }

  updateModeratorStatus(int? isMod, int? _participantId) async {
    Database? db = await (instance.database );
    return await db!.rawUpdate(
        'UPDATE $participantTable SET $isModerator = ? WHERE $participantId = ?',
        [isMod, _participantId]);
  }

  updateRole(String? _role, String _type, int? _participantId) async {
    Database? db = await (instance.database );
    return await db!.rawUpdate(
        'UPDATE $participantTable SET $role = ?,$type = ?  WHERE $participantId = ?',
        [_role, _type, _participantId]);
  }

  Future<int> deleteParticipant(int? id) async {
  Database? db = await (instance.database );
    return await db!.rawDelete(
        'DELETE FROM $participantTable WHERE $participantId = ?', [id]);
  }

  Future<int> deleteParticipants() async {
  Database? db = await (instance.database );
    print(
        "deltingggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg");
    return await db!.delete(participantTable);
  }

  Future<bool> getMember(int participant_id) async {
  Database? db = await (instance.database );
    List<Map> maps = await db!.query(participantTable,
        distinct: true,
        groupBy: participantId,
        where: '$participantId = ?',
        whereArgs: [participant_id]);
    List<ParticipantListItem> data = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        data.add(ParticipantListItem.fromJson(maps[i] as Map<String, dynamic>));
      }
    }
    if (data.isNotEmpty)
      return data[0].isModerator == 1 ? true : false;
    else
      return false;
  }

  Future<List<ParticipantListItem>> getModerators() async {
  Database? db = await (instance.database );
    List<Map> maps = await db!.query(participantTable,
        distinct: true,
        groupBy: participantId,
        where: '$isModerator = ?',
        whereArgs: [1]);
    List<ParticipantListItem> data = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        data.add(ParticipantListItem.fromJson(maps[i] as Map<String, dynamic>));
      }
    }
    return data;
  }

  Future<List<ParticipantListItem>> getFloorParticipants(String t) async {
  Database? db = await (instance.database );
    List<Map> maps = await db!.query(participantTable,
        distinct: true,
        groupBy: participantId,
        where: '$type = ?',
        orderBy: '$joinedDate ASC',
        whereArgs: [t]);
    List<ParticipantListItem> data = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        data.add(ParticipantListItem.fromJson(maps[i] as Map<String, dynamic>));
      }
    }
    return data;
  }

  //=====================================================================Email queries

  Future<List<EmailCreateRequest>> getAllEmails() async {
    Database? db = await instance.database;
    List<Map<String,dynamic>> maps = await db!.query(emailTable);
    List<EmailCreateRequest> data = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        data.add(EmailCreateRequest.fromJson(maps[i]));
      }
    }
    return data;
  }

  removeEmail(int emailId) async{
    final db = await instance.database;
    var res = await db!.delete(emailTable,where: '$id = ? ',whereArgs: [emailId]);
    return res;
  }

  Future<int> insertEmail(EmailCreateRequest row) async {
    Database? db = await instance.database;
    return await db!.insert(emailTable, row.toJson());
  }


  //=====================================================================Conversation queries

  Future<int> insertConversation(ConversationItemDb row) async {
  Database? db = await (instance.database );
    return await db!.insert(tableConversations, row.toJson());
  }

  Future<List<ConversationItemDb>> allConversations() async {
  Database? db = await (instance.database );
    List<Map> maps = await db!.query(tableConversations,
        distinct: true,
        groupBy: conversationId,
        orderBy: '$lastMessageTime DESC');
    List<ConversationItemDb> data = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        data.add(ConversationItemDb.fromJson(maps[i] as Map<String, dynamic>));
      }
    }
    return data;
  }

  Future<List<ConversationItemDb>> searchedList(String value) async {
  Database? db = await (instance.database );
    List<Map> maps = await db!.query(tableConversations,
        where: '$conversationName LIKE ?',
        whereArgs: ['%$value%'],
        orderBy: '$lastMessageTime DESC');
    List<ConversationItemDb> data = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        data.add(ConversationItemDb.fromJson(maps[i] as Map<String, dynamic>));
      }
    }
    return data;
  }


  Future<ConversationItemDb?> getConversationItemFromPeronId(String id) async {
  Database? db = await (instance.database );
    List<Map> maps = (await db!.query(tableConversations,
        where: '$conversationWithTypeId = ?', whereArgs: [id]));
    if (maps.length > 0) {
      ConversationItemDb user = ConversationItemDb.fromJson(maps[0] as Map<String, dynamic>);
      return user;
    }
    return null;
  }

  Future<ConversationItemDb?> getConversationItem(String? id) async {
  Database? db = await (instance.database );
    List<Map> maps = (await db!.query(tableConversations,
        where: '$conversationId = ?', whereArgs: [id]));
    if (maps.length > 0) {
      ConversationItemDb user = ConversationItemDb.fromJson(maps[0] as Map<String, dynamic>);
      return user;
    }
    return null;
  }

  // ignore: missing_return
  Future<ConversationItemDb?> getConversationWithOnlineStatus(
      String userId) async {
    Database? db = await instance.database;
    if(userId!=null)
   { List<Map> maps = await db!.query(tableConversations,
        where: '$conversationOwnerId = ?', whereArgs: [userId]);

    return maps.isNotEmpty ? ConversationItemDb.fromJson(maps[0] as Map<String, dynamic>) : null;}
  }

  Future<int> makeUnreadCountZero(String? id, int count) async {
  Database? db = await (instance.database );
    return await db!.rawUpdate(
        'UPDATE $tableConversations SET $unreadCount = ? WHERE $conversationId = ?',
        [count, id]);
  }

  updateConversationData(ConversationItemDb data) async {
    Database? db = await (instance.database );
    var res = await db!.rawUpdate(
        'UPDATE $tableConversations SET $lastMessageTime = ?  ,$lastMessage = ?,$isOnline = ?  WHERE $conversationWithTypeId = ?',
        [
          data.lastMessageTime,
          data.lastMessage,
          data.isOnline,
          data.conversationWithTypeId
        ]);

    await db.update(tableConversations, data.toJson(),
        where: '$conversationId = ?', whereArgs: [data.conversationId]);
    return res;
  }

  updateStatus(String userId, int status) async {
    if(userId!=null && status!=null )
   {  Database? db = await (instance.database );
    return await db!.rawUpdate(
        'UPDATE $tableConversations SET $isOnline = ? WHERE $conversationWithTypeId = ?',
        [status, userId]);}
  }

  updateAllStatus() async {
    Database? db = await (instance.database );

    return await db!
        .rawUpdate('UPDATE $tableConversations SET $isOnline = ?', [0]);
  }

  Future<int> deleteConversations() async {
  Database? db = await (instance.database );
    return await db!.delete(tableConversations);
  }

  //======================================================Messages quries

  Future<int> insertMessage(MessagePayloadDatabase row) async {
  Database? db = await (instance.database );
    return await db!.insert(tableMessages, row.toJson());
  }

  Future<List<MessagePayloadDatabase>?> getMessages(String? id) async {
    if(id!=null)
  {  Database? db = await (instance.database );
    List<Map> maps = await db!.query(tableMessages,
        distinct: true,
        where: '$conversationId = ?',
        whereArgs: [id],
        groupBy: messageId,
        orderBy: '$messageId DESC');
    List<MessagePayloadDatabase> data = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        data.add(MessagePayloadDatabase.fromJson(maps[i] as Map<String, dynamic>));
      }
    }
    return data;}
    else
      return null;
  }

  deleteMessage(String id) async {
    Database? db = await (instance.database );
    var res = await db!
        .delete(tableMessages, where: '$messageId = ? ', whereArgs: [id]);
    return res;
  }

  updateMessage(MessagePayloadDatabase data) async {
    Database? db = await (instance.database );
    var res = await db!.update(tableMessages, data.toJson(),
        where: '$messageId = ? AND $conversationId = ?',
        whereArgs: [data.messageId, data.conversationId]);
    return res;
  }

  Future<MessagePayloadDatabase?> getMessageItem(String? cId, String? mId) async {
  Database? db = await (instance.database );
    List<Map> maps = (await db!
        .query(tableMessages, where: '$messageId = ?', whereArgs: [mId]));
    if (maps.length > 0) {
      MessagePayloadDatabase user = MessagePayloadDatabase.fromJson(maps[0] as Map<String, dynamic>);
      return user;
    }
    return null;
  }

  Future<int> deleteMessages() async {
  Database? db = await (instance.database );
    return await db!.delete(tableMessages);
  }

  //=====================================contact database queriesssss
  Future<int> insertContacts(UserContact row) async {
  Database? db = await (instance.database );
    return await db!.insert(tableContacts, row.toJson());
  }

  updateIsSelected(UserContact userContact) async {
    Database? db = await (instance.database );
    var res = await db!.update(tableContacts, userContact.toJson(),
        where: '$columnMobile = ?', whereArgs: [userContact.mobileNumber]);
    return res;
  }

  updateIsSelectedAll() async {
    Database? db = await (instance.database );
    var res = await db!.rawUpdate(
        'UPDATE $tableContacts SET $columnIsSelected = ?,  $columnIsSelected = ?',
        [1, 0]);
    return res;
  }

  Future<List<UserContact>> getContactsUsingName(String name) async {
    print(name);
  Database? db = await (instance.database );
    List<Map> maps = await db!.query(tableContacts,
        where: '$columnName  LIKE ?', whereArgs: ['$name%']);
    List<UserContact> data = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        data.add(UserContact.fromJson(maps[i] as Map<String, dynamic>));
      }
    }
    return data;
  }

  Future<List<UserContact>> getContacts() async {
    Database? db = await (instance.database);
    List<Map> maps = await db!.query(tableContacts,
        where: '$columnIsSync = ?', whereArgs: [0], limit: 50);
    List<UserContact> data = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        data.add(UserContact.fromJson(maps[i] as Map<String, dynamic>));
      }
    }
    return data;
  }

//===================================================================
  Future<List<UserContact>> getContactsAll() async {
  Database? db = await (instance.database );
    List<Map> maps = await
    db!.query(tableContacts);
    List<UserContact> data = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        data.add(UserContact.fromJson(maps[i] as Map<String, dynamic>));
      }
    }
    return data;
  }

  Future<List<UserContact>> getContactsAllWithName() async {
    Database? db = await (instance.database );
    List<Map> maps = (await db!
        .query(tableContacts, where: '$name != ?', whereArgs: [""]));
    List<UserContact> data = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        data.add(UserContact.fromJson(maps[i] as Map<String, dynamic>));
      }
    }
    return data;
  }

  Future<UserContact?> getContactUsingMobileNumber(String? mobNum) async {
    Database? db = await (instance.database );
    List<Map> maps = (await db!
        .query(tableContacts, where: '$columnMobile = ?', whereArgs: [mobNum]));
    if (maps.length > 0) {
      UserContact user = UserContact.fromJson(maps[0] as Map<String, dynamic>);

      return user;
    }
    return null;
  }

  Future<int> updateSync(UserContact row) async {
    Database? db = await (instance.database );
    return await db!.rawUpdate(
        'UPDATE $tableContacts SET isSync = ? WHERE mobileNumber = ?',
        [1, row.mobileNumber]);
  }

  Future<int> update(UserContact row) async {
    Database? db = await (instance.database );
    return await db!.rawUpdate(
        'UPDATE $tableContacts SET name = ?, firstName = ?, lastName = ?,isSync = ? WHERE mobileNumber = ?',
        [row.name, row.firstName, row.lastName, 0, row.mobileNumber]);
  }

  Future<int> delete(int id) async {
    Database? db = await (instance.database );
    return await db!
        .delete(tableContacts, where: '$columnId = ?', whereArgs: [id]);
  }
//=====================================contact databse queriesssss

}
