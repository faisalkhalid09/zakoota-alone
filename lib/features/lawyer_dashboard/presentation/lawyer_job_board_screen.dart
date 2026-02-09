import 'package:flutter/material.dart';
import '../../jobs/presentation/job_board_screen.dart';

/// Legacy wrapper to keep older imports working.
class LawyerJobBoardScreen extends StatelessWidget {
  const LawyerJobBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const JobBoardScreen();
  }
}
