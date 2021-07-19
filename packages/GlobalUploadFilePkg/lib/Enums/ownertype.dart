enum OWNERTYPE_ENUM { PERSON, INSTITUTION }

extension OWNERTYPEEXTENSION on OWNERTYPE_ENUM {
  String get type {
    switch (this) {
      case OWNERTYPE_ENUM.PERSON:
        {
          return 'person';
        }
      case OWNERTYPE_ENUM.INSTITUTION:
        {
          return 'institution';
        }
      default:
        {
          return 'person';
        }
    }
  }
}
