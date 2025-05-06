class AuthModel {
  final String token;
  final String email;
  final String refreshToken;
  final int expiresIn;
  final String id;
  final DateTime? expiresAt;

  AuthModel({
    required this.token,
    required this.email,
    required this.refreshToken,
    required this.expiresIn,
    required this.id,
    this.expiresAt,
  });

  AuthModel copyWith({
    String? token,
    String? email,
    String? refreshToken,
    int? expiresIn,
    String? id,
    DateTime? expiresAt,
  }) {
    return AuthModel(
      token: token ?? this.token,
      email: email ?? this.email,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresIn: expiresIn ?? this.expiresIn,
      id: id ?? this.id,
      expiresAt: expiresAt ?? _getExpiryDate,
    );
  }

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['idToken'],
      email: json['email'],
      refreshToken: json['refreshToken'],
      expiresIn: int.parse(json['expiresIn']),
      id: json['localId'],
      expiresAt: DateTime.tryParse(json["expiresAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idToken": token,
      "email": email,
      "refreshToken": refreshToken,
      "expiresIn": expiresIn.toString(),
      "localId": id,
      "expiresAt": expiresAt.toString(),
    };
  }

  DateTime get _getExpiryDate {
    return DateTime.now().add(Duration(seconds: expiresIn));
  }
}
