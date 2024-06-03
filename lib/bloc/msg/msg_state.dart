part of 'msg_bloc.dart';

class MsgState {
  final List<MsgModel> messages;
  final bool estaEscribiendo;
  final String uidConv;
  final bool reply;
  final String replyDe;
  final String replyMsg;
  final String replyType;

  MsgState({
    this.messages = const [],
    this.estaEscribiendo = false,
    this.uidConv = '',
    this.reply = false,
    this.replyDe = '',
    this.replyMsg = '',
    this.replyType = '',
  });

  MsgState copyWith({
    List<MsgModel>? messages,
    bool? estaEscribiendo,
    String? uidConv,
    bool? reply,
    String? replyDe,
    String? replyMsg,
    String? replyType,
  }) =>
      MsgState(
          messages: messages ?? this.messages,
          estaEscribiendo: estaEscribiendo ?? this.estaEscribiendo,
          uidConv: uidConv ?? this.uidConv,
          reply: reply ?? this.reply,
          replyDe: replyDe ?? this.replyDe,
          replyMsg: replyMsg ?? this.replyMsg,
          replyType: replyType ?? this.replyType);
}
