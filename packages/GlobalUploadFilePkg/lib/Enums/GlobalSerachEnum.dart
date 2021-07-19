enum GLOBAL_SEARCH_ENUM { PERSON, INSTITUTION, POST, ROOM,EVENT,ALL}

extension GLOBAL_SEARCH_ENUM_EXT on GLOBAL_SEARCH_ENUM {
  String get type {
    switch (this) {

      case GLOBAL_SEARCH_ENUM.ALL:
        {
          return 'all';
        }
      case GLOBAL_SEARCH_ENUM.PERSON:
        {
          return 'person';
        }
      case GLOBAL_SEARCH_ENUM.INSTITUTION:
        {
          return 'institution';
        }
      case GLOBAL_SEARCH_ENUM.POST:
        {
          return 'post';
        }
      case GLOBAL_SEARCH_ENUM.ROOM:
        {
          return 'room';
        }
      case GLOBAL_SEARCH_ENUM.EVENT:
        {
          return 'event';
        }

      default:
        {
          return 'person';
        }
    }
  }
}