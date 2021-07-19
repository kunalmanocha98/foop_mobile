enum DictionaryType {
  posting_by,
  post_visible_to,
  user_privacy_visible_to,
  network_type,
  goals_objectivies_visible_to,
  rating_visible_to,
  rating_by,
  profile_visible_to,
  ROOMTYPE
}

extension DictionaryTypeExtension on DictionaryType {
  String get name {
    switch (this) {
      case DictionaryType.posting_by:
        {
          return 'posting_by';
        }

      case DictionaryType.profile_visible_to:
        {
          return 'profile_visible_to';
        }
      case DictionaryType.post_visible_to:
        {
          return 'post_visible_to';
        }
      case DictionaryType.user_privacy_visible_to:
        {
          return 'user_privacy_visible_to';
        }
      case DictionaryType.network_type:
        {
          return 'network_type';
        }
      case DictionaryType.goals_objectivies_visible_to:
        {
          return 'goals_objectivies_visible_to';
        }
      case DictionaryType.rating_visible_to:
        {
          return 'rating_visible_to';
        }
      case DictionaryType.rating_by:
        {
          return 'rating_by';
        }
      case DictionaryType.ROOMTYPE:
        {
          return 'ROOMTYPE';
        }
      default:
        {
          return 'type';
        }
    }
  }
}
