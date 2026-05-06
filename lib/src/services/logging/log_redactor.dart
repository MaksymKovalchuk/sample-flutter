// add keys as they appear in your API surface
const _sensitiveKeys = <String>{
  'password',
  'pwd',
  'pass',
  'passwd',
  'token',
  'access_token',
  'refresh_token',
  'id_token',
  'secret',
  'api_key',
  'apikey',
  'authorization',
  'pin',
  'otp',
  'cvv',
  'cvc',
};

const String _redactedMask = '***';

dynamic redactSensitive(dynamic value) {
  if (value is Map) {
    return value.map((dynamic k, dynamic v) {
      if (k is String && _sensitiveKeys.contains(k.toLowerCase())) {
        return MapEntry<dynamic, dynamic>(k, _redactedMask);
      }
      return MapEntry<dynamic, dynamic>(k, redactSensitive(v));
    });
  }
  if (value is List) {
    return value.map(redactSensitive).toList(growable: false);
  }
  return value;
}
