import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/proposal.dart';

class ProposalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Submit a Proposal
  Future<void> submitProposal({
    required String caseId,
    required String lawyerId,
    required String lawyerName,
    required String lawyerImage,
    required double rating,
    required String location,
    required String coverLetter,
    required double bidAmount,
    required String duration,
  }) async {
    final proposalRef = _firestore
        .collection('cases')
        .doc(caseId)
        .collection('proposals')
        .doc(lawyerId); // Use lawyerId as doc ID to enforce uniqueness

    final docSnapshot = await proposalRef.get();
    if (docSnapshot.exists) {
      throw Exception('You have already submitted a proposal for this job.');
    }

    final proposalData = Proposal(
      id: proposalRef.id,
      lawyerId: lawyerId,
      lawyerName: lawyerName,
      lawyerImage: lawyerImage,
      rating: rating,
      location: location,
      coverLetter: coverLetter,
      bidAmount: bidAmount,
      duration: duration,
      createdAt: DateTime.now(),
    ).toMap();

    // Use a batch or transaction if you want to update proposal count atomically
    // For simplicity and scalability, incrementing count via FieldValue.increment is robust
    final batch = _firestore.batch();

    // 1. Add Proposal to Subcollection
    batch.set(proposalRef, proposalData);

    // 2. Increment Proposal Count on Case Document
    final caseRef = _firestore.collection('cases').doc(caseId);
    batch.update(caseRef, {
      'proposalCount': FieldValue.increment(1),
      // Extendable: Add 'lastActivity' timestamp to case for sorting recently active jobs
      'lastActivity': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  // Delete a Proposal
  Future<void> deleteProposal(String caseId, String proposalId) async {
    final batch = _firestore.batch();

    // 1. Delete Proposal
    final proposalRef = _firestore
        .collection('cases')
        .doc(caseId)
        .collection('proposals')
        .doc(proposalId);
    batch.delete(proposalRef);

    // 2. Decrement Proposal Count
    final caseRef = _firestore.collection('cases').doc(caseId);
    batch.update(caseRef, {
      'proposalCount': FieldValue.increment(-1),
    });

    await batch.commit();
  }

  // Update a Proposal
  Future<void> updateProposal({
    required String caseId,
    required String proposalId,
    required String coverLetter,
    required double bidAmount,
    required String duration,
  }) async {
    await _firestore
        .collection('cases')
        .doc(caseId)
        .collection('proposals')
        .doc(proposalId)
        .update({
      'coverLetter': coverLetter,
      'bidAmount': bidAmount,
      'duration': duration,
      // strictly speaking, we might not want to update createdAt
    });
  }

  // Get Proposals for a Case (Stream)
  Stream<List<Proposal>> getProposalsForCase(String caseId) {
    return _firestore
        .collection('cases')
        .doc(caseId)
        .collection('proposals')
        .orderBy('createdAt', descending: true) // Newest first
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Proposal.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}
