import 'package:flutter/material.dart';
import 'package:nexust/core/extensions/theme_extensions.dart';
import 'package:nexust/core/font_awesome_flutter/lib/font_awesome_flutter.dart';
import 'package:nexust/data/enums/method.dart';
import 'package:nexust/data/models/request_history_item.dart';

class RequestHistory extends StatelessWidget {
  final List<RequestHistoryItem> historyItems;
  final Function(RequestHistoryItem) onItemSelected;

  const RequestHistory({
    super.key,
    required this.historyItems,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (historyItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.lightClockRotateLeft,
              size: context.scaleIcon(48),
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              "No hay historial de peticiones",
              style: TextStyle(
                fontSize: context.scaleText(16),
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Las peticiones que realices aparecerán aquí",
              style: TextStyle(
                fontSize: context.scaleText(14),
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: historyItems.length,
      separatorBuilder:
          (context, index) => Divider(
            height: 24,
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
      itemBuilder: (context, index) {
        final item = historyItems[index];

        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              width: 1,
            ),
          ),
          tileColor: isDark ? Colors.black12 : Colors.grey.shade50,
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.method.color.withAlpha(isDark ? 40 : 25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.method.stringName,
              style: TextStyle(
                color: item.method.color,
                fontWeight: FontWeight.bold,
                fontSize: context.scaleText(14),
              ),
            ),
          ),
          title: Text(
            item.url,
            style: TextStyle(
              fontSize: context.scaleText(14),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            children: [
              Text(
                _formatTimestamp(item.timestamp),
                style: TextStyle(
                  fontSize: context.scaleText(12),
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(item.statusCode),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.statusCode.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.scaleText(10),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          trailing: Icon(
            FontAwesomeIcons.lightArrowRight,
            size: context.scaleIcon(16),
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
          onTap: () => onItemSelected(item),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m atrás';
    } else {
      return 'Ahora';
    }
  }

  Color _getStatusColor(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return Colors.green.shade700;
    } else if (statusCode >= 300 && statusCode < 400) {
      return Colors.blue.shade700;
    } else if (statusCode >= 400 && statusCode < 500) {
      return Colors.amber.shade700;
    } else {
      return Colors.red.shade700;
    }
  }
}
