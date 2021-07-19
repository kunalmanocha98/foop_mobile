enum POST_RECIPIENT_STATUS{
  READ,UNREAD,HIDDEN,READING
}

extension POST_RECIPIENT_STATUS_EXTENSION on POST_RECIPIENT_STATUS{
  String get status{
    switch(this){
      case POST_RECIPIENT_STATUS.READ:{
        return 'read';
      }
      case POST_RECIPIENT_STATUS.READING:{
        return 'reading';
      }
      case POST_RECIPIENT_STATUS.UNREAD:{
        return 'unread';
      }
      case POST_RECIPIENT_STATUS.HIDDEN:{
        return 'hidden';
      }
      default :{
        return 'read';
      }
    }
  }
}


enum POST_TYPE{
GENERAL,NOTICE,BLOG,QNA,NEWS,ALL,BOOKMARK,POLL,ASSIGNMENT
}

extension POST_TYPE_EXTENSION on POST_TYPE{
  String get status{
    switch(this){
      case POST_TYPE.ALL:{
        return 'all';
      }
      case POST_TYPE.GENERAL:{
        return 'general';
      }
      case POST_TYPE.NOTICE:{
        return 'notice';
      }
      case POST_TYPE.BLOG:{
        return 'blog';
      }
      case POST_TYPE.QNA:{
        return 'qa';
      }
      case POST_TYPE.NEWS:{
        return 'news';
      }
      case POST_TYPE.BOOKMARK:{
        return 'bookmark';
      }
      case POST_TYPE.POLL:{
        return 'poll';
      }
      case POST_TYPE.ASSIGNMENT:{
        return 'assignment';
      }
      default :{
        return 'general';
      }
    }
  }
}


