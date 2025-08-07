import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? photoUrl;
  final UserRole role;
  final bool isActive;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? businessInfo;
  final NotificationSettings notificationSettings;
  final Map<String, dynamic>? metadata;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.photoUrl,
    required this.role,
    required this.isActive,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
    this.businessInfo,
    required this.notificationSettings,
    this.metadata,
  });

  // Constructor desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'],
      photoUrl: json['photoUrl'],
      role: UserRole.fromString(json['role'] ?? 'user'),
      isActive: json['isActive'] ?? true,
      isEmailVerified: json['isEmailVerified'] ?? false,
      createdAt: json['createdAt'] is Timestamp 
        ? (json['createdAt'] as Timestamp).toDate()
        : DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] is Timestamp 
        ? (json['updatedAt'] as Timestamp).toDate()
        : DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      businessInfo: json['businessInfo'],
      notificationSettings: NotificationSettings.fromJson(
        json['notificationSettings'] ?? {},
      ),
      metadata: json['metadata'],
    );
  }

  // Constructor desde Firestore
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({
      'id': doc.id,
      ...data,
    });
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'photoUrl': photoUrl,
      'role': role.value,
      'isActive': isActive,
      'isEmailVerified': isEmailVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'businessInfo': businessInfo,
      'notificationSettings': notificationSettings.toJson(),
      'metadata': metadata,
    };
  }

  // Convertir a Firestore (sin ID)
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  // Copiar con modificaciones
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? photoUrl,
    UserRole? role,
    bool? isActive,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? businessInfo,
    NotificationSettings? notificationSettings,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      businessInfo: businessInfo ?? this.businessInfo,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      metadata: metadata ?? this.metadata,
    );
  }

  // Getters útiles
  String get displayName => name.isNotEmpty ? name : email.split('@').first;
  
  bool get hasBusinessInfo => businessInfo != null && businessInfo!.isNotEmpty;
  
  String? get businessName => businessInfo?['name'];
  
  String? get businessAddress => businessInfo?['address'];
  
  bool get isPremium => role == UserRole.premium || role == UserRole.admin;
  
  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, role: ${role.value})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Enum para roles de usuario
enum UserRole {
  user('user'),
  premium('premium'),
  admin('admin');

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.user,
    );
  }
}

// Modelo para configuración de notificaciones
class NotificationSettings {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool salesAlerts;
  final bool inventoryAlerts;
  final bool reportAlerts;
  final bool promotionAlerts;

  NotificationSettings({
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.salesAlerts = true,
    this.inventoryAlerts = true,
    this.reportAlerts = true,
    this.promotionAlerts = true,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      emailNotifications: json['emailNotifications'] ?? true,
      pushNotifications: json['pushNotifications'] ?? true,
      salesAlerts: json['salesAlerts'] ?? true,
      inventoryAlerts: json['inventoryAlerts'] ?? true,
      reportAlerts: json['reportAlerts'] ?? true,
      promotionAlerts: json['promotionAlerts'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'salesAlerts': salesAlerts,
      'inventoryAlerts': inventoryAlerts,
      'reportAlerts': reportAlerts,
      'promotionAlerts': promotionAlerts,
    };
  }

  NotificationSettings copyWith({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? salesAlerts,
    bool? inventoryAlerts,
    bool? reportAlerts,
    bool? promotionAlerts,
  }) {
    return NotificationSettings(
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      salesAlerts: salesAlerts ?? this.salesAlerts,
      inventoryAlerts: inventoryAlerts ?? this.inventoryAlerts,
      reportAlerts: reportAlerts ?? this.reportAlerts,
      promotionAlerts: promotionAlerts ?? this.promotionAlerts,
    );
  }
}