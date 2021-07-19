class ConversationsApi {
/*  Future<dynamic> getConversationsList(String data,BuildContext context) async{
//var map = conversation.toMap();

    print(data);
    var headers = {
      "Content-Type": 'application/json',
      "sessionId": '76d75fb0-795e-4cdb-ae6e-56025cd41f38'
    };
    final _url = Config.LIST_CONVERSATIONS_URL;
    print("######################"+_url);
    return _netUtil.post(context,_url, body: data,headers:headers).then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }


  Future<dynamic> getConversationMessagesList(BuildContext context,Map<String,String> map) async{
    var data = json.encode(map);
    print(data);
    var headers = {
      "Content-Type": 'application/json'
    };
    final _url = Config.LIST_CONVERSATION_MESSAGES_URL;
    return _netUtil.post(context,_url, body: data,headers:headers).then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }

  Future<dynamic> createConversation(BuildContext context,Map<String,dynamic> map) async{
    var data = json.encode(map);
    print(data);
    var headers = {
      "Content-Type": 'application/json'
    };
    final _url = Config.CREATE_CONVERSATION_URL;
    return _netUtil.post(context,_url, body: data,headers:headers).then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }

  Future<dynamic> createConversationMessage(BuildContext context,Map<String,dynamic> map) async{
    var data = json.encode(map);
    print(data);
    var headers = {
      "Content-Type": 'application/json'
    };
    final _url = Config.CREATE_CONVERSATION_MESSAGE_URL;
    return _netUtil.post(context,_url, body: data,headers:headers).then((dynamic res) {
      return _decoder.convert(res.toString());
    });
  }*/
}
