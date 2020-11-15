class Call {
  String callerID;
  String callerName;
  String recieverID;
  String recieverName;
  String channelID;
  bool hasDialed;
  Call(
      {this.callerID,
      this.callerName,
      this.channelID,
      this.hasDialed,
      this.recieverID,
      this.recieverName});

  Map<String, dynamic> toMap(Call call) {
    Map<String, dynamic> callMap = Map();
    callMap["caller_id"] = call.callerID;
    callMap["caller_name"] = call.callerName;

    callMap["receiver_id"] = call.recieverID;
    callMap["receiver_name"] = call.recieverName;

    callMap["channel_id"] = call.channelID;
    callMap["has_dialled"] = call.hasDialed;
    return callMap;
  }

  Call.fromMap(Map callMap) {
    this.callerID = callMap["caller_id"];
    this.callerName = callMap["caller_name"];

    this.recieverID = callMap["receiver_id"];
    this.recieverName = callMap["receiver_name"];

    this.channelID = callMap["channel_id"];
    this.hasDialed = callMap["has_dialled"];
  }
}
