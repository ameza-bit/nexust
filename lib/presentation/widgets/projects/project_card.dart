import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/data/models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final bool isCurrentProject;
  final VoidCallback onTap;
  final VoidCallback onSwitchProject;

  const ProjectCard({
    super.key,
    required this.project,
    required this.isCurrentProject,
    required this.onTap,
    required this.onSwitchProject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side:
            isCurrentProject
                ? BorderSide(color: theme.primaryColor, width: 2)
                : BorderSide.none,
      ),
      color:
          isCurrentProject
              ? theme.primaryColor.withAlpha(isDark ? 40 : 20)
              : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    project.isPersonal
                        ? FontAwesomeIcons.lightUserGear
                        : FontAwesomeIcons.lightFolderOpen,
                    color: theme.primaryColor,
                    size: context.scaleIcon(24),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: TextStyle(
                            fontSize: context.scaleText(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (project.description.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              project.description,
                              style: TextStyle(
                                fontSize: context.scaleText(14),
                                color:
                                    isDark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (project.isPersonal)
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Chip(
                        label: Text(
                          context.tr('projects.personal_project'),
                          style: TextStyle(
                            fontSize: context.scaleText(12),
                            color: theme.primaryColor,
                          ),
                        ),
                        backgroundColor: theme.primaryColor.withAlpha(
                          isDark ? 40 : 30,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.lightCalendarDays,
                        size: context.scaleIcon(14),
                        color:
                            isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                      ),
                      SizedBox(width: 4),
                      Text(
                        DateFormat.yMMMd().format(project.createdAt),
                        style: TextStyle(
                          fontSize: context.scaleText(12),
                          color:
                              isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  if (!isCurrentProject)
                    TextButton.icon(
                      onPressed: onSwitchProject,
                      icon: Icon(
                        FontAwesomeIcons.lightRightToBracket,
                        size: context.scaleIcon(14),
                      ),
                      label: Text(context.tr('projects.switch_to')),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  if (isCurrentProject)
                    Chip(
                      label: Text(
                        context.tr(
                          'projects.current_project',
                          namedArgs: {'name': ''},
                        ),
                        style: TextStyle(
                          fontSize: context.scaleText(12),
                          color: theme.primaryColor,
                        ),
                      ),
                      backgroundColor: theme.primaryColor.withAlpha(
                        isDark ? 40 : 30,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
