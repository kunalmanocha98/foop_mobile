enum PERSON_TYPE {
  TEACHER,
  STUDENT,
  PARENT,
  ALUMNI,
  ADMINISTRATION,
  MANAGEMENT
}

extension PERSON_TYPE_EXTENSION on PERSON_TYPE {
  String get type {
    switch (this) {
      case PERSON_TYPE.TEACHER:
        {
          return 'T';
        }
      case PERSON_TYPE.STUDENT:
        {
          return 'S';
        }
      case PERSON_TYPE.PARENT:
        {
          return 'P';
        }
      case PERSON_TYPE.ALUMNI:
        {
          return 'L';
        }
      case PERSON_TYPE.ADMINISTRATION:
        {
          return 'A';
        }
      case PERSON_TYPE.MANAGEMENT:
        {
          return 'M';
        }
      default:
        {
          return 'type';
        }
    }
  }

  String get name {
    switch (this) {
      case PERSON_TYPE.TEACHER:
        {
          return 'TEACHER';
        }
      case PERSON_TYPE.STUDENT:
        {
          return 'STUDENT';
        }
      case PERSON_TYPE.PARENT:
        {
          return 'PARENT';
        }
      case PERSON_TYPE.ALUMNI:
        {
          return 'ALUMNI';
        }
      case PERSON_TYPE.ADMINISTRATION:
        {
          return 'ADMINISTRATION';
        }
      case PERSON_TYPE.MANAGEMENT:
        {
          return 'MANAGEMENT';
        }
      default:
        {
          return 'type';
        }
    }
  }

  bool containsValue(List<String> list, PERSON_TYPE person_type){
    return list.contains(person_type.type);
  }
}
