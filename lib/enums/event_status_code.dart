enum EVENT_STATUS {
  TENTATIVE,DELETED,CANCELLED,RESCHEDULED,LIVE,CLOSED,ACTIVE,INACTIVE,ENDED,NOTSTARTED
}
extension EVENT_STATUS_ENUM on EVENT_STATUS{
  String get status{
    switch(this){
      case EVENT_STATUS.TENTATIVE:{
        return 'TENTATIVE';
      }
      case EVENT_STATUS.ACTIVE:{
        return 'ACTIVE';
      }
      case EVENT_STATUS.INACTIVE:{
        return 'INACTIVE';
      }
      case EVENT_STATUS.ENDED:{
        return 'ENDED';
      }
      case EVENT_STATUS.NOTSTARTED:{
        return 'NOTSTARTED';
      }
      case EVENT_STATUS.DELETED:{
        return 'DELETED';
      }
      case EVENT_STATUS.CANCELLED:{
        return 'CANCELLED';
      }
      case EVENT_STATUS.RESCHEDULED:{
        return 'RESCHEDULED';
      }
      case EVENT_STATUS.LIVE:{
        return 'LIVE';
      }
      case EVENT_STATUS.CLOSED:{
        return 'CLOSED';
      }
      default :{
        return 'ACTIVE';
      }
    }
  }
}