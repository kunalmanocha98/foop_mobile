enum DEEPLINKTYPE { PERSON, INSTITUTION,POST ,ROOMS,CALENDAR}

extension DeeplinkTypeExt on DEEPLINKTYPE {
  String get type {
    switch (this) {
      case DEEPLINKTYPE.PERSON:
        {
          return 'PERSON';
        }
      case DEEPLINKTYPE.INSTITUTION:
        {
          return 'INSTITUTION';
        }
      case DEEPLINKTYPE.POST:
        {
          return 'POST';
        }
      case DEEPLINKTYPE.ROOMS:
        {
          return 'ROOMS';
        }
      case DEEPLINKTYPE.CALENDAR:
        {
          return 'CALENDAR';
        }
      default:
        {
          return 'PERSON';
        }
    }
  }
}
