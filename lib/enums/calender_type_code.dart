enum CALENDERTYPECODE{
  EVENT,TASK,GOAL, REMINDER,ASSIGNMENTS
}

extension CALENDERTYPEEXTENSION on CALENDERTYPECODE{
  String get type{
    switch(this){
      case CALENDERTYPECODE.TASK:{
        return 'T';
      }
      case CALENDERTYPECODE.ASSIGNMENTS:{
        return 'A';
      }
      case CALENDERTYPECODE.GOAL:{
        return 'G';
      }
      case CALENDERTYPECODE.REMINDER:{
        return 'R';
      }
      case CALENDERTYPECODE.EVENT:{
        return 'E';
      }
      default:{
        return 'E';
      }
    }
  }
}

