class FiveContacts {
  bool keepLogged;
  String name;
  String email;
  String pass;
  List<FiveContactsList> fiveContacts;

  FiveContacts(
      {this.keepLogged, this.name, this.email, this.pass, this.fiveContacts});

  setName(name) {
    this.name = name;
  }

  setEmail(email) {
    this.email = email;
  }

  setPass() {
    this.pass = pass;
  }

  addContactList(list) {
    if (this.fiveContacts == null) {
      this.fiveContacts = [];
    }
    var a = list.number.map((e) => e.value);
    FiveContactsList b = FiveContactsList(name: list.name, number: a.toList());
    this.fiveContacts.add(b);
    return b;
  }

  FiveContacts.fromJson(Map<String, dynamic> json) {
    keepLogged = json['keep_logged'];
    name = json['name'];
    email = json['email'];
    pass = json['pass'];
    if (json['five_contacts'] != null) {
      fiveContacts = new List<FiveContactsList>();
      json['five_contacts'].forEach((v) {
        fiveContacts.add(new FiveContactsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['keep_logged'] = this.keepLogged;
    data['name'] = this.name;
    data['email'] = this.email;
    data['pass'] = this.pass;
    if (this.fiveContacts != null) {
      data['five_contacts'] = this.fiveContacts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FiveContactsList {
  String name;
  List number;

  FiveContactsList({this.name, this.number});

  FiveContactsList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['phones'] != null) {
      number = json['phones'].cast<String>();
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['number'] = this.number;
    return data;
  }
}
