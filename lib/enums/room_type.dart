import 'package:oho_works_app/enums/postRecipientType.dart';

enum ROOM_TYPE {
  CLASSROOM, PARENTROOM, STAFFROOM, COMMUNITYROOM
}
class ROOM_TYPES_HELPER {

  bool isRoomTypePost(String type){
    return type==POST_RECIPIENT_TYPE.CLASS.type || type==POST_RECIPIENT_TYPE.PARENT.type || type==POST_RECIPIENT_TYPE.STAFF.type || type==POST_RECIPIENT_TYPE.COMMUNITY.type;
  }

  String roomDes(String type) {
    switch (type) {
      case 'C':
        {
          return 'Class room';
        }
      case 'P':
        {
          return 'Parent room';
        }
      case 'S':
        {
          return 'Staff room';
        }
      case 'CM':
        {
          return 'Community room';
        }
      default :
        {
          return 'Classroom';
        }
    }
  }

  ROOM_TYPE getRoomTypeBasedOnRoomTypeCode(String type_code){
    switch (type_code){
      case "C":{
        return ROOM_TYPE.CLASSROOM;
      }
      case "P":{
        return ROOM_TYPE.PARENTROOM;
      }
      case "S":{
        return ROOM_TYPE.STAFFROOM;
      }
      case 'CM':{
        return ROOM_TYPE.COMMUNITYROOM;
      }
      default :{
        return ROOM_TYPE.COMMUNITYROOM;
      }
    }
  }

  String roomTypeNamebasedonType(ROOM_TYPE room_type){
    switch (room_type){
      case ROOM_TYPE.CLASSROOM:{
        return POST_RECIPIENT_TYPE.CLASS.type;
      }
      case ROOM_TYPE.PARENTROOM:{
        return POST_RECIPIENT_TYPE.PARENT.type;
      }
      case ROOM_TYPE.STAFFROOM:{
        return POST_RECIPIENT_TYPE.STAFF.type;
      }
      case ROOM_TYPE.COMMUNITYROOM:{
        return POST_RECIPIENT_TYPE.COMMUNITY.type;
      }
      default:{
        return POST_RECIPIENT_TYPE.COMMUNITY.type;
      }
    }
  }

}

extension ROOM_TYPE_EXTENSION on ROOM_TYPE{
  String get type{
    switch(this){
      case ROOM_TYPE.CLASSROOM:{
        return 'C';
      }
      case ROOM_TYPE.PARENTROOM:{
        return 'P';
      }
      case ROOM_TYPE.STAFFROOM:{
        return 'S';
      }
      case ROOM_TYPE.COMMUNITYROOM:{
        return 'CM';
      }
      default :{
        return 'C';
      }
    }
  }




}

