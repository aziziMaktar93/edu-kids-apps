import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum SubjectId { math, science, english, bahasaMelayu, jawi }

class SubjectInfo {
  final SubjectId id;
  final String name;
  final String tagline;
  final Color color;
  final IconData icon;

  const SubjectInfo({
    required this.id,
    required this.name,
    required this.tagline,
    required this.color,
    required this.icon,
  });
}

final Map<SubjectId, SubjectInfo> subjectCatalog = {
  SubjectId.math: const SubjectInfo(
    id: SubjectId.math,
    name: 'Matematik',
    tagline: 'Kira dan selesaikan!',
    color: AppColors.subjectMath,
    icon: Icons.calculate,
  ),
  SubjectId.science: const SubjectInfo(
    id: SubjectId.science,
    name: 'Sains',
    tagline: 'Terokai alam semula jadi!',
    color: AppColors.subjectScience,
    icon: Icons.rocket_launch,
  ),
  SubjectId.english: const SubjectInfo(
    id: SubjectId.english,
    name: 'English',
    tagline: 'Learn new words!',
    color: AppColors.subjectEnglish,
    icon: Icons.sort_by_alpha,
  ),
  SubjectId.bahasaMelayu: const SubjectInfo(
    id: SubjectId.bahasaMelayu,
    name: 'Bahasa Melayu',
    tagline: 'Perkaya kosa kata!',
    color: AppColors.subjectBahasaMelayu,
    icon: Icons.local_offer,
  ),
  SubjectId.jawi: const SubjectInfo(
    id: SubjectId.jawi,
    name: 'Jawi',
    tagline: 'Belajar menulis dan membaca Jawi',
    color: AppColors.subjectJawi,
    icon: Icons.translate,
  ),
};
