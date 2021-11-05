import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditech/material/snackbar_error.dart';
import 'package:redditech/material/substring.dart';
import 'package:redditech/widgets/global_info.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:redditech/widgets/request.dart';
import 'package:redditech/model/auth_info.dart' as ai;

class Authwebview extends StatelessWidget {
  final authCodeUrl = "https://www.reddit.com/api/v1/authorize?"
      "client_id=${ai.clientId}"
      "&response_type=${ai.responseType}"
      "&state=${ai.state}"
      "&redirect_uri=${ai.redirectUri}"
      "&duration=${ai.duration}"
      "&scope=${ai.scope}";
  final String userAgent =
      'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) '
      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';
  final Completer<WebViewController> controller =
      Completer<WebViewController>();

  Authwebview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: authCodeUrl,
            userAgent: userAgent,
            onWebViewCreated: (WebViewController webViewController) {
              controller.complete(webViewController);
            },
            onPageStarted: (String newUrl) => {
                  if (authCodeUrl == newUrl)
                    {context.read<GlobalProvider>().code = ""}
                  else
                    {
                      context.read<GlobalProvider>().code =
                          getSubStringBetween(newUrl, "code=", "#_"),
                      NewApiServices()
                          .getAccessToken(context.read<GlobalProvider>().code)
                          .then((newToken) {
                        context.read<GlobalProvider>().token = newToken;
                        context.read<GlobalProvider>().setLogged(true);
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }).catchError((onError) {
                        showSnackBarError(context, onError);
                      }),
                      Navigator.pushNamed(context, '/loading'),
                    }
                }));
  }
}
