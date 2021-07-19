enum REQUESTED_BY_TYPE {
  institution,
  global,
  person,
  institution_follower,
  others
}

extension REQUESTED_BY_TYPE_EXTENSION on REQUESTED_BY_TYPE {
  String get type {
    switch (this) {
      case REQUESTED_BY_TYPE.institution:
        {
          return 'institution';
        }
      case REQUESTED_BY_TYPE.global:
        {
          return 'global';
        }
      case REQUESTED_BY_TYPE.person:
        {
          return 'person';
        }
      case REQUESTED_BY_TYPE.institution_follower:
        {
          return 'institution_follower';
        }
      case REQUESTED_BY_TYPE.others:
        {
          return 'others';
        }
      default:
        {
          return 'type';
        }
    }
  }

  String get name {
    switch (this) {
      case REQUESTED_BY_TYPE.institution:
        {
          return 'institution';
        }
      case REQUESTED_BY_TYPE.global:
        {
          return 'global';
        }
      case REQUESTED_BY_TYPE.person:
        {
          return 'person';
        }
      case REQUESTED_BY_TYPE.institution_follower:
        {
          return 'institution_follower';
        }
      case REQUESTED_BY_TYPE.others:
        {
          return 'others';
        }
      default:
        {
          return 'type';
        }
    }
  }
}
