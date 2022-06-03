class Mesaj{
  String? yazi;
  String? gonderen;
  DateTime? zaman;

  Mesaj(this.yazi, this.gonderen, this.zaman);

  Mesaj.fromJson(Map<String, dynamic> json) {
    yazi = json['message'];
    gonderen = json['sendBy'];
    zaman = json['time'];
  }

}