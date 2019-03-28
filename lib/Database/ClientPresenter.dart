import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Client.dart';

class ClientPresenter {
  ClientPresenter();

  Client getClient() {
    var db = new DatabaseHelper();
    db.getClient().then((List<Client> clients) {
      if (clients == null || clients.length == 0)
        return clients[0];
      else
        return null as Client;
    }).catchError((onError) {});
  }

  int saveClient(Client client) {
    var db = new DatabaseHelper();

    if (getClient() != null) {}
  }
}
