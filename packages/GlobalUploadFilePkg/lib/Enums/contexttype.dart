enum CONTEXTTYPE_ENUM { PROFILE, COVER, FEED, DOC, NOTES, COMMENT }

extension CONTEXTTYPEEXTENSION on CONTEXTTYPE_ENUM {
  String get type {
    switch (this) {
      case CONTEXTTYPE_ENUM.PROFILE:
        {
          return 'profile';
        }
      case CONTEXTTYPE_ENUM.COVER:
        {
          return 'cover';
        }
      case CONTEXTTYPE_ENUM.FEED:
        {
          return 'feed';
        }
      case CONTEXTTYPE_ENUM.DOC:
        {
          return 'doc';
        }
      case CONTEXTTYPE_ENUM.NOTES:
        {
          return 'notes';
        }
      case CONTEXTTYPE_ENUM.COMMENT:
        {
          return 'comment';
        }
      default:
        {
          return 'notes';
        }
    }
  }
}
