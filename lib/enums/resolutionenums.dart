enum RESOLUTION_TYPE{
  R64,R128,R256,R512,NULL
}

extension RESOLUTION_TYPE_EXTENSION on RESOLUTION_TYPE?{
  String? get type {
    switch(this){
      case RESOLUTION_TYPE.R64:{
        return "64";
      }
      case RESOLUTION_TYPE.R128:{
        return "128";
      }
      case RESOLUTION_TYPE.R256:{
        return "256";
      }
      case RESOLUTION_TYPE.R512:{
        return "512";
      }
      case RESOLUTION_TYPE.NULL:{
        return null;
      }
      default :{
        return "128";
      }
    }
  }
}