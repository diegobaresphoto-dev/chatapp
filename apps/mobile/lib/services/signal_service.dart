import 'dart:convert';
import 'dart:typed_data';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SignalService {
  // Generate a complete pre-key bundle for the user to upload to the server
  static Future<Map<String, dynamic>> generatePreKeyBundle(int deviceId) async {
    // 1. Generate Identity Key Pair
    final identityKeyPair = KeyHelper.generateIdentityKeyPair();
    final identityKeyPublic = base64Encode(identityKeyPair.getPublicKey().serialize());
    
    // 2. Generate Registration ID
    final registrationId = KeyHelper.generateRegistrationId();
    
    // 3. Generate Signed PreKey
    final signedPreKeyId = KeyHelper.generateRegistrationId(); // Randomized ID
    final signedPreKey = KeyHelper.generateSignedPreKey(identityKeyPair, signedPreKeyId);
    final signedPreKeyPublic = base64Encode(signedPreKey.getPublicKey().serialize());
    final signedPreKeySignature = base64Encode(signedPreKey.getSignature());

    // 4. Generate a batch of One-Time PreKeys (e.g., 50 for MVP)
    final oneTimePreKeys = KeyHelper.generatePreKeys(0, 50);
    final oneTimePreKeysData = oneTimePreKeys.map((k) => {
      'id': k.id,
      'publicKey': base64Encode(k.getPublicKey().serialize()),
    }).toList();

    return {
      'registrationId': registrationId,
      'deviceId': deviceId,
      'identityPublicKey': identityKeyPublic,
      'signedPreKey': {
        'id': signedPreKeyId,
        'publicKey': signedPreKeyPublic,
        'signature': signedPreKeySignature,
      },
      'oneTimePreKeys': oneTimePreKeysData,
      // Note: Private keys MUST be stored securely locally, NEVER uploaded
      '_meta': {
        'identityKeyPair': identityKeyPair,
        'signedPreKeyPrivate': signedPreKey,
        'oneTimePreKeysPrivate': oneTimePreKeys,
      }
    };
  }

  // More methods for session initialization and encryption will follow in Phase 2
}
