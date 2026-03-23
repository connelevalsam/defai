/*
* Created by Connel Asikong on 18/03/2026
*
*/

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_service.g.dart';

// ── Config ────────────────────────────────────────────────────────────────────

class ServerConfig {
  // Local — used during demo on same network
  static const _localUrl = 'http://localhost:3000';

  // Deployed fallback — set this after deploying to Railway/Render
  static const _deployedUrl = 'https://defai-server.railway.app';

  // Flip this to true when using deployed server
  static const _useDeployed = bool.fromEnvironment(
    'USE_DEPLOYED',
    defaultValue: false,
  );

  static String get baseUrl => _useDeployed ? _deployedUrl : _localUrl;

  // Must match server's API_SECRET in .env
  // In production: use flutter_dotenv or envied to inject this securely
  static const apiKey =
      '45116a1abf2db0ac8957cd8af65a1fc7f1ce416706cccd81b22bbce5ba7743f3';

  /*String.fromEnvironment(
    'API_SECRET',
    defaultValue: 'defai_dev_secret_change_in_prod',
  );*/
}

// ── Response models ───────────────────────────────────────────────────────────

class VaultInitResult {
  final String address;
  final String network;

  const VaultInitResult({required this.address, required this.network});

  factory VaultInitResult.fromJson(Map<String, dynamic> json) =>
      VaultInitResult(
        address: json['address'] as String,
        network: json['network'] as String,
      );
}

class BalanceResult {
  final String address;
  final String usdt;
  final String xaut;
  final String btc;
  final String lastUpdated;

  const BalanceResult({
    required this.address,
    required this.usdt,
    required this.xaut,
    required this.btc,
    required this.lastUpdated,
  });

  factory BalanceResult.fromJson(Map<String, dynamic> json) => BalanceResult(
    address: json['address'] as String,
    usdt: json['usdt']?.toString() ?? '0.00',
    xaut: json['xaut']?.toString() ?? '0.00',
    btc: json['btc']?.toString() ?? '0.00000000',
    lastUpdated: json['lastUpdated'] as String,
  );
}

class ReasoningResult {
  final List<String> steps;
  final String strategyType;
  final Map<String, dynamic> params;

  const ReasoningResult({
    required this.steps,
    required this.strategyType,
    required this.params,
  });

  factory ReasoningResult.fromJson(Map<String, dynamic> json) =>
      ReasoningResult(
        steps: List<String>.from(json['steps'] as List),
        strategyType: json['strategyType'] as String,
        params: Map<String, dynamic>.from(json['params'] as Map),
      );
}

class ExecutionResult {
  final bool executed;
  final String strategyType;
  final List<Map<String, dynamic>> results;
  final String? reason; // set when executed = false

  const ExecutionResult({
    required this.executed,
    required this.strategyType,
    required this.results,
    this.reason,
  });

  factory ExecutionResult.fromJson(Map<String, dynamic> json) =>
      ExecutionResult(
        executed: json['executed'] as bool,
        strategyType: json['strategyType'] as String? ?? '',
        results: List<Map<String, dynamic>>.from(
          (json['results'] as List? ?? []).map(
            (e) => Map<String, dynamic>.from(e as Map),
          ),
        ),
        reason: json['reason'] as String?,
      );
}

// ── Service ───────────────────────────────────────────────────────────────────

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'x-api-key': ServerConfig.apiKey,
  };

  // ── Health check ───────────────────────────────────────────────────────────

  Future<bool> isServerReachable() async {
    try {
      final response = await _client
          .get(Uri.parse('${ServerConfig.baseUrl}/health'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ── Wallet ─────────────────────────────────────────────────────────────────

  /// Initialises a WDK wallet server-side from a mnemonic.
  /// Mnemonic is sent over HTTPS and used once — never stored by server.
  Future<VaultInitResult> initWallet(String mnemonic) async {
    final response = await _client
        .post(
          Uri.parse('${ServerConfig.baseUrl}/wallet/init'),
          headers: _headers,
          body: jsonEncode({'mnemonic': mnemonic}),
        )
        .timeout(const Duration(seconds: 15));

    return _handleResponse(response, (json) => VaultInitResult.fromJson(json));
  }

  /// Fetches live balances for a vault address.
  Future<BalanceResult> getBalance(String address) async {
    final response = await _client
        .get(
          Uri.parse('${ServerConfig.baseUrl}/wallet/balance/$address'),
          headers: _headers,
        )
        .timeout(const Duration(seconds: 10));

    return _handleResponse(response, (json) => BalanceResult.fromJson(json));
  }

  // ── Agent ──────────────────────────────────────────────────────────────────

  /// Gets reasoning steps for a command — no onchain action.
  /// Powers the Reasoning Board UI.
  Future<ReasoningResult> getReasoning(String command) async {
    final response = await _client
        .post(
          Uri.parse('${ServerConfig.baseUrl}/agent/reason'),
          headers: _headers,
          body: jsonEncode({'command': command}),
        )
        .timeout(const Duration(seconds: 10));

    return _handleResponse(response, (json) => ReasoningResult.fromJson(json));
  }

  /// Executes a Sentinel strategy onchain.
  /// Called ONLY after Sovereign Handshake passes.
  Future<ExecutionResult> executeStrategy({
    required String address,
    required String strategyType,
    required Map<String, dynamic> params,
  }) async {
    final response = await _client
        .post(
          Uri.parse('${ServerConfig.baseUrl}/agent/execute'),
          headers: _headers,
          body: jsonEncode({
            'address': address,
            'strategyType': strategyType,
            'params': params,
          }),
        )
        .timeout(const Duration(seconds: 30));

    return _handleResponse(response, (json) => ExecutionResult.fromJson(json));
  }

  // ── Error handling ─────────────────────────────────────────────────────────

  T _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return fromJson(json);
    }

    final error = _parseError(response);
    debugPrint('[ApiService] Error ${response.statusCode}: $error');
    throw ApiException(statusCode: response.statusCode, message: error);
  }

  String _parseError(http.Response response) {
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return json['error'] as String? ?? 'Unknown error';
    } catch (_) {
      return 'Server error ${response.statusCode}';
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

// ── Provider ──────────────────────────────────────────────────────────────────

@riverpod
ApiService apiService(Ref ref) => ApiService();
