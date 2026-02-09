/// Mock data for lawyer profiles
class LawyerMockData {
  static final List<LawyerProfile> lawyers = [
    LawyerProfile(
      id: 'L001',
      name: 'Adv. Sarah Ahmed',
      title: 'Senior Advocate',
      location: 'Lahore High Court',
      photoUrl: 'https://i.pravatar.cc/150?img=5',
      specializations: ['Criminal Law', 'Constitutional Law', 'Human Rights'],
      experience: 12,
      casesWon: 145,
      rating: 4.9,
      reviewCount: 120,
      pricePerConsultation: 3000,
      isVerified: true,
      education: ['LLB, Punjab University', 'LLM, Oxford University'],
      barCouncil: 'Lahore High Court Bar Association',
      aboutMe:
          'With over 12 years of experience in criminal and constitutional law, I specialize in high-stakes litigation and have successfully represented clients in landmark cases before the Supreme Court and High Courts of Pakistan.',
      reviews: [
        LawyerReview(
          clientName: 'Ahmed Khan',
          rating: 5.0,
          comment:
              'Excellent legal representation. Very professional and dedicated.',
          date: '2 weeks ago',
        ),
        LawyerReview(
          clientName: 'Fatima Ali',
          rating: 4.8,
          comment:
              'Highly knowledgeable and responsive. Helped me win my case.',
          date: '1 month ago',
        ),
      ],
    ),
    LawyerProfile(
      id: 'L002',
      name: 'Adv. Hassan Ali',
      title: 'Advocate High Court',
      location: 'Islamabad',
      photoUrl: 'https://i.pravatar.cc/150?img=12',
      specializations: ['Property Law', 'Corporate Law', 'Contract Disputes'],
      experience: 8,
      casesWon: 98,
      rating: 4.7,
      reviewCount: 85,
      pricePerConsultation: 2500,
      isVerified: true,
      education: ['LLB, Quaid-e-Azam University', 'Corporate Law Diploma'],
      barCouncil: 'Islamabad Bar Association',
      aboutMe:
          'Specialist in property disputes and corporate litigation with 8 years of experience. I provide comprehensive legal solutions for businesses and individuals in property matters.',
      reviews: [
        LawyerReview(
          clientName: 'Bilal Sheikh',
          rating: 4.7,
          comment: 'Great expertise in property law. Resolved my case quickly.',
          date: '3 weeks ago',
        ),
        LawyerReview(
          clientName: 'Ayesha Khan',
          rating: 4.6,
          comment: 'Professional and courteous. Would recommend.',
          date: '2 months ago',
        ),
      ],
    ),
    LawyerProfile(
      id: 'L003',
      name: 'Adv. Fatima Khan',
      title: 'Senior Advocate',
      location: 'Karachi High Court',
      photoUrl: 'https://i.pravatar.cc/150?img=9',
      specializations: ['Family Law', 'Divorce & Custody', 'Women Rights'],
      experience: 10,
      casesWon: 112,
      rating: 4.8,
      reviewCount: 95,
      pricePerConsultation: 2800,
      isVerified: true,
      education: ['LLB, Karachi University', 'Family Law Certification'],
      barCouncil: 'Karachi Bar Association',
      aboutMe:
          'Dedicated to family law and women\'s rights with 10 years of experience. I handle sensitive cases with empathy and provide strong legal representation in custody and divorce matters.',
      reviews: [
        LawyerReview(
          clientName: 'Sana Ahmed',
          rating: 5.0,
          comment:
              'Extremely supportive and understanding. Won my custody case.',
          date: '1 week ago',
        ),
        LawyerReview(
          clientName: 'Maria Saleem',
          rating: 4.6,
          comment: 'Excellent family lawyer. Very professional.',
          date: '3 weeks ago',
        ),
      ],
    ),
    LawyerProfile(
      id: 'L004',
      name: 'Adv. Usman Malik',
      title: 'Corporate Lawyer',
      location: 'Lahore',
      photoUrl: 'https://i.pravatar.cc/150?img=15',
      specializations: ['Startup Law', 'Business Formation', 'IP Rights'],
      experience: 6,
      casesWon: 67,
      rating: 4.6,
      reviewCount: 52,
      pricePerConsultation: 3500,
      isVerified: true,
      education: ['LLB, LUMS', 'Business Law Certificate, Harvard'],
      barCouncil: 'Punjab Bar Council',
      aboutMe:
          'Specializing in startup ecosystem and intellectual property with focus on helping entrepreneurs navigate legal challenges. Experience with tech startups and venture capital deals.',
      reviews: [
        LawyerReview(
          clientName: 'Hamza Tech',
          rating: 4.7,
          comment: 'Perfect for startups. Helped us with incorporation.',
          date: '2 weeks ago',
        ),
        LawyerReview(
          clientName: 'Ali Ventures',
          rating: 4.5,
          comment: 'Knowledgeable in business law. Recommended.',
          date: '1 month ago',
        ),
      ],
    ),
    LawyerProfile(
      id: 'L005',
      name: 'Adv. Zainab Siddiqui',
      title: 'Civil Rights Advocate',
      location: 'Supreme Court',
      photoUrl: 'https://i.pravatar.cc/150?img=20',
      specializations: ['Civil Law', 'Public Interest', 'Constitutional Law'],
      experience: 15,
      casesWon: 178,
      rating: 4.9,
      reviewCount: 142,
      pricePerConsultation: 4000,
      isVerified: true,
      education: ['LLB, Lahore University', 'LLM, Cambridge', 'PhD Law'],
      barCouncil: 'Supreme Court Bar Association',
      aboutMe:
          'Renowned civil rights lawyer with 15 years of experience in constitutional matters. Regular contributor to legal reforms and active in public interest litigation.',
      reviews: [
        LawyerReview(
          clientName: 'Citizens Forum',
          rating: 5.0,
          comment: 'Champion of justice. Exceptional legal mind.',
          date: '1 week ago',
        ),
        LawyerReview(
          clientName: 'NGO Legal Aid',
          rating: 4.8,
          comment: 'Outstanding work in civil rights cases.',
          date: '2 weeks ago',
        ),
      ],
    ),
    LawyerProfile(
      id: 'L006',
      name: 'Adv. Imran Haider',
      title: 'Tax & Finance Lawyer',
      location: 'Islamabad',
      photoUrl: 'https://i.pravatar.cc/150?img=33',
      specializations: ['Tax Law', 'Banking Law', 'Financial Disputes'],
      experience: 9,
      casesWon: 89,
      rating: 4.5,
      reviewCount: 68,
      pricePerConsultation: 3200,
      isVerified: false,
      education: ['LLB, IIU', 'Tax Law Specialization'],
      barCouncil: 'Islamabad Bar Association',
      aboutMe:
          'Expert in taxation and banking law with extensive experience in financial disputes and regulatory compliance. Assist businesses with tax planning and litigation.',
      reviews: [
        LawyerReview(
          clientName: 'Corporate Finance',
          rating: 4.6,
          comment: 'Great help with tax disputes. Very knowledgeable.',
          date: '3 weeks ago',
        ),
        LawyerReview(
          clientName: 'SME Solutions',
          rating: 4.4,
          comment: 'Good experience in banking law.',
          date: '1 month ago',
        ),
      ],
    ),
  ];

