import 'dart:developer';
import 'package:googleapis_auth/auth_io.dart';
import 'package:logger/logger.dart';


class ServerKeyService {
  final logger = Logger();
  String? serverKey;

  Future<String?> getServiceKey() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "proxix-app",
        "private_key_id": "d9c3db841ccda103f40d532eb5a2abdfdb4f54ac",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCgrCzL0T9ey7DS\nCqhEdlntml9nu6FDMMKew4MjtQMNvcwuIOTul1p/KJGmB/SSaePk01pD3Uf5LL7X\ntKbnOO83Eg/xD4knMSAjgQd8dbnS87jANHkLvCakGVEs7/61UGf67AC8XhEU1mrT\nRBaPJpEvFR05IXF2OQVGiOW4BHq9TNUrCOkMahdWATO4Mnncx+51ogKmHypUMcl+\nxuOmIBaGwg8s41lkiaJiG39gJKbSRaJakwHNFy61Yx1SJnHyQJhMKYCdPgmOxdKI\nZHV3boAP7xlHfFtxrhvUHWs6LbwgJuV1+vcHGHc5KrXoOe+bKIcSZYka83roP44o\nAXbzmcMnAgMBAAECggEABa4wo0ARmntfE/32dv0sLr9Pci5rBCIcL1rALyn+IqU8\nK8FT9q95LpezlogfeHGv8e4a+d0/5ypS0PN9Fx2nL24/DAm9kpolBbxRFHBhEnk1\nZe40/Vo4j4KpoQoXGjfuhSuE1yQIPJFcE34LwiHd7ikz8EojZcecTSMX5AqcgEbB\nw0yL/tyYFslt8SnA7HqreTDz8VSuWlN7KhD16zXi6q9+TQiG94RtjAE1wd3uDOyD\nvN/3Tm424jypqSk8MNTOOKiuGIixmUyPD/LVcvj2bbPNej9iEcDejHF5kykysr7R\nr4IYm9sBOtZBIh8hyLHstlVCL4pDQyzapkDhE4TjaQKBgQDUnVuRmYiZf8xMItA9\nbkpOX2m9s7AqNIuyD2pv8964iTgw9fdm4bZLILZyVjyVMToyzSdVLS9ViFBXqb7T\n9rzFYILhgzGT4xtwsYGEBaNn5WoXIblkLsjB6x9HgcZhaduOeTlrbYdfPpeWuH3i\nk3Vj5ReNVuHcflQTYwh3HEHNdQKBgQDBdXIyuMEfxQYWea9YzRz0LuwEnKBQHa2p\nN+HsODAd9G7pGDmewaZBOHjawh/Dh8qBoR7BPfS9nWECOXySJyhx3GoZ8L/gg1Hz\nvNKoUrNn3V+kx6Q3G632qFrWMr0bvYeCCpdTejsf8496oPSFQoLrdnNhqGW4xZyc\nWIabsgCuqwKBgQCaznBr1SSWz2yLSxXghLtp0SMG0xzDvjqwzXSsSx6xsofNbmpS\n6Kl4jjsJiSzXXF6JusKWzC2Y04XcLmYZo5/S/vCNDp88lLHYHga1f/14mpvid9Wq\n0j2upGnEAQPWzeLlG/Lo+3kDqmlpfq96F+/zakz5xnbxurGw4/y37UUkOQKBgDOd\nLwujSTs9qKMkcgjiKIBpaGTOmOLnGCcWlrscPpIvXcvov67AgafS9kN/GVRkjT3K\ni9cIvZw9Od2LEtY3hk3ifZhQKBExWBMMZLOt5NmoMVVYQlLFmsM9JYcSYGvfRCEI\nzFjkOpQKulQAT1yiYyWJI72BXSpP5rm70KYHdrEjAoGBAKRidy4sc2EVDX8y9OUf\njWZvs1IaXMVQp/aYvDxDSjxn/9sYqW3Q+SumyDuGswljU8tp0ciacYMB7UZxTFRq\ntO5YOSo0m6g5iKZjQcehd+GxFwYQ9G4Cto8jSyHTK4TqgcpZQzRwD4jNjOR4bucM\nHKbGIET489YrGElzd+dG7QgI\n-----END PRIVATE KEY-----\n",
        "client_email": "firebase-adminsdk-fbsvc@proxix-app.iam.gserviceaccount.com",
        "client_id": "115828562582390263589",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40proxix-app.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      }),
      scopes,
    );
    serverKey = client.credentials.accessToken.data;
    // NotificationPermissions notificationPermissions = NotificationPermissions();
    // String? deviceToken = await notificationPermissions.getDeviceToken();
    log('Key $serverKey');
    // log('Key $deviceToken');
    return serverKey;
  }
}
