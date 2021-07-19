enum BUDDY_QUESTION_TYPE{
  NAME,CLASS_NAME,INSTITUTION_NAME, USER_ROLE
}

extension BuddyQuestionExtension on BUDDY_QUESTION_TYPE{
  String get typeName{
    switch(this){
      case BUDDY_QUESTION_TYPE.CLASS_NAME:{
        return "class_name";
      }
      case BUDDY_QUESTION_TYPE.INSTITUTION_NAME:{
        return "institution_name";
      }
      case BUDDY_QUESTION_TYPE.USER_ROLE:{
        return "user_role";
      }
      case BUDDY_QUESTION_TYPE.NAME:{
        return "name";
      }
      default :{
        return "name";
      }
    }
  }
}