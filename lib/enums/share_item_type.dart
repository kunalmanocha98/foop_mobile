enum SHAREITEMTYPE { PROFILE, DETAIL }

extension DeeplinkTypeExt on SHAREITEMTYPE {
  String get type {
    switch (this) {
      case SHAREITEMTYPE.PROFILE:
        {
          return 'profile';
        }
      case SHAREITEMTYPE.DETAIL:
        {
          return 'detail';
        }

      default:
        {
          return 'PERSON';
        }
    }
  }
}
