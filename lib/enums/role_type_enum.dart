enum EVENT_ROLE_TYPE{
  host, cohost, speaker, listener
}

extension EVENT_ROLE_TYPE_EXTENSION on EVENT_ROLE_TYPE{
  String get type {
    switch(this){
      case EVENT_ROLE_TYPE.speaker:{
        return 'speaker';
      }
      case EVENT_ROLE_TYPE.listener:{
        return 'listener';
      }
      case EVENT_ROLE_TYPE.host:{
        return 'host';
      }
      case EVENT_ROLE_TYPE.cohost:{
        return 'cohost';
      }
      default:{
        return 'listener';
      }
    }
  }
}