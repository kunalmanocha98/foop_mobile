enum MEMBER_ADD_METHOD { DIRECT, AUTOMATIC, JOIN, INVITE }

extension MEMBER_ADD_METHOD_EXTENSION on MEMBER_ADD_METHOD {
  String get type {
    switch (this) {
      case MEMBER_ADD_METHOD.DIRECT:
        {
          return 'D';
        }
      case MEMBER_ADD_METHOD.AUTOMATIC:
        {
          return 'A';
        }
      case MEMBER_ADD_METHOD.JOIN:
        {
          return 'J';
        }
      case MEMBER_ADD_METHOD.INVITE:
        {
          return 'I';
        }
      default:
        {
          return 'type';
        }
    }
  }
}

enum MEMBERSHIP_STATUS {
  ACTIVE,
  TERMINATED,
  SUSPENDED,
  APPLIED,
  REJECTED,
  REMOVED,
  INVITED
}

extension MEMBERSHIP_STATUS_EXTENSION on MEMBERSHIP_STATUS {
  String get type {
    switch (this) {
      case MEMBERSHIP_STATUS.ACTIVE:
        {
          return 'A';
        }
      case MEMBERSHIP_STATUS.TERMINATED:
        {
          return 'T';
        }
      case MEMBERSHIP_STATUS.SUSPENDED:
        {
          return 'S';
        }
      case MEMBERSHIP_STATUS.APPLIED:
        {
          return 'P';
        }
      case MEMBERSHIP_STATUS.REJECTED:
        {
          return 'R';
        }
      case MEMBERSHIP_STATUS.REMOVED:
        {
          return 'M';
        }
      case MEMBERSHIP_STATUS.INVITED:
        {
          return 'I';
        }
      default:
        {
          return 'type';
        }
    }
  }
}

enum MEMBERSHIP_ROLE { remove, accept, reject }

extension MEMBERSHIP_ROLE_EXTENSION on MEMBERSHIP_ROLE {
  String get type {
    switch (this) {
      case MEMBERSHIP_ROLE.remove:
        {
          return 'remove';
        }
      case MEMBERSHIP_ROLE.accept:
        {
          return 'accept';
        }
      case MEMBERSHIP_ROLE.reject:
        {
          return 'reject';
        }
      default:
        {
          return 'type';
        }
    }
  }
}
