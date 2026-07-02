import 'package:collection/collection.dart';

import '../../../ais_decoder.dart';
import '../../utils/binary_conversion.dart';
import '../../utils/bit_array_utils.dart';
import '../../utils/coordinate_utils.dart';

class BaseStationReport extends AISMessage {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int second;
  final int accuracy;
  final double? longitude;
  final double? latitude;
  final String epfdFixType;
  final int spare;
  final int raim;
  final int sotdmaState;

  BaseStationReport({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
    required this.accuracy,
    required this.longitude,
    required this.latitude,
    required this.epfdFixType,
    required this.spare,
    required this.raim,
    required this.sotdmaState,
  });

  @override
  String toString() =>
      'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, Year: $year, Month: $month, Day: $day, Hour: $hour, Minute: $minute, Second: $second, Accuracy: $accuracy, Lat: $latitude, Lon: $longitude, EPFD: $epfdFixType, RAIM: $raim, SOTDMA: $sotdmaState)';

  factory BaseStationReport.fromBinary(String binary) {
    // common
    int messageType = int.parse(binary.substring(0, 6), radix: 2);
    int repeatIndicator = int.parse(binary.substring(6, 8), radix: 2);
    int mmsi = int.parse(binary.substring(8, 38), radix: 2);

    // binary ranges specific to type 4
    String yearBin = binary.substring(38, 52);
    String monthBin = binary.substring(52, 56);
    String dayBin = binary.substring(56, 61);
    String hourBin = binary.substring(61, 66);
    String minuteBin = binary.substring(66, 72);
    String secondBin = binary.substring(72, 78);
    String accuracyBin = binary.substring(78, 79);
    String longitudeBin = binary.substring(79, 107); // Type 4 position
    String latitudeBin = binary.substring(107, 134); // Type 4 position
    String epfdBin = binary.substring(134, 138);
    String spareBin = binary.substring(138, 148);
    String raimBin = binary.substring(148, 149);
    String radioBin = binary.substring(149, 168);

    // conversion to actually readable data
    int year = int.parse(yearBin, radix: 2);
    int month = int.parse(monthBin, radix: 2);
    int day = int.parse(dayBin, radix: 2);
    int hour = int.parse(hourBin, radix: 2);
    int minute = int.parse(minuteBin, radix: 2);
    int second = int.parse(secondBin, radix: 2);
    int accuracy = int.parse(accuracyBin, radix: 2); // as bool
    double? longitude = CoordinateUtils().calculateLongitude(longitudeBin);
    double? latitude = CoordinateUtils().calculateLatitude(latitudeBin);
    String positionFixType = BinaryConverter().getEPFDFixType(epfdBin);
    int spare = int.parse(spareBin, radix: 2);
    int raimFlag = int.parse(raimBin, radix: 2);
    int sotdmaState = int.parse(radioBin, radix: 2);

    return BaseStationReport(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      accuracy: accuracy,
      longitude: longitude,
      latitude: latitude,
      epfdFixType: positionFixType,
      spare: spare,
      raim: raimFlag,
      sotdmaState: sotdmaState,
    );
  }

  factory BaseStationReport.fromBitArray(BoolList bitArray) {
    // common
    int messageType = asInt(bitArray, 0, 6);
    int repeatIndicator = asInt(bitArray, 6, 8);
    int mmsi = asInt(bitArray, 8, 38);

    // binary ranges specific to type 4
    int year = asInt(bitArray, 38, 52);
    int month = asInt(bitArray, 52, 56);
    int day = asInt(bitArray, 56, 61);
    int hour = asInt(bitArray, 61, 66);
    int minute = asInt(bitArray, 66, 72);
    int second = asInt(bitArray, 72, 78);
    int accuracy = asInt(bitArray, 78, 79); // as bool
    int rawLongitude = asSignedInt(bitArray, 79, 107); // Type 4 position
    int rawLatitude = asSignedInt(bitArray, 107, 134); // Type 4 position
    int epfd = asInt(bitArray, 134, 138);
    int spare = asInt(bitArray, 138, 148);
    int raimFlag = asInt(bitArray, 148, 149);
    int sotdmaState = asInt(bitArray, 149, 168);

    // conversion to actually readable data
    const int nrLongitudeBits = 107 - 79;
    double? longitude = CoordinateUtils.calculateLongitudeFromRaw(
        rawLongitude, nrLongitudeBits);
    const int nrLatitudeBits = 134 - 107;
    double? latitude =
        CoordinateUtils.calculateLatitudeFromRaw(rawLatitude, nrLatitudeBits);
    String positionFixType = BinaryConverter.getEPFDFixTypeString(epfd);

    return BaseStationReport(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      accuracy: accuracy,
      longitude: longitude,
      latitude: latitude,
      epfdFixType: positionFixType,
      spare: spare,
      raim: raimFlag,
      sotdmaState: sotdmaState,
    );
  }
}
