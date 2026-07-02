import 'package:ais_decoder/ais_decoder.dart';
import 'package:test/test.dart';

void main() {
  group('Type 1', () {
    test('Example 1', () {
      final field5 = kType1Example1.split(',')[5];
      final message = AISMessage.fromPayload(field5);
      expect(message, isNotNull);
      expect(message.messageType, 1);
      expect(message.mmsi, 256321000);
      expect(message.repeatIndicator, 0);
      expect(message, isA<PositionMessage>());
      final typed = message as PositionMessage;
      expect(typed.navigationStatus, 'Under way using engine');
      expect(typed.latitude, 37.729603);
      expect(typed.longitude, 23.354215);
      expect(typed.speedOverGround, 12.8);
      expect(typed.courseOverGround, 223.0);
      expect(typed.maneuverIndicator, 'Not available (Default)');
      expect(typed.rateOfTurn, 5.401474888342364);
      expect(typed.heading, 225.0);
      expect(typed.timestamp, 35);
      expect(typed.raimEnabled, 0);
    });
    test('example 2', () {
      final field5 = kType1Example2.split(',')[5];
      final message = AISMessage.fromPayload(field5);
      expect(message, isNotNull);
      expect(message.messageType, 1);
      expect(message.mmsi, 241133000);
      expect(message.repeatIndicator, 0);
      expect(message, isA<PositionMessage>());
      final typed = message as PositionMessage;
      expect(typed.navigationStatus, 'Under way using engine');
      expect(typed.latitude, 37.818638);
      expect(typed.longitude, 23.494813);
      expect(typed.speedOverGround, 15.1);
      expect(typed.courseOverGround, 54.6);
      expect(typed.maneuverIndicator, 'Not available (Default)');
      expect(typed.rateOfTurn, isNaN);
      expect(typed.heading, isNull);
      expect(typed.timestamp, 46);
      expect(typed.raimEnabled, 1);
    });
  });
  group('Type 3', () {
    test('example 1', () {
      final field5 = kType3Example1.split(',')[5];
      final message = AISMessage.fromPayload(field5);
      expect(message, isNotNull);
      expect(message.messageType, 3);
      expect(message.mmsi, 366525000);
      expect(message.repeatIndicator, 0);
      expect(message, isA<PositionMessage>());
      final typed = message as PositionMessage;
      expect(typed.navigationStatus, 'At anchor');
      expect(typed.latitude, 37.87433);
      expect(typed.longitude, 23.525713);
      expect(typed.speedOverGround, 0.1);
      expect(typed.courseOverGround, 118.6);
      expect(typed.maneuverIndicator, 'Not available (Default)');
      expect(typed.rateOfTurn, 0.0);
      expect(typed.heading, 34.0);
      expect(typed.timestamp, 7);
      expect(typed.raimEnabled, 0);
    });
    test('example 2', () {
      final field5 = kType3Example2.split(',')[5];
      final message = AISMessage.fromPayload(field5);
      expect(message, isNotNull);
      expect(message.messageType, 3);
      expect(message.mmsi, 248223000);
      expect(message.repeatIndicator, 0);
      expect(message, isA<PositionMessage>());
      final typed = message as PositionMessage;
      expect(typed.navigationStatus, 'Under way using engine');
      expect(typed.latitude, 37.51329);
      expect(typed.longitude, 23.544977);
      expect(typed.speedOverGround, 12.9);
      expect(typed.courseOverGround, 351.2);
      expect(typed.maneuverIndicator, 'Not available (Default)');
      expect(typed.rateOfTurn, -708.1);
      expect(typed.heading, 352.0);
      expect(typed.timestamp, 6);
      expect(typed.raimEnabled, 0);
    });
  });
}

const kType1Example1 = '!AIVDM,1,1,,A,13lLUr02j01br3REUdh`eW3608Dn,0*52';
const kType1Example2 = '!AIVDM,1,1,,A,13UuUj0P2GQcS?hE`uKj8gwL2@KF,0*72';
const kType3Example1 = '!AIVDM,1,1,,A,35MRrB10011cdC8EbwuT`Q4>0Dqb,0*6F';
const kType3Example2 = '!AIVDM,1,1,,A,33dfE60PB11citDEMiief;0<00b0,0*21';
const kType5Example1Line1 =
    '!AIVDM,2,1,0,B,55QaC@42@>Uw<HlGN20dE8Dn0d5848DdU:222216:PC6:5eW0?AiD52H8888,0*4C';
const kType5Example1Line2 = '!AIVDM,2,2,0,B,88888888880,2*27';
const kType5Example2Line1 =
    '!AIVDM,2,1,1,A,53R1dC01U0W9=KO;?F0p4I@Thu>22222222222166p=825bGN;PAAjCPH31C,0*2C';
const kType5Example2Line2 = '!AIVDM,2,2,1,A,kQ2H8888880,2*65';
const kType18Example1 = '!AIVDM,1,1,,B,B3`e<W@01hJMcvUIe3rWSwnUoP06,0*48';
const kType18Example2 = '!AIVDM,1,1,,A,B46CbvP008JN885IfS;Q3wsUoP06,0*25';
