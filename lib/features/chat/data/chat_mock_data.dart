/// Mock data for Chat conversations and messages
class ChatMockData {
  static final List<Conversation> conversations = [
    Conversation(
      id: 'conv_001',
      lawyerId: 'L001',
      lawyerName: 'Adv. Sarah Ahmed',
      lawyerAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarah',
      isOnline: true,
      lastMessage: 'Please send the affidavit by tomorrow.',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
    ),
    Conversation(
      id: 'conv_002',
      lawyerId: 'L003',
      lawyerName: 'Adv. Hassan Ali',
      lawyerAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Hassan',
      isOnline: false,
      lastMessage: 'I will review the contract and get back to you.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
    ),
    Conversation(
      id: 'conv_003',
      lawyerId: 'L002',
      lawyerName: 'Adv. Fatima Khan',
      lawyerAvatar: 'https://api.dicebear.com/7.x/avataaars/png?seed=Fatima',
      isOnline: true,
      lastMessage: 'Thank you for choosing my services.',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
    ),
  ];

  static List<Message> getMessagesForConversation(String conversationId) {
    // Mock messages for demonstration
    if (conversationId == 'conv_001') {
      return [
        Message(
          id: 'msg_001',
          conversationId: conversationId,
          senderId: 'client',
          text: 'Hello, I need help with my property case.',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          isSentByMe: true,
        ),
        Message(
          id: 'msg_002',
          conversationId: conversationId,
          senderId: 'L001',
          text: 'Hello! I\'d be happy to help. Can you provide more details?',
          timestamp:
              DateTime.now().subtract(const Duration(hours: 2, minutes: 55)),
          isSentByMe: false,
        ),
        Message(
          id: 'msg_003',
          conversationId: conversationId,
          senderId: 'client',
          text:
              'Yes, it\'s regarding an inheritance property dispute in Lahore.',
          timestamp:
              DateTime.now().subtract(const Duration(hours: 2, minutes: 50)),
          isSentByMe: true,
        ),
        Message(
          id: 'msg_004',
          conversationId: conversationId,
          senderId: 'L001',
          text: 'I understand. Do you have all the relevant documents?',
          timestamp:
              DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
          isSentByMe: false,
        ),
        Message(
          id: 'msg_005',
          conversationId: conversationId,
          senderId: 'client',
          text: 'Yes, I have the property deed and will documents.',
          timestamp:
              DateTime.now().subtract(const Duration(hours: 2, minutes: 40)),
          isSentByMe: true,
        ),
        Message(
          id: 'msg_006',
          conversationId: conversationId,
          senderId: 'L001',
          text: 'Perfect. Please send the affidavit by tomorrow.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isSentByMe: false,
        ),
      ];
    } else if (conversationId == 'conv_002') {
      return [
        Message(
          id: 'msg_007',
          conversationId: conversationId,
          senderId: 'client',
          text: 'Can you review this business contract for me?',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          isSentByMe: true,
        ),
        Message(
          id: 'msg_008',
          conversationId: conversationId,
          senderId: 'L003',
          text: 'I will review the contract and get back to you.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isSentByMe: false,
        ),
      ];
    } else {
      // New conversation - empty messages
      return [];
    }
  }
}

/// Conversation Model
class Conversation {
  final String id;
  final String lawyerId;
  final String lawyerName;
  final String lawyerAvatar;
  final bool isOnline;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  Conversation({
    required this.id,
    required this.lawyerId,
    required this.lawyerName,
    required this.lawyerAvatar,
    required this.isOnline,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });
}

/// Message Model
class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isSentByMe;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isSentByMe,
  });
}
