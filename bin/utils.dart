void addHeader(Map<String, String> headers, String name, String value) {
    final existing = headers[name];
    headers[name] = existing == null ? value : '$existing, $value';
  }    