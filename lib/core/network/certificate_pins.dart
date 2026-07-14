/// SHA-256 SPKI (Subject Public Key Info) pin hashes for known API domains.
///
/// Extracted from production server certificates using:
/// ```bash
/// echo | openssl s_client -connect HOST:443 | openssl x509 -pubkey -noout \
///   | openssl pkey -pubin -outform DER | openssl dgst -sha256 -binary | base64
/// ```
///
/// Each domain has 2 pins: leaf certificate + intermediate CA (backup)
/// to allow certificate rotation without breaking connectivity.
///
/// Pins should be refreshed when certificates are renewed.
class CertificatePins {
  const CertificatePins._();

  /// SHA-256 SPKI hashes for equran.id
  static const List<String> equranPins = [
    'sha256/IO/Zyx38/qp40M9+Ao9r4WVFj4tdzw1NR4nLPrAW7w4=', // leaf
    'sha256/kIdp6NNEd8wsugYyyIYFsi1ylMCED3hZbSR8ZFsa/A4=', // intermediate CA
  ];

  /// SHA-256 SPKI hashes for api.aladhan.com
  static const List<String> aladhanPins = [
    'sha256/HArisTwWg3FERHxn95DbOAZx/peUdAx2rdJzrlOnsHc=', // leaf
    'sha256/rnhtVs65ADYfQGtMuB0jq2kZwwHy6/iqnBiUKcK1m0Y=', // intermediate CA
  ];

  /// Returns pin list for a given host, or empty list if not pinned.
  static List<String> pinsForHost(String host) {
    if (host.contains('equran.id')) return equranPins;
    if (host.contains('aladhan.com')) return aladhanPins;
    return [];
  }

  /// All pinned domains and their pin lists.
  static const Map<String, List<String>> allPins = {
    'equran.id': equranPins,
    'api.aladhan.com': aladhanPins,
  };
}
