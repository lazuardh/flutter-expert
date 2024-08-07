import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class HttpSSLPinning {
  static Future<http.Client> get _instance async =>
      _clientInstance ??= await Shared.createLEClient();
  static http.Client? _clientInstance;
  static http.Client get client => _clientInstance ?? http.Client();
  static Future<void> init() async {
    _clientInstance = await _instance;
  }
}

class Shared {
  static Future<HttpClient> customHttpClient({
    bool isTestMode = false,
  }) async {
    SecurityContext context = SecurityContext(withTrustedRoots: false);
    try {
      List<int> bytes = [];
      if (isTestMode) {
        bytes = utf8.encode(_certificatedString);
      } else {
        bytes = (await rootBundle.load('certificates/_.themoviedb.org.crt'))
            .buffer
            .asUint8List();
      }
      log('bytes $bytes');
      context.setTrustedCertificatesBytes(bytes);
      log('createHttpClient() - cert added!');
    } on TlsException catch (e) {
      if (e.osError?.message != null &&
          e.osError!.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
        log('createHttpClient() - cert already trusted! Skipping.');
      } else {
        log('createHttpClient().setTrustedCertificateBytes EXCEPTION: $e');
        rethrow;
      }
    } catch (e) {
      log('unexpected error $e');
      rethrow;
    }
    HttpClient httpClient = HttpClient(context: context);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;

    return httpClient;
  }

  static Future<http.Client> createLEClient({bool isTestMode = false}) async {
    IOClient client =
        IOClient(await Shared.customHttpClient(isTestMode: isTestMode));
    return client;
  }
}

const _certificatedString = """-----BEGIN CERTIFICATE-----
MIIF3TCCBMWgAwIBAgIQDIRjj8W7ulbGuS9jNTIJozANBgkqhkiG9w0BAQsFADA8
MQswCQYDVQQGEwJVUzEPMA0GA1UEChMGQW1hem9uMRwwGgYDVQQDExNBbWF6b24g
UlNBIDIwNDggTTAyMB4XDTI0MDcyMDAwMDAwMFoXDTI1MDgxNzIzNTk1OVowGzEZ
MBcGA1UEAwwQKi50aGVtb3ZpZWRiLm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBALCw4Llit9ppte89e8whx71Q+TGAHZSr4TOvEzZ3A6Si3Mw/Ehsl
bviA+u3Y2k+l0bHK5J49QCp2OADkuumZQwOs01ZDj6OXVio63hF8UMUAkM4WYskW
eml31GHng14rKswE8MXDInb4z2L1AumixoNt/tOzWW/zh8AoBpiRfeZkBfgGliv3
f06bXdihV8QCTVGzDQxI0/h5xcus2xip7V9Z1I9e3D1a8qPb1d+Eq/3RytLpisvJ
syDmzlDaSJIDwJlF0cXMGkqbVEdu31u2vKsLX8Jo+SY8uSHfQoIT90UYjkrpg9gR
95buo6QNB1GtWmD6kKWuQKc2CC43GrDAf1sCAwEAAaOCAvowggL2MB8GA1UdIwQY
MBaAFMAxUs1aUMOCfHRxzsvpnPl664LiMB0GA1UdDgQWBBQz6Yhcbr+UeFdpQyPr
vigxARkp/DArBgNVHREEJDAighAqLnRoZW1vdmllZGIub3Jngg50aGVtb3ZpZWRi
Lm9yZzATBgNVHSAEDDAKMAgGBmeBDAECATAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0l
BBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMDsGA1UdHwQ0MDIwMKAuoCyGKmh0dHA6
Ly9jcmwucjJtMDIuYW1hem9udHJ1c3QuY29tL3IybTAyLmNybDB1BggrBgEFBQcB
AQRpMGcwLQYIKwYBBQUHMAGGIWh0dHA6Ly9vY3NwLnIybTAyLmFtYXpvbnRydXN0
LmNvbTA2BggrBgEFBQcwAoYqaHR0cDovL2NydC5yMm0wMi5hbWF6b250cnVzdC5j
b20vcjJtMDIuY2VyMAwGA1UdEwEB/wQCMAAwggF/BgorBgEEAdZ5AgQCBIIBbwSC
AWsBaQB3ABLxTjS9U3JMhAYZw48/ehP457Vih4icbTAFhOvlhiY6AAABkM7YzdgA
AAQDAEgwRgIhAIpZdWMHKUtnEMjWDg5w914zaC+XupTEirI1Wp84jBH3AiEArWtU
dkUd9sgetAAmS5KyKAi38X3CBFGl7KuGxJneN4EAdwB9WR4S4XgqexxhZ3xe/fjQ
h1wUoE6VnrkDL9kOjC55uAAAAZDO2M2LAAAEAwBIMEYCIQCeAuPnafXKNNrowj3R
gRdGOiQvpeU74DrdyYNm3Syi8QIhAJuTZQswk/GgcXaRfR6q6x+ec1cmlVkMiLPo
pcWFOitlAHUAzPsPaoVxCWX+lZtTzumyfCLphVwNl422qX5UwP5MDbAAAAGQztjN
cwAABAMARjBEAiAvqu9FMOi1ZNDGiT2twkVB3hrxzs8Q/B/MOuegKat+iQIgPAQ4
eji+kOB+hKnHtD+kjNgsykUtmfNvCBkWc37J/IMwDQYJKoZIhvcNAQELBQADggEB
ADN1PdzDhugCY/2UN8R3z5zh3I5EK5ccfB/s/dOqc0ZTZCbncefoKabf8rzxKNyS
uJFFWptvH64be7e4UgfPH9hnIz7eeaetTebPbLKIkndBjHfjxlWy1j1aFguYzs8a
f8ZB0pKdmQl/Zwy6gm9DvkbpnUq9D6rSQaxs0yrIpa7Z7OiR1/2S/uQMJ0U3Y2kJ
LoJq7bQIfVROdFnl4P6azL14IoFctOX7y1UVMRaq6Pg95pk/6O63J7FvY+/wYrDy
8AhJvTZ8vUbiB4y2HNcos+9OasWTw51d3uuRBvqlNmVdCxn0xZ3EohVLfKRc6F7r
2Jc4EOG6b+RP6wkC0R5oMhQ=
-----END CERTIFICATE-----""";
