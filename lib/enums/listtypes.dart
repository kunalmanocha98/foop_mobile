enum LIST_TYPES { follower, following }

extension LIST_TYPES_EXTENSION on LIST_TYPES {
  String get type {
    switch (this) {
      case LIST_TYPES.follower:
        {
          return 'follower';
        }
      case LIST_TYPES.following:
        {
          return 'following';
        }
      default:
        {
          return 'type';
        }
    }
  }

  String get name {
    switch (this) {
      case LIST_TYPES.follower:
        {
          return 'follower';
        }
      case LIST_TYPES.following:
        {
          return 'following';
        }
      default:
        {
          return 'type';
        }
    }
  }
}
