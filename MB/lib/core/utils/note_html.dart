import 'package:intl/intl.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/utils/format_vnd.dart';

String generateTournamentPolicy({
  required String name,
  required String location,
  required DateTime startDate,
  required DateTime endDate,
  required bool isFree,
  required String? entryFee,
  required String type,
  required int maxPlayer,
  required double totalPrize,
  required String? isMinRanking,
  required String? isMaxRanking,
  required String? social,
  required String contactEmail,
  required String contactPhone,
}) {
  final DateFormat dateFormat = DateFormat('yyyy-dd-MM HH:mm');
  final String formattedStartDate = dateFormat.format(startDate);
  final String formattedEndDate = dateFormat.format(endDate);

  return '''
  <p><strong>$name Tournament Policy</strong></p>
  <p><br></p>
  <p><strong>1. Introduction</strong></p>
  <p>Welcome to the $name tournament! This is a $type event with a total prize pool of ${formatVND(totalPrize)}.</p>

  <p><strong>2. Event Details</strong></p>
  <ul>
    <li><strong>Location:</strong> $location</li>
    <li><strong>Time:</strong> $formattedStartDate - $formattedEndDate</li>
  </ul>

  <p><strong>3. Registration</strong></p>
  <ul>
    <li><strong>Maximum Players:</strong> $maxPlayer</li>
    <li><strong>Entry Fee:</strong> ${isFree ? "Free" : "${formatVND(double.parse(entryFee!))} per person"}</li>
    ${isMinRanking != null || isMaxRanking != null ? "<li><strong>Ranking Requirement:</strong> ${RankLevel.fromValue(int.parse(isMinRanking!))!.label ?? "No limit"} - ${RankLevel.fromValue(int.parse(isMaxRanking!))!.label ?? "No limit"}</li>" : ""}
  </ul>

  <p><strong>4. Social & Media</strong></p>
  <ul>
    ${social != null ? "<li><strong>Social Media:</strong> <a href=\"$social\">$social</a></li>" : ""}
  </ul>

  <p><strong>5. Contact</strong></p>
  <ul>
    <li><strong>Email:</strong> $contactEmail</li>
    <li><strong>Phone:</strong> $contactPhone</li>
  </ul>
  ''';
}
