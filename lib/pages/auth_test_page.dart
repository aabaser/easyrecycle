import "dart:convert";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:http/http.dart" as http;

import "../config/api_config.dart";
import "../l10n/app_localizations.dart";
import "../state/app_state.dart";
import "../theme/design_tokens.dart";

class AuthTestPage extends StatefulWidget {
  const AuthTestPage({super.key});

  @override
  State<AuthTestPage> createState() => _AuthTestPageState();
}

class _AuthTestPageState extends State<AuthTestPage> {
  final _deviceIdController = TextEditingController();
  String? _token;
  String? _response;
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _deviceIdController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_deviceIdController.text.isEmpty) {
      final appState = context.read<AppState>();
      if (appState.sessionId.isNotEmpty) {
        _deviceIdController.text = appState.sessionId;
      }
    }
  }

  Future<void> _postGuest() async {
    final deviceId = _deviceIdController.text.trim();
    if (deviceId.length < 8) {
      setState(() {
        _error = "device_id too short";
        _response = null;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/auth/guest");
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"device_id": deviceId, "attestation": "TODO"}),
      );
      final body = res.body;
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(body) as Map<String, dynamic>;
        setState(() {
          _token = data["access_token"]?.toString();
          _response = body;
        });
      } else {
        setState(() {
          _error = "HTTP ${res.statusCode}";
          _response = body;
        });
      }
    } catch (err) {
      setState(() {
        _error = err.toString();
        _response = null;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _callMe() async {
    if (_token == null || _token!.isEmpty) {
      setState(() {
        _error = "missing token";
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/auth/me");
      final res = await http.get(
        url,
        headers: {"Authorization": "Bearer $_token"},
      );
      setState(() {
        _response = res.body;
        if (res.statusCode >= 400) {
          _error = "HTTP ${res.statusCode}";
        }
      });
    } catch (err) {
      setState(() {
        _error = err.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _callVerify() async {
    if (_token == null || _token!.isEmpty) {
      setState(() {
        _error = "missing token";
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final url = Uri.parse("${ApiConfig.baseUrl}/auth/verify");
      final res = await http.post(
        url,
        headers: {"Authorization": "Bearer $_token"},
      );
      setState(() {
        _response = res.body;
        if (res.statusCode >= 400) {
          _error = "HTTP ${res.statusCode}";
        }
      });
    } catch (err) {
      setState(() {
        _error = err.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _clearToken() {
    setState(() {
      _token = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t("auth_test_title")),
      ),
      body: ListView(
        padding: const EdgeInsets.all(DesignTokens.sectionSpacing),
        children: [
          TextField(
            controller: _deviceIdController,
            decoration: InputDecoration(
              labelText: loc.t("auth_test_device_id"),
            ),
          ),
          const SizedBox(height: DesignTokens.baseSpacing),
          ElevatedButton(
            onPressed: _loading ? null : _postGuest,
            child: Text(loc.t("auth_test_get_guest")),
          ),
          const SizedBox(height: DesignTokens.baseSpacing),
          if (_token != null && _token!.isNotEmpty) ...[
            Text(loc.t("auth_test_token"), style: DesignTokens.titleM),
            const SizedBox(height: 6),
            SelectableText(
              _token!,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: DesignTokens.baseSpacing),
            TextButton(
              onPressed: _loading ? null : _clearToken,
              child: Text(loc.t("auth_test_clear_token")),
            ),
          ],
          const SizedBox(height: DesignTokens.baseSpacing),
          OutlinedButton(
            onPressed: _loading ? null : _callMe,
            child: Text(loc.t("auth_test_call_me")),
          ),
          const SizedBox(height: DesignTokens.baseSpacing),
          OutlinedButton(
            onPressed: _loading ? null : _callVerify,
            child: Text(loc.t("auth_test_call_verify")),
          ),
          const SizedBox(height: DesignTokens.sectionSpacing),
          if (_error != null) ...[
            Text(loc.t("auth_test_error"), style: DesignTokens.titleM),
            const SizedBox(height: 6),
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: DesignTokens.sectionSpacing),
          ],
          if (_response != null) ...[
            Text(loc.t("auth_test_response"), style: DesignTokens.titleM),
            const SizedBox(height: 6),
            SelectableText(
              _response!,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
