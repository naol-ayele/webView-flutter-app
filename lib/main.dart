import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late WebViewController _controller;
  double webProgress = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Webview',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('online courses'),
          centerTitle: true,
          actions: [
            Row(
              children: [
                IconButton(
                    onPressed: () async {
                      if (await _controller.canGoBack()) {
                        _controller.goBack();
                      }
                    },
                    icon: const Icon(Icons.arrow_back)),
              ],
            ),
            IconButton(
                onPressed: () => _controller.reload(),
                icon: const Icon(Icons.refresh)),
            IconButton(
                onPressed: () async {
                  if (await _controller.canGoForward()) {
                    _controller.goForward();
                  }
                },
                icon: const Icon(Icons.arrow_forward)),
          ],
        ),
        body: Center(
          child: SafeArea(
            child: Column(
              children: [
                createWebView("https://www.udemy.com/"), // First URL
                Center(
                  child: Text('$screenWidth,$screenHeight'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createWebView(String url) {
    return Expanded(
      child: WebView(
        initialUrl: "https://www.udemy.com/",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;
        },
        onProgress: (int progress) {
          setState(() {
            webProgress = progress / 100;
          });
        },
        onWebResourceError: (WebResourceError error) {
          try {
            if (error.description.contains("Failed to connect")) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No internet connection!'),
                  backgroundColor: Colors.white,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to load page: ${error.description}'),
                  backgroundColor: Colors.white70,
                ),
              );
            }
          } catch (e) {
            ("error 404: $e");
          }
        },
      ),
    );
  }
}
