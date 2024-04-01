class User {
  int? id;
  String? firstname;
  String? lastname;
  String? email;
  String? password;

  User({this.id, this.firstname, this.lastname, this.email, this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      email: map['email'],
      password: map['password'],
    );
  }
}

class Tasks {
  final String id;
  late String title;
  late String description;
  late String status;
  bool isSelected;

  Tasks({
    required this.id,
    required String title,
    required String description,
    required String status,
    this.isSelected = false,
  })  : title = title,
        description = description,
        status = status;

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Tasks(id: $id, title: $title, description: $description, status: $status, isSelected: $isSelected)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
    };
  }
}

class UserModel {
  int? id;
  String? firstname;
  String? lastname;
  String? email;
  String? password;

  UserModel({this.id, this.firstname, this.lastname, this.email, this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      email: map['email'],
      password: map['password'],
    );
  }
}

class TaskModel {
  final String id;
  String title;
  String description;
  String status;
  bool isSelected;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.isSelected = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
    );
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, description: $description, status: $status, isSelected: $isSelected)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
    };
  }
}