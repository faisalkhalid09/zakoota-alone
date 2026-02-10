import 'package:cloud_firestore/cloud_firestore.dart';

class CaseAttachment {
  final String title;
  final String fileUrl;
  final String fileType;

  CaseAttachment({
    required this.title,
    required this.fileUrl,
    required this.fileType,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'fileUrl': fileUrl,
      'fileType': fileType,
    };
  }

  factory CaseAttachment.fromMap(Map<String, dynamic> map) {
    return CaseAttachment(
      title: map['title'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      fileType: map['fileType'] ?? 'unknown',
    );
  }
}

class CaseModel {
  final String caseId;
  final String clientId;
  final String title;
  final String description;
  final String category;
  final String city;
  final double budgetMin;
  final double budgetMax;
  final String meetingPreference; // 'in_person' or 'virtual'
  final List<CaseAttachment> attachments;
  final String status; // 'open', 'active', 'closed', 'cancelled'
  final int proposalCount;
  final DateTime createdAt;
  final bool isAdVisible;
  final int viewsCount;
  final int savesCount;

  CaseModel({
    required this.caseId,
    required this.clientId,
    required this.title,
    required this.description,
    required this.category,
    required this.city,
    required this.budgetMin,
    required this.budgetMax,
    required this.meetingPreference,
    required this.attachments,
    required this.status,
    required this.proposalCount,
    required this.createdAt,
    this.isAdVisible = true,
    this.viewsCount = 0,
    this.savesCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'caseId': caseId,
      'clientId': clientId,
      'title': title,
      'description': description,
      'category': category,
      'city': city,
      'budgetMin': budgetMin,
      'budgetMax': budgetMax,
      'meetingPreference': meetingPreference,
      'attachments': attachments.map((x) => x.toMap()).toList(),
      'status': status,
      'proposalCount': proposalCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'isAdVisible': isAdVisible,
      'viewsCount': viewsCount,
      'savesCount': savesCount,
    };
  }

  factory CaseModel.fromMap(Map<String, dynamic> map, String id) {
    return CaseModel(
      caseId: id,
      clientId: map['clientId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      city: map['city'] ?? '',
      budgetMin: (map['budgetMin'] ?? 0).toDouble(),
      budgetMax: (map['budgetMax'] ?? 0).toDouble(),
      meetingPreference: map['meetingPreference'] ?? 'in_person',
      attachments: (map['attachments'] as List<dynamic>?)
              ?.map((x) => CaseAttachment.fromMap(x))
              .toList() ??
          [],
      status: map['status'] ?? 'open',
      proposalCount: map['proposalCount'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isAdVisible: map['isAdVisible'] ?? true,
      viewsCount: map['viewsCount'] ?? 0,
      savesCount: map['savesCount'] ?? 0,
    );
  }
}
