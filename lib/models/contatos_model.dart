class ContatosModel {
  List<Contatos>? contatos = [];

  ContatosModel(this.contatos);

  ContatosModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      contatos = <Contatos>[];
      json['results'].forEach((v) {
        contatos!.add(Contatos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (contatos != null) {
      data['results'] = contatos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contatos {
  String _objectId = "";
  String _name = "";
  String _phone = "";
  String _photoURL = "";
  String _createdAt = "";
  String _updatedAt = "";

  Contatos(this._name, this._phone, this._photoURL, this._createdAt, this._updatedAt);
  Contatos.create(this._name, this._phone, this._photoURL);
  Contatos.update(this._objectId, this._name, this._phone, this._photoURL);
  Contatos.updateNoPhoto(this._objectId, this._name, this._phone);

  String get objectId => _objectId;
  set objectId(String objectId) => _objectId = objectId;
  String get name => _name;
  set name(String name) => _name = name;
  String get phone => _phone;
  set phone(String phone) => _phone = phone;
  String get photoURL => _photoURL;
  set photoURL(String photoURL) => _photoURL = photoURL;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;

  Contatos.fromJson(Map<String, dynamic> json) {
    _objectId = json['objectId'];
    _name = json['name'];
    _phone = json['phone'];
    _photoURL = json['photoURL'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = _objectId;
    data['name'] = _name;
    data['phone'] = _phone;
    data['photoURL'] = _photoURL;
    return data;
  }

   Map<String, dynamic> toJsonEndpointNoPhoto() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = _objectId;
    data['name'] = _name;
    data['phone'] = _phone;
    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = _objectId;
    data['name'] = _name;
    data['phone'] = _phone;
    data['photoURL'] = _photoURL;
    data['createdAt'] = _createdAt;
    data['updatedAt'] = _updatedAt;
    return data;
  }
}
