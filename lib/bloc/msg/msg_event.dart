part of 'msg_bloc.dart';

@immutable
abstract class MsgEvent {}

class SetMsgs extends MsgEvent {
  final List<MsgModel> messages;

  SetMsgs(this.messages);
}

class SetEscribiendo extends MsgEvent {
  final bool estaEscribiendo;

  SetEscribiendo(this.estaEscribiendo);
}

class SetUidConv extends MsgEvent {
  final String uidConv;

  SetUidConv(this.uidConv);
}

class SetReplyChat extends MsgEvent {
  final bool reply;
  final String replyDe;
  final String replyMsg;
  final String replyType;
  SetReplyChat(
    this.reply,
    this.replyDe,
    this.replyMsg,
    this.replyType,
  );
}
