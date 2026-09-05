import '../../models/venue_map_config.dart';
import 'gocheok_config.dart';
import 'inspire_config.dart';
import 'jamsil_config.dart';
import 'kspo_config.dart';
import 'olympic_config.dart';

final _configs = <String, VenueMapConfig>{
  'jamsil': jamsilConfig,
  'olympic': olympicConfig,
  'kspo': kspoConfig,
  'inspire': inspireConfig,
  'gocheok': gocheokConfig,
};

VenueMapConfig? venueMapConfigFor(String venueId) => _configs[venueId];
