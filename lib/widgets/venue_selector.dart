import 'package:flutter/material.dart';

import '../data/venue_presets.dart';
import '../models/venue_preset.dart';

class VenueSelector extends StatelessWidget {
  final VenuePreset? selected;
  final ValueChanged<VenuePreset?> onChanged;

  const VenueSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selected?.slug,
          isExpanded: true,
          icon: Icon(Icons.expand_more, size: 20, color: Colors.grey[600]),
          style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(
                '전체 공연장',
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
            ),
            ...venuePresets.where((p) => p.enabled).map(
              (preset) => DropdownMenuItem<String?>(
                value: preset.slug,
                child: Text(
                  preset.name,
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
              ),
            ),
          ],
          onChanged: (slug) {
            if (slug == null) {
              onChanged(null);
            } else {
              onChanged(findPresetBySlug(slug));
            }
          },
        ),
      ),
    );
  }
}
