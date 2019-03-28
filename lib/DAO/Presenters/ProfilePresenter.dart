import 'package:allozoe_livreur/DAO/Rest_dt.dart';
import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Client.dart';
import 'package:allozoe_livreur/Models/Note.dart';

abstract class ProfileContract {
  void onLoadingSuccess(Client client);
  void onLoadingError();
  void onConnectionError();
  void onLogoutError();
}

class ProfilePresenter {
  ProfileContract _view;
  RestDatasource api = new RestDatasource();
  ProfilePresenter();
  DatabaseHelper db;

  loadProfile(Client client) {
    _view.onLoadingSuccess(client);
  }

  Future<bool> doLogout(int livreur) {
    return api.logout(livreur).then((status) {
      if (status)
        return true;
      else
        return false;
    }).catchError((onError) {
      return false;
    });
  }

  Future<Note> getDeliverInfos(int livreur) {
    return api.getDeliver(livreur).then((note) {
      print(note.toString());
      return note;
    }).catchError((onError) {
      return false;
    });
  }
}
