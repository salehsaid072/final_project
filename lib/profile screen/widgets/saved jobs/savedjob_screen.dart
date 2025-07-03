// import 'package:flutter/material.dart';
// import 'package:jop_app/models/saved_job_model.dart';

// class SavedJobScreen extends StatelessWidget {
//   final List<SavedJobModel> savedJobs; // Replace with your job model

//   const SavedJobScreen({super.key, required this.savedJobs});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Saved Jobs'),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//       ),
//       body:
//           savedJobs.isEmpty
//               ? const Center(
//                 child: Text(
//                   'No saved jobs yet',
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//               )
//               : ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: savedJobs.length,
//                 itemBuilder: (context, index) {
//                   final job = savedJobs[index];
//                   return Card(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.all(16),
//                       title: Text(
//                         job.title,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(job.company),
//                           const SizedBox(height: 4),
//                           Text(
//                             '${job.location} • ${job.type}',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.bookmark, color: Colors.blue),
//                         onPressed: () {
//                           // TODO: Handle unsave job
//                         },
//                       ),
//                       onTap: () {
//                         // TODO: Navigate to job details
//                       },
//                     ),
//                   );
//                 },
//               ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class SavedJobScreen extends StatefulWidget {
  const SavedJobScreen({super.key});

  @override
  State<SavedJobScreen> createState() => _SavedJobScreenState();
}

class _SavedJobScreenState extends State<SavedJobScreen> {
  // Demo job data
  final List<Map<String, dynamic>> savedJobs = [
    {
      'id': '1',
      'title': 'Senior Flutter Developer',
      'company': 'TechCorp',
      'location': 'New York, NY',
      'type': 'Full-time',
      'salary': '\$120,000 - \$150,000',
      'logo': 'https://via.placeholder.com/50',
      'isSaved': true,
    },
    {
      'id': '2',
      'title': 'UI/UX Designer',
      'company': 'DesignHub',
      'location': 'Remote',
      'type': 'Contract',
      'salary': '\$80 - \$100/hr',
      'logo': 'https://via.placeholder.com/50/cccccc/808080',
      'isSaved': true,
    },
    {
      'id': '3',
      'title': 'Product Manager',
      'company': 'StartUp Inc',
      'location': 'San Francisco, CA',
      'type': 'Full-time',
      'salary': '\$130,000 - \$160,000',
      'logo': 'https://via.placeholder.com/50/ff9900/ffffff',
      'isSaved': true,
    },
  ];

  void _toggleSave(int index) {
    setState(() {
      savedJobs[index]['isSaved'] = !savedJobs[index]['isSaved'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Jobs'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body:
          savedJobs.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No saved jobs yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save jobs to view them here',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: savedJobs.length,
                itemBuilder: (context, index) {
                  final job = savedJobs[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // TODO: Navigate to job details
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: NetworkImage(job['logo']),
                                  radius: 24,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        job['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        job['company'],
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    job['isSaved']
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color:
                                        job['isSaved']
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey,
                                  ),
                                  onPressed: () => _toggleSave(index),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  job['location'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  job['type'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              job['salary'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
