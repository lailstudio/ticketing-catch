import 'package:flutter/material.dart';

import '../data/venue_presets.dart';
import '../models/venue_preset.dart';
import 'venue_image.dart';

class VenueLinksSection extends StatelessWidget {
  final String? currentSlug;

  const VenueLinksSection({super.key, this.currentSlug});

  @override
  Widget build(BuildContext context) {
    final venues = venuePresets
        .where((p) => p.enabled && p.slug != currentSlug)
        .toList();
    if (venues.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '다른 공연장 연습',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 600;
            final crossAxisCount = isCompact ? 2 : 4;
            final ratio = isCompact ? 2.8 : 3.8;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: ratio,
              ),
              itemCount: venues.length,
              itemBuilder: (context, index) {
                return _MiniVenueCard(
                  venue: venues[index],
                  isCompact: isCompact,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _MiniVenueCard extends StatelessWidget {
  final VenuePreset venue;
  final bool isCompact;

  const _MiniVenueCard({required this.venue, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFEEEEEE)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/venue/${venue.slug}');
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageWidth =
                constraints.maxWidth * (isCompact ? 0.28 : 0.32);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: imageWidth,
                  child: VenueImage(
                    venueId: venue.id,
                    imageAsset: venue.imageAsset,
                    semanticLabel: venue.altText,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        venue.shortName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '연습하기',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 28,
                  child: Center(
                    child: Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
