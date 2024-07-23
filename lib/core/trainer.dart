class Trainer {
  String name;
  int gameID;
  int id;
  Trainer({required this.name, required this.gameID, required this.id});

  Map<String, Object?> toDB() {
    return {"name": name, "gameID": gameID, "id": id, "gender": 0};
  }

  factory Trainer.fromDB(Map<String, dynamic> query) {
    Trainer newTrainer =
        Trainer(name: query['name'], gameID: query['gameID'], id: query['id']);
    return newTrainer;
  }
}
