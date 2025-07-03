// import 'package:flutter/material.dart';
// import 'package:jop_app/models/review_model.dart'; // You'll need to create this model

// class ReviewScreen extends StatelessWidget {
//   final List<ReviewModel> reviews; // Replace with your review model
//   final double averageRating;

//   const ReviewScreen({
//     super.key,
//     required this.reviews,
//     required this.averageRating,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Reviews'),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//       ),
//       body: Column(
//         children: [
//           // Average Rating Card
//           Card(
//             margin: const EdgeInsets.all(16),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   Text(
//                     averageRating.toStringAsFixed(1),
//                     style: const TextStyle(
//                       fontSize: 36,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(
//                       5,
//                       (index) => Icon(
//                         Icons.star,
//                         color:
//                             index < averageRating.floor()
//                                 ? Colors.amber
//                                 : Colors.grey[300],
//                         size: 28,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '${reviews.length} Reviews',
//                     style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Reviews List
//           Expanded(
//             child:
//                 reviews.isEmpty
//                     ? const Center(
//                       child: Text(
//                         'No reviews yet',
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     )
//                     : ListView.builder(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: reviews.length,
//                       itemBuilder: (context, index) {
//                         final review = reviews[index];
//                         return Card(
//                           margin: const EdgeInsets.only(bottom: 12),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     CircleAvatar(
//                                       backgroundImage: NetworkImage(
//                                         review.reviewerImage,
//                                       ),
//                                       radius: 20,
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           review.reviewerName,
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Row(
//                                           children: List.generate(
//                                             5,
//                                             (i) => Icon(
//                                               Icons.star,
//                                               color:
//                                                   i < review.rating
//                                                       ? Colors.amber
//                                                       : Colors.grey[300],
//                                               size: 16,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const Spacer(),
//                                     Text(
//                                       review.date,
//                                       style: TextStyle(
//                                         color: Colors.grey[600],
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 12),
//                                 Text(
//                                   review.comment,
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  // Demo review data
  final List<Map<String, dynamic>> reviews = [
    {
      'id': '1',
      'reviewerName': 'Sarah Johnson',
      'reviewerImage': 'https://randomuser.me/api/portraits/women/44.jpg',
      'rating': 5,
      'comment':
          'Excellent work! Very professional and delivered on time. Would definitely hire again.',
      'date': '2 weeks ago',
    },
    {
      'id': '2',
      'reviewerName': 'Michael Chen',
      'reviewerImage': 'https://randomuser.me/api/portraits/men/32.jpg',
      'rating': 4,
      'comment':
          'Good communication and quality work. Would recommend for any project.',
      'date': '1 month ago',
    },
    {
      'id': '3',
      'reviewerName': 'Emma Wilson',
      'reviewerImage': 'https://randomuser.me/api/portraits/women/68.jpg',
      'rating': 5,
      'comment': 'Outstanding service! Went above and beyond my expectations.',
      'date': '2 months ago',
    },
  ];

  // Calculate average rating
  double get averageRating {
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r['rating'] as int).reduce((a, b) => a + b) /
        reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reviews'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Average Rating Card
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    averageRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color:
                            index < averageRating.floor()
                                ? Colors.amber
                                : Colors.grey[300],
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${reviews.length} ${reviews.length == 1 ? 'Review' : 'Reviews'}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Reviews List
          Expanded(
            child:
                reviews.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.reviews_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No reviews yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your reviews will appear here',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        review['reviewerImage'],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            review['reviewerName'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: List.generate(
                                              5,
                                              (i) => Icon(
                                                Icons.star,
                                                color:
                                                    i < review['rating']
                                                        ? Colors.amber
                                                        : Colors.grey[300],
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      review['date'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  review['comment'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
