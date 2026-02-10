import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/case_model.dart';

class CaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  Future<void> createCase({
    required String clientId,
    required String title,
    required String description,
    required String category,
    required String city,
    required double budgetMin,
    required double budgetMax,
    required String meetingPreference,
    required List<Map<String, dynamic>>
        attachments, // List of {file: File, title: String}
  }) async {
    try {
      final String caseId = _uuid.v4();
      List<CaseAttachment> caseAttachments = [];

      // 1. Upload attachments
      for (var attachment in attachments) {
        File file = attachment['file'] as File;
        String title = attachment['title'] as String;
        String fileName = file.path.split(Platform.pathSeparator).last;
        String extension = fileName.split('.').last;

        Reference ref = _storage.ref().child('cases/$caseId/$fileName');
        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        caseAttachments.add(CaseAttachment(
          title: title,
          fileUrl: downloadUrl,
          fileType: extension,
        ));
      }

      // 2. Create Case Model
      final newCase = CaseModel(
        caseId: caseId,
        clientId: clientId,
        title: title,
        description: description,
        category: category,
        city: city,
        budgetMin: budgetMin,
        budgetMax: budgetMax,
        meetingPreference: meetingPreference,
        attachments: caseAttachments,
        status: 'open',
        proposalCount: 0,
        createdAt: DateTime.now(),
      );

      // 3. Save to Firestore
      await _firestore.collection('cases').doc(caseId).set(newCase.toMap());
    } catch (e) {
      throw Exception('Failed to create case: $e');
    }
  }

  // Toggle Ad Visibility
  Future<void> toggleAdVisibility(String caseId, bool isVisible) async {
    try {
      await _firestore
          .collection('cases')
          .doc(caseId)
          .update({'isAdVisible': isVisible});
    } catch (e) {
      throw Exception('Failed to update ad visibility: $e');
    }
  }

  // Increment View Count
  Future<void> incrementViewCount(String caseId) async {
    try {
      await _firestore
          .collection('cases')
          .doc(caseId)
          .update({'viewsCount': FieldValue.increment(1)});
    } catch (e) {
      // Fail silently for analytics updates
      print('Failed to increment view count: $e');
    }
  }

  // Update Case with History
  Future<void> updateCase(
      String caseId, Map<String, dynamic> updates, CaseModel oldCase) async {
    try {
      // 1. Create History Record
      await _firestore
          .collection('cases')
          .doc(caseId)
          .collection('history')
          .add({
        'updatedAt': FieldValue.serverTimestamp(),
        'previousTitle': oldCase.title,
        'previousDescription': oldCase.description,
        'previousBudgetMin': oldCase.budgetMin,
        'previousBudgetMax': oldCase.budgetMax,
      });

      // 2. Update Main Doc
      await _firestore.collection('cases').doc(caseId).update(updates);
    } catch (e) {
      throw Exception('Failed to update case: $e');
    }
  }

  // Add Attachment
  Future<void> addAttachment(String caseId, File file, String title) async {
    try {
      String fileName =
          '${_uuid.v4()}_${file.path.split(Platform.pathSeparator).last}';
      String extension = fileName.split('.').last;

      Reference ref = _storage.ref().child('cases/$caseId/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      final newAttachment = CaseAttachment(
        title: title,
        fileUrl: downloadUrl,
        fileType: extension,
      );

      await _firestore.collection('cases').doc(caseId).update({
        'attachments': FieldValue.arrayUnion([newAttachment.toMap()]),
      });
    } catch (e) {
      throw Exception('Failed to add attachment: $e');
    }
  }

  // Delete Attachment
  Future<void> deleteAttachment(
      String caseId, CaseAttachment attachment) async {
    try {
      // 1. Delete from Storage
      try {
        final ref = _storage.refFromURL(attachment.fileUrl);
        await ref.delete();
      } catch (e) {
        print('Error deleting file from storage: $e');
        // Continue to delete from Firestore even if storage delete fails (e.g. file not found)
      }

      // 2. Remove from Firestore
      await _firestore.collection('cases').doc(caseId).update({
        'attachments': FieldValue.arrayRemove([attachment.toMap()]),
      });
    } catch (e) {
      throw Exception('Failed to delete attachment: $e');
    }
  }

  // Update Attachment Title
  Future<void> updateAttachmentTitle(
      String caseId, CaseAttachment attachment, String newTitle) async {
    try {
      final newAttachment = CaseAttachment(
        title: newTitle,
        fileUrl: attachment.fileUrl,
        fileType: attachment.fileType,
      );

      // Firestore array updates require removing the old complete object and adding the new one
      await _firestore.collection('cases').doc(caseId).update({
        'attachments': FieldValue.arrayRemove([attachment.toMap()]),
      });

      await _firestore.collection('cases').doc(caseId).update({
        'attachments': FieldValue.arrayUnion([newAttachment.toMap()]),
      });
    } catch (e) {
      throw Exception('Failed to update attachment title: $e');
    }
  }

  Stream<List<CaseModel>> getCasesForClient(String clientId) {
    return _firestore
        .collection('cases')
        .where('clientId', isEqualTo: clientId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CaseModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Stream<List<CaseModel>> getOpenCases() {
    return _firestore
        .collection('cases')
        .where('status', isEqualTo: 'open')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CaseModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}
