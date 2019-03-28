import 'package:allozoe_livreur/Database/DatabaseHelper.dart';
import 'package:allozoe_livreur/Models/Client.dart';

abstract class AccountContract {
  void onLoadingSuccess(Client client);
  void onLoadingError();
  void onConnectionError();
}

class AccountPresenter {
  AccountContract _view;
  AccountPresenter(this._view);

  account() {
    var db = new DatabaseHelper();
    db.getClient().then((List<Client> clients) {
      if (clients != null && clients.length != 0) {
        this._view.onLoadingSuccess(new Client(clients[0].id,
            clients[0].username, clients[0].email, clients[0].email));
      } else {
        print("client account ");
        this._view.onLoadingError();
      }
    }).catchError((onError) {
      print("client account ");
      this._view.onLoadingError();
    });
  }
}
