enum OWNERTYPE { person, institution }

extension OwnerTypeExtension on OWNERTYPE {
  String get type {
    switch (this) {
      case OWNERTYPE.person:
        {
          return 'person';
        }
      case OWNERTYPE.institution:
        {
          return 'institution';
        }
      default:
        {
          return 'type';
        }
    }
  }
}
