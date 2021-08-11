enum FOLDER_TYPE_ENUM{
  INBOX,DRAFT,SENT,ARCHIVED,TRASH,JUNK,SPAM,ALL
}

extension FolderTypeExtion on FOLDER_TYPE_ENUM{

  List<String> get list{
    return ["INBOX","Draft","Sent","Archived","Trash","Junk","Spam"];
  }
  String get type {
    switch (this) {
      case FOLDER_TYPE_ENUM.INBOX:
        return "INBOX";
      case FOLDER_TYPE_ENUM.DRAFT:
        return "Draft";
      case FOLDER_TYPE_ENUM.SENT:
        return "Sent";
      case FOLDER_TYPE_ENUM.ARCHIVED:
        return "Archived";
      case FOLDER_TYPE_ENUM.TRASH:
        return "Trash";
      case FOLDER_TYPE_ENUM.JUNK:
        return "Junk";
      case FOLDER_TYPE_ENUM.SPAM:
        return "Spam";
      case FOLDER_TYPE_ENUM.ALL:
        return "All";
      default:
        return "INBOX";
    }
  }

}

extension FolderCheckExtension on String{
  bool get isFolderType{
    return (this == FOLDER_TYPE_ENUM.INBOX.type ||
        this == FOLDER_TYPE_ENUM.DRAFT.type ||
        this == FOLDER_TYPE_ENUM.SENT.type ||
        this == FOLDER_TYPE_ENUM.ARCHIVED.type ||
        this == FOLDER_TYPE_ENUM.TRASH.type ||
        this == FOLDER_TYPE_ENUM.JUNK.type ||
        this == FOLDER_TYPE_ENUM.SPAM.type);
  }
}