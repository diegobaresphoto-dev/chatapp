import 'dart:convert';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class EncryptionService {
  final SignalProtocolStore _store;

  EncryptionService(this._store);

  // Initialize a session with a recipient using their prekey bundle from the server
  Future<void> initializeSession(String remoteUserId, Map<String, dynamic> bundle) async {
    final remoteAddress = SignalProtocolAddress(remoteUserId, bundle['deviceId']);
    final sessionBuilder = SessionBuilder(_store, remoteAddress);

    final preKeyBundle = PreKeyBundle(
      bundle['registrationId'] ?? 0,
      bundle['deviceId'],
      null, // preKeyId (optional if oneTimePreKey exists)
      bundle['oneTimePreKey'] != null ? Curve.decodePoint(base64Decode(bundle['oneTimePreKey']['publicKey']), 0) : null,
      bundle['oneTimePreKey']?.id,
      Curve.decodePoint(base64Decode(bundle['signedPreKey']['publicKey']), 0),
      bundle['signedPreKey']['id'],
      base64Decode(bundle['signedPreKey']['signature']),
      IdentityKey(Curve.decodePoint(base64Decode(bundle['identityPublicKey']), 0)),
    );

    await sessionBuilder.processPreKeyBundle(preKeyBundle);
  }

  // Encrypt a plain text message
  Future<String> encryptMessage(String remoteUserId, int deviceId, String plaintext) async {
    final remoteAddress = SignalProtocolAddress(remoteUserId, deviceId);
    final sessionCipher = SessionCipher(_store, remoteAddress);
    
    final ciphertext = await sessionCipher.encrypt(Uint8List.fromList(utf8.encode(plaintext)));
    // Signal returns a CiphertextMessage (PreKeySignalMessage or SignalMessage)
    return base64Encode(ciphertext.serialize());
  }

  // Decrypt a ciphertext message
  Future<String> decryptMessage(String remoteUserId, int deviceId, String base64Ciphertext) async {
    final remoteAddress = SignalProtocolAddress(remoteUserId, deviceId);
    final sessionCipher = SessionCipher(_store, remoteAddress);
    
    final ciphertextBuffer = base64Decode(base64Ciphertext);
    // Note: In a real app, you need to know if it's a SignalMessage or PreKeySignalMessage
    // For simplicity in MVP, we try to parse it.
    final signalMessage = SignalMessage.fromSerialized(ciphertextBuffer);
    final plaintext = await sessionCipher.decrypt(signalMessage);
    
    return utf8.decode(plaintext);
  }
}
