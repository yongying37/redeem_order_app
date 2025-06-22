enum RequestType {
  GET('GET'),
  POST('POST'),
  PUT('PUT'),
  DELETE('DELETE');

  final String stringValue;
  const RequestType(this.stringValue);
}

enum ProjectType {
  SANDBOX
}