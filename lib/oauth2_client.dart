import 'dart:io';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

// These URLs are endpoints that are provided by the authorization
// server. They're usually included in the server's documentation of its
// OAuth2 API.
final authorizationEndpoint = Uri.parse('https://oauth.battle.net/authorize');
final tokenEndpoint = Uri.parse('https://oauth.battle.net/token');

// The authorization server will issue each client a separate client
// identifier and secret, which allows the server to tell which client
// is accessing it. Some servers may also have an anonymous
// identifier/secret pair that any client may use.
//
// Note that clients whose source code or binary executable is readily
// available may not be able to make sure the client secret is kept a
// secret. This is fine; OAuth2 servers generally won't rely on knowing
// with certainty that a client is who it claims to be.
const identifier = '743e4becd032416b8baf7a2366f4d0ed';
const secret = 'KRHK62grnG0a8e2swGbOaJi1FkjRDr0f';

// This is a URL on your application's server. The authorization server
// will redirect the resource owner here once they've authorized the
// client. The redirection will include the authorization code in the
// query parameters.
final redirectUrl = Uri.parse('https://realmsup.com');

/// A file in which the users credentials are stored persistently. If the server
/// issues a refresh token allowing the client to refresh outdated credentials,
/// these may be valid indefinitely, meaning the user never has to
/// re-authenticate.
final credentialsFile = File('~/.realmsup/credentials.json');

/// Either load an OAuth2 client from saved credentials or authenticate a new
/// one.
Future<oauth2.Client> createClient() async {
  var exists = await credentialsFile.exists();

  // If the OAuth2 credentials have already been saved from a previous run, we
  // just want to reload them.
  if (exists) {
    var credentials =
        oauth2.Credentials.fromJson(await credentialsFile.readAsString());
    return oauth2.Client(credentials, identifier: identifier, secret: secret);
  }

  // If we don't have OAuth2 credentials yet, we need to get the resource owner
  // to authorize us. We're assuming here that we're a command-line application.
  var grant = oauth2.AuthorizationCodeGrant(
      identifier, authorizationEndpoint, tokenEndpoint,
      secret: secret);

  // A URL on the authorization server (authorizationEndpoint with some additional
  // query parameters). Scopes and state can optionally be passed into this method.
  var authorizationUrl = grant.getAuthorizationUrl(redirectUrl);

  // Redirect the resource owner to the authorization URL. Once the resource
  // owner has authorized, they'll be redirected to `redirectUrl` with an
  // authorization code. The `redirect` should cause the browser to redirect to
  // another URL which should also have a listener.
  //
  // `redirect` and `listen` are not shown implemented here. See below for the
  // details.
  // await redirect(authorizationUrl);
  // var responseUrl = await listen(redirectUrl);
  dynamic responseUrl;

  if (await canLaunchUrl(authorizationUrl)) {
    await launchUrl(authorizationUrl);
  }

  // ------- 8< -------

  // final linksStream = getLinksStream().listen((Uri uri) async {
  //   if (uri.toString().startsWith(redirectUrl.toString())) {
  //     responseUrl = uri;
  //   }
  // });
  final link = linkStream; //TODO: implement link steam.

  // Once the user is redirected to `redirectUrl`, pass the query parameters to
  // the AuthorizationCodeGrant. It will validate them and extract the
  // authorization code to create a new Client.
  return await grant.handleAuthorizationResponse(responseUrl.queryParameters);
}

void main() async {
  var client = await createClient();

  // Once you have a Client, you can use it just like any other HTTP client.
  print(await client
      .read(Uri.parse('http://example.com/protected-resources.txt')));

  // Once we're done with the client, save the credentials file. This ensures
  // that if the credentials were automatically refreshed while using the
  // client, the new credentials are available for the next run of the
  // program.
  await credentialsFile.writeAsString(client.credentials.toJson());
}
