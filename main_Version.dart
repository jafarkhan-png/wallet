import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

final allTransactions = [
  // Paste your 50 transactions here!
];

Response getBalance(Request request) => Response.ok(
      json.encode({"balance": 1250.50, "currency": "AED"}),
      headers: {'Content-Type': 'application/json'},
    );

Response getHistory(Request request) {
  final params = request.url.queryParameters;
  final page = int.tryParse(params['page'] ?? '1') ?? 1;
  final limit = int.tryParse(params['limit'] ?? '10') ?? 10;

  final totalItems = allTransactions.length;
  final totalPages = (totalItems / limit).ceil();
  final start = (page - 1) * limit;
  final end = start + limit > totalItems ? totalItems : start + limit;

  final transactions = start < totalItems
      ? allTransactions.sublist(start, end)
      : [];

  final response = {
    "transactions": transactions,
    "pagination": {
      "currentPage": page,
      "totalPages": totalPages,
      "totalItems": totalItems,
      "limit": limit,
      "hasNext": page < totalPages,
      "hasPrevious": page > 1,
    },
  };

  return Response.ok(json.encode(response), headers: {'Content-Type': 'application/json'});
}

void main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080')!;
  final router = Router()
    ..get('/balance', getBalance)
    ..get('/history', getHistory);

  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(router);

  final server = await serve(handler, InternetAddress.anyIPv4, port);
  print('Server started on port: $port');
}