import 'package:flutter/material.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Skills',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSkillCard('Flutter Development', '2 years'),
          _buildSkillCard('UI/UX Design', '3 years'),
          _buildSkillCard('Project Management', '1 year'),
        ],
      ),
    );
  }

  Widget _buildSkillCard(String skill, String experience) {
    final Map<String, String> skillDescriptions = {
      'Flutter Development':
          'Experienced in building cross-platform mobile applications using Flutter framework. Proficient in state management solutions like Provider and Bloc. Skilled in creating responsive UIs and integrating with REST APIs.',
      'UI/UX Design':
          'Strong understanding of Material Design guidelines and human interface principles. Experienced in creating user-centered designs, wireframing, and prototyping. Familiar with design tools like Figma and Adobe XD.',
      'Project Management':
          'Proven ability to lead development teams using Agile/Scrum methodologies. Experienced in project planning, task prioritization, and delivering projects on schedule. Strong communication and team collaboration skills.',
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: ThemeData.light().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            skill,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            experience,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          trailing: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                skillDescriptions[skill] ?? 'No description available',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
