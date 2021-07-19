enum IMAGETYPE { profile, cover }

extension ImageTypeExtension on IMAGETYPE {
  String get type {
    switch (this) {
      case IMAGETYPE.profile:
        {
          return 'profile';
        }
      case IMAGETYPE.cover:
        {
          return 'cover';
        }
      default:
        {
          return 'type';
        }
    }
  }
}
