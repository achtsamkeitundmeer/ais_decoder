import 'package:collection/collection.dart';

import '../../../ais_decoder.dart';
import '../../utils/binary_conversion.dart';
import '../../utils/bit_array_utils.dart';
import '../../utils/coordinate_utils.dart';

class LongRangeAISBroadcastMessage extends AISMessage {
  final int raimEnabled;
  final String navigationStatus;
  final double? longitude;
  final double? latitude;
  final double speedOverGround;
  final double courseOverGround;
  final int gnssPositionStatus;
  final int spare;

  LongRangeAISBroadcastMessage({
    required super.messageType,
    required super.mmsi,
    required super.repeatIndicator,
    required this.raimEnabled,
    required this.navigationStatus,
    required this.latitude,
    required this.longitude,
    required this.speedOverGround,
    required this.courseOverGround,
    required this.gnssPositionStatus,
    required this.spare,
  });

  @override
  String toString() =>
      'AISMessage(Type: $messageType, MMSI: $mmsi, Repeat: $repeatIndicator, RAIM: $raimEnabled, Status: $navigationStatus, Lat: $latitude, Lon: $longitude, SOG: $speedOverGround, COG: $courseOverGround, GNSS: $gnssPositionStatus, Spare: $spare)';

  factory LongRangeAISBroadcastMessage.fromBinary(String binary) {
    // common
    int messageType = int.parse(binary.substring(0, 6), radix: 2);
    int repeatIndicator = int.parse(binary.substring(6, 8), radix: 2);
    int mmsi = int.parse(binary.substring(8, 38), radix: 2);

    // binary ranges specific to type 27
    String raimEnabledBin = binary.substring(39, 40);
    String navigationStatusBin = binary.substring(40, 44);
    String longitudeBin = binary.substring(44, 62); // Type 27 position
    String latitudeBin = binary.substring(62, 79); // Type 27 position
    String speedBin = binary.substring(79, 85);
    String courseBin = binary.substring(85, 94);
    String gnssBin = binary.substring(94, 95);
    String spareBin = binary.substring(95, 96);

    // conversion to actually readable data
    int raimEnabled = int.parse(raimEnabledBin, radix: 2);
    String? navigationStatus = BinaryConverter().navigationStatusInfo(
      navigationStatusBin,
    );
    double? longitude = CoordinateUtils().calculateLongitude(longitudeBin);
    double? latitude = CoordinateUtils().calculateLatitude(latitudeBin);
    double speed = int.parse(speedBin, radix: 2) / 10.0;
    double course = int.parse(courseBin, radix: 2) / 10.0;
    int gnssStatus = int.parse(gnssBin, radix: 2);
    int spare = int.parse(spareBin, radix: 2);

    return LongRangeAISBroadcastMessage(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      navigationStatus: navigationStatus ?? '',
      latitude: latitude,
      longitude: longitude,
      speedOverGround: speed,
      courseOverGround: course,
      raimEnabled: raimEnabled,
      gnssPositionStatus: gnssStatus,
      spare: spare,
    );
  }

  factory LongRangeAISBroadcastMessage.fromBitArray(BoolList bitArray) {
    // common
    int messageType = asInt(bitArray, 0, 6);
    int repeatIndicator = asInt(bitArray, 6, 8);
    int mmsi = asInt(bitArray, 8, 38);

    // binary ranges specific to type 27
    int raimEnabled = asInt(bitArray, 39, 40);
    int navigationStatus = asInt(bitArray, 40, 44);
    int rawLongitude = asSignedInt(bitArray, 44, 62); // Type 27 position
    int rawLatitude = asSignedInt(bitArray, 62, 79); // Type 27 position
    int speedDecoded = asInt(bitArray, 79, 85);
    int courseDecoded = asInt(bitArray, 85, 94);
    int gnssStatus = asInt(bitArray, 94, 95);
    int spare = asInt(bitArray, 95, 96);

    // conversion to actually readable data
    String navigationStatusString =
        BinaryConverter.navigationStatusString(navigationStatus);
    const int nrLongitudeBits = 62 - 44;
    double? longitude = CoordinateUtils.calculateLongitudeFromRaw(
        rawLongitude, nrLongitudeBits);
    const int nrLatitudeBits = 79 - 62;
    double? latitude =
        CoordinateUtils.calculateLatitudeFromRaw(rawLatitude, nrLatitudeBits);
    double speed = speedDecoded / 10.0;
    double course = courseDecoded / 10.0;

    return LongRangeAISBroadcastMessage(
      messageType: messageType,
      mmsi: mmsi,
      repeatIndicator: repeatIndicator,
      navigationStatus: navigationStatusString,
      latitude: latitude,
      longitude: longitude,
      speedOverGround: speed,
      courseOverGround: course,
      raimEnabled: raimEnabled,
      gnssPositionStatus: gnssStatus,
      spare: spare,
    );
  }
}
