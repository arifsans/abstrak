import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/helper/date_formatter.dart';

class ArtwerkDetailDialog extends StatelessWidget {
  final Result artwerk;

  const ArtwerkDetailDialog({
    super.key,
    required this.artwerk,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1a1a1a),
      insetPadding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
          ? const EdgeInsets.all(16)
          : EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * .15,
              vertical: 40,
            ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 700, maxWidth: 800),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a1a),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dialog Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF2a2a2a),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Artwerk Details',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white70),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            // Dialog Content
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Artwerk Image
                      if (artwerk.image != null && artwerk.image!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            artwerk.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[800],
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                        size: 48,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Image not available',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[800],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Basic Information Section
                      _buildSectionTitle('Art Information'),
                      const SizedBox(height: 12),
                      _buildInfoRow('Title', artwerk.name ?? 'N/A'),
                      _buildInfoRow(
                        'Description',
                        artwerk.description ?? 'N/A',
                      ),
                      _buildInfoRow(
                        'Created Date',
                        DateFormatterHelper.formatDateWithTime(artwerk.createdAt!),
                      ),

                      const SizedBox(height: 24),

                      // Artist Information Section
                      _buildSectionTitle('Artist Information'),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Name',
                        artwerk.creatorName ?? 'N/A',
                      ),
                      _buildInfoRow(
                        'Email',
                        artwerk.creatorEmail ?? 'N/A',
                      ),
                      if (artwerk.creatorPhone != null && artwerk.creatorPhone!.isNotEmpty)
                        _buildInfoRow('Phone', artwerk.creatorPhone!),
                    ],
                  ),
                ),
              ),
            ),

            // Dialog Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF2a2a2a),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                    ),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
