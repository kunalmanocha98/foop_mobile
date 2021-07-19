enum POST_RECIPIENT_TYPE {
  PUBLIC,PRIVATE,INSTITUTION,CLASS,PARENT,STAFF,COMMUNITY,PERSON,ROOM
}

extension POST_RECIPIENT_TYPE_EXTENSION on POST_RECIPIENT_TYPE{
  String get type{
    switch(this){
      case POST_RECIPIENT_TYPE.ROOM:{
        return 'room';
      }
      case POST_RECIPIENT_TYPE.PUBLIC:{
        return 'public';
      }
      case POST_RECIPIENT_TYPE.PRIVATE:{
        return 'private';
      }
      case POST_RECIPIENT_TYPE.INSTITUTION:{
        return 'institution';
      }
      case POST_RECIPIENT_TYPE.CLASS:{
        return 'class';
      }
      case POST_RECIPIENT_TYPE.PARENT:{
        return 'parent';
      }
      case POST_RECIPIENT_TYPE.STAFF:{
        return 'staff';
      }
      case POST_RECIPIENT_TYPE.COMMUNITY:{
        return 'community';
      }
      default :{
        return 'public';
      }
    }
  }
}