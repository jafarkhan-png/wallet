import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

final allTransactions = [
  // Page 1 (1-10)
  {"id": "TXN-001", "type": "credit", "amount": 500.00, "description": "Salary", "date": "2026-02-18"},
  {"id": "TXN-002", "type": "debit", "amount": 50.25, "description": "Coffee Shop", "date": "2026-02-17"},
  {"id": "TXN-003", "type": "debit", "amount": 120.00, "description": "Grocery Store", "date": "2026-02-16"},
  {"id": "TXN-004", "type": "credit", "amount": 200.00, "description": "Refund", "date": "2026-02-15"},
  {"id": "TXN-005", "type": "debit", "amount": 75.50, "description": "Restaurant", "date": "2026-02-14"},
  {"id": "TXN-006", "type": "debit", "amount": 45.00, "description": "Uber Ride", "date": "2026-02-13"},
  {"id": "TXN-007", "type": "credit", "amount": 150.00, "description": "Freelance Payment", "date": "2026-02-12"},
  {"id": "TXN-008", "type": "debit", "amount": 89.99, "description": "Netflix Subscription", "date": "2026-02-11"},
  {"id": "TXN-009", "type": "debit", "amount": 230.00, "description": "Electric Bill", "date": "2026-02-10"},
  {"id": "TXN-010", "type": "credit", "amount": 1000.00, "description": "Bank Transfer", "date": "2026-02-09"},
  // Page 2 (11-20)
  {"id": "TXN-011", "type": "debit", "amount": 65.50, "description": "Pharmacy", "date": "2026-02-08"},
  {"id": "TXN-012", "type": "debit", "amount": 42.00, "description": "Lunch", "date": "2026-02-07"},
  {"id": "TXN-013", "type": "credit", "amount": 300.00, "description": "Gift Received", "date": "2026-02-06"},
  {"id": "TXN-014", "type": "debit", "amount": 180.00, "description": "Shopping", "date": "2026-02-05"},
  {"id": "TXN-015", "type": "debit", "amount": 25.00, "description": "Parking", "date": "2026-02-04"},
  {"id": "TXN-016", "type": "credit", "amount": 750.00, "description": "Bonus", "date": "2026-02-03"},
  {"id": "TXN-017", "type": "debit", "amount": 35.00, "description": "Book Store", "date": "2026-02-02"},
  {"id": "TXN-018", "type": "debit", "amount": 112.50, "description": "Internet Bill", "date": "2026-02-01"},
  {"id": "TXN-019", "type": "debit", "amount": 28.00, "description": "Spotify", "date": "2026-01-31"},
  {"id": "TXN-020", "type": "credit", "amount": 50.00, "description": "Cashback Reward", "date": "2026-01-30"},
  // Page 3 (21-30)
  {"id": "TXN-021", "type": "debit", "amount": 95.00, "description": "Gas Station", "date": "2026-01-29"},
  {"id": "TXN-022", "type": "debit", "amount": 220.00, "description": "Car Wash", "date": "2026-01-28"},
  {"id": "TXN-023", "type": "credit", "amount": 1500.00, "description": "Client Payment", "date": "2026-01-27"},
  {"id": "TXN-024", "type": "debit", "amount": 67.80, "description": "Dinner", "date": "2026-01-26"},
  {"id": "TXN-025", "type": "debit", "amount": 15.00, "description": "Movie Ticket", "date": "2026-01-25"},
  {"id": "TXN-026", "type": "debit", "amount": 340.00, "description": "Flight Booking", "date": "2026-01-24"},
  {"id": "TXN-027", "type": "credit", "amount": 100.00, "description": "Birthday Gift", "date": "2026-01-23"},
  {"id": "TXN-028", "type": "debit", "amount": 55.00, "description": "Gym Membership", "date": "2026-01-22"},
  {"id": "TXN-029", "type": "debit", "amount": 82.00, "description": "Electronics", "date": "2026-01-21"},
  {"id": "TXN-030", "type": "credit", "amount": 250.00, "description": "Tax Refund", "date": "2026-01-20"},
  // Page 4 (31-40)
  {"id": "TXN-031", "type": "debit", "amount": 19.99, "description": "App Subscription", "date": "2026-01-19"},
  {"id": "TXN-032", "type": "debit", "amount": 145.00, "description": "Hotel Stay", "date": "2026-01-18"},
  {"id": "TXN-033", "type": "credit", "amount": 500.00, "description": "Salary", "date": "2026-01-17"},
  {"id": "TXN-034", "type": "debit", "amount": 38.50, "description": "Taxi", "date": "2026-01-16"},
  {"id": "TXN-035", "type": "debit", "amount": 72.00, "description": "Clothing", "date": "2026-01-15"},
  {"id": "TXN-036", "type": "credit", "amount": 80.00, "description": "Sold Item", "date": "2026-01-14"},
  {"id": "TXN-037", "type": "debit", "amount": 125.00, "description": "Medical Checkup", "date": "2026-01-13"},
  {"id": "TXN-038", "type": "debit", "amount": 33.00, "description": "Stationery", "date": "2026-01-12"},
  {"id": "TXN-039", "type": "debit", "amount": 210.00, "description": "Furniture", "date": "2026-01-11"},
  {"id": "TXN-040", "type": "credit", "amount": 175.00, "description": "Dividend", "date": "2026-01-10"},
  // Page 5 (41-50)
  {"id": "TXN-041", "type": "debit", "amount": 60.00, "description": "Haircut", "date": "2026-01-09"},
  {"id": "TXN-042", "type": "debit", "amount": 48.00, "description": "Pet Food", "date": "2026-01-08"},
  {"id": "TXN-043", "type": "credit", "amount": 400.00, "description": "Freelance Project", "date": "2026-01-07"},
  {"id": "TXN-044", "type": "debit", "amount": 92.00, "description": "Water Bill", "date": "2026-01-06"},
  {"id": "TXN-045", "type": "debit", "amount": 27.50, "description": "Snacks", "date": "2026-01-05"},
  {"id": "TXN-046", "type": "credit", "amount": 600.00, "description": "Investment Return", "date": "2026-01-04"},
  {"id": "TXN-047", "type": "debit", "amount": 135.00, "description": "Concert Tickets", "date": "2026-01-03"},
  {"id": "TXN-048", "type": "debit", "amount": 85.00, "description": "Dentist", "date": "2026-01-02"},
  {"id": "TXN-049", "type": "credit", "amount": 50.00, "description": "New Year Gift", "date": "2026-01-01"},
  {"id": "TXN-050", "type": "debit", "amount": 199.00, "description": "New Year Party", "date": "2025-12-31"},
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