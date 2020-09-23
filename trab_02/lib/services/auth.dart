import 'package:shared_preferences/shared_preferences.dart';
import 'package:trab_02/models/FiveContacts.dart';
import 'dart:convert';

import 'package:trab_02/models/ListUsers.dart';

class Auth {
  String _key = 'trab02_userlist';
  FiveContacts user;
  ListUsers listuser = ListUsers();
  int index;

  Future<Auth> getLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    var userList = prefs.getString(_key);
    if (userList != null) {
      var parsedJson = json.decode(userList);
      ListUsers userlist = new ListUsers.fromJson(parsedJson);
      this.listuser = userlist;
      for (final u in userlist.userlist) {
        if (u.keepLogged) {
          this.user = u;
          return this;
        }
      }
    } else {
      return null;
    }
  }

  Future<bool> hasData() async {
    final prefs = await SharedPreferences.getInstance();
    var userList = prefs.getString(_key);
    if (userList != null) {
      var parsedJson = json.decode(userList);
      ListUsers userlist = new ListUsers.fromJson(parsedJson);
      this.listuser = userlist;
      for (final u in userlist.userlist) {
        if (u.keepLogged) {
          this.user = u;
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  addNewUser(user) async {
    if (this.listuser.userlist != null) {
      if (this.listuser.userlist.length != 0) {
        this.listuser.userlist.forEach((element) {
          if (element.email == user.email) {
            return false;
          }
        });
      }
    }
    await this.listuser.addUser(user);
    // print(this.listuser);
    await this.saveListWithNewKeep(user, null);
    return true;
  }

  keepLogged(value) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      var _index = listuser.userlist.indexOf(this.user);
      if (value != null) {
        listuser.userlist[_index].keepLogged = value;
      }
      prefs.setString(_key, JsonEncoder().convert(this.listuser.toJson()));
    } catch (e) {
      return false;
    }
    return true;
  }

  addContactList(contactList) {
    this.user.addContactList(contactList);
    return this.user.fiveContacts;
  }

  resetContactList() {
    this.user.fiveContacts = [];
  }

  saveOnDevice() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, JsonEncoder().convert(this.listuser.toJson()));
  }

  saveListWithNewKeep(user, value) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      var _index = listuser.userlist.indexOf(this.user);
      if (_index != -1) {
        if (listuser.userlist[_index].keepLogged == value) {
          return false;
        }
        if (value != null) {
          listuser.userlist[_index].keepLogged = value;
        }
        print(JsonEncoder().convert(this.listuser.toJson()));
        print(this.listuser.toJson());
        prefs.setString(_key, JsonEncoder().convert(this.listuser.toJson()));
        this.setUser(user);
      } else {
        prefs.setString(_key, JsonEncoder().convert(this.listuser.toJson()));
        this.setUser(user);
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  login(email, password, keep) async {
    if (this.listuser.userlist == null) {
      return false;
    }
    for (final u in this.listuser.userlist) {
      if (u.email == email && u.pass == password) {
        this.saveListWithNewKeep(u, keep);
        return true;
      }
    }
    return false;
  }

  getUser() {
    if (this.user != null) {
      return this.user;
    } else {
      return false;
    }
  }

  getUserList() {
    return this.listuser;
  }

  setUser(user) {
    this.user = user;
  }
}
