class Message {
  final bool isSentByMe;
  final String content;
  final int idMessage;
  final String time;

  Message(
      {required this.isSentByMe,
      required this.content,
      required this.idMessage,
      required this.time});
}