  static LawyerProfile? getLawyerById(String id) {
    try {
      return lawyers.firstWhere((lawyer) => lawyer.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<LawyerProfile> searchLawyers({
    String? category,
    String? query,
    bool? verifiedOnly,
    double? minRating,
  }) {
    var results = lawyers;

    if (category != null && category.isNotEmpty) {
      results = results
          .where((lawyer) => lawyer.specializations.any(
              (spec) => spec.toLowerCase().contains(category.toLowerCase())))
          .toList();
    }

    if (query != null && query.isNotEmpty) {
      results = results
          .where((lawyer) =>
              lawyer.name.toLowerCase().contains(query.toLowerCase()) ||
              lawyer.specializations.any(
                  (spec) => spec.toLowerCase().contains(query.toLowerCase())))
          .toList();
    }

    if (verifiedOnly == true) {
      results = results.where((lawyer) => lawyer.isVerified).toList();
    }

    if (minRating != null) {
      results = results.where((lawyer) => lawyer.rating >= minRating).toList();
    }

    return results;
  }
}

class LawyerProfile {
  final String id;
  final String name;
  final String title;
  final String location;
  final String photoUrl;
  final List<String> specializations;
  final int experience;
  final int casesWon;
  final double rating;
  final int reviewCount;
  final int pricePerConsultation;
  final bool isVerified;
  final List<String> education;
  final String barCouncil;
  final String aboutMe;
  final List<LawyerReview> reviews;

  LawyerProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.location,
    required this.photoUrl,
    required this.specializations,
    required this.experience,
    required this.casesWon,
    required this.rating,
    required this.reviewCount,
    required this.pricePerConsultation,
    required this.isVerified,
    required this.education,
    required this.barCouncil,
    required this.aboutMe,
    required this.reviews,
  });
}

class LawyerReview {
  final String clientName;
  final double rating;
  final String comment;
  final String date;

  LawyerReview({
    required this.clientName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
