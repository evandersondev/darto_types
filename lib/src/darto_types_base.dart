import 'dart:async';
import 'dart:typed_data';

typedef NextFunction = void Function([Exception error]);
typedef Middleware =
    dynamic Function(Request req, Response res, NextFunction next);
typedef RouteHandler = dynamic Function(Request req, Response res);
typedef ErrorHandler =
    void Function(
      Exception err,
      Request req,
      Response res,
      void Function([Exception error]),
    );
typedef Err = Exception;
typedef Handler = void;
typedef ParamMiddleware =
    void Function(Request req, Response res, NextFunction next, String value);
typedef RenderLayout = FutureOr<Response> Function(String content);

abstract interface class DartoHeader {
  String? get authorization;
  String? get(String name);
  void append(String name, String value);
  Map<String, List<String>> get allHeaders;
}

abstract interface class Request {
  Map<String, String> get param;
  Map<String, dynamic>? file;
  int? timeout;
  late bool timedOut;
  Uri get uri;
  String get method;
  Map<String, String> get query;
  String get baseUrl;
  DartoHeader get headers;
  String get host;
  String get hostname;
  String get originalUrl;
  String get path;
  String get ip;
  String get protocol;
  Map<String, dynamic> get context;
  Map<String, dynamic> get session;
  void Function()? onResponseFinished;

  List<String?> params();
  Stream<List<int>> cast<T>();
  List<String> get ips;
  Map<String, String> get cookies;

  Future<dynamic> get body;
  Future<Uint8List> blob();
  Future<ByteBuffer> arrayBuffer();
  Future<dynamic> formData();
  Future<T> bodyParse<T>(T Function(dynamic body) parser);
}

abstract interface class Response {
  bool get finished;
  Map<String, dynamic> get locals;
  DartoHeader get headers;

  Response status(int statusCode);
  void set(String field, String value);
  void setRender(RenderLayout layout);
  void sendFile(String filePath);
  void send([dynamic data]);
  void json(dynamic data);
  void error([dynamic e]);
  Future<void> render(String templateName, Map<String, dynamic> head);
  Future<Response> text(String data);
  Future<Response> html(String data);
  Future<Response> notFound();
  Future<Response> body(dynamic data, int status, Map<String, dynamic> headers);
  void end([dynamic data]);
  void download(String filePath, [dynamic filename, dynamic callback]);
  void removeHeader(String field);
  void cookie(String name, String value, [Map<String, dynamic>? options]);
  void clearCookie(String name, [Map<String, dynamic>? options]);
  void redirect(String url);
  Response type(String mimeType);
  Future<void> pipe(Stream<List<int>> stream);
  void setETag(String tag);
  void setCacheControl(String value);
}
