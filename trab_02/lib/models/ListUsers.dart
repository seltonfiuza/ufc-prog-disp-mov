import 'package:trab_02/models/FiveContacts.dart';

class ListUsers {
  List<FiveContacts> userlist;

  ListUsers({this.userlist});
  ListUsers.fromJson(Map<String, dynamic> json) {
    if (json['userlist'] != null) {
      userlist = new List<FiveContacts>();
      json['userlist'].forEach((v) {
        userlist.add(new FiveContacts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userlist != null) {
      // print('aqui');
      data['userlist'] = this.userlist.map((v) => v.toJson()).toList();
    }
    return data;
  }

  getUser(user) {
    for (final u in userlist) {
      if (u.email == user.email) {
        return user;
      }
    }
    return false;
  }

  addUser(user) {
    if (userlist == null) {
      this.userlist = [];
    }
    this.userlist.add(user);
  }
}
