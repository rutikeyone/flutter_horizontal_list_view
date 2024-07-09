import 'package:flutter/material.dart';
import 'package:horizontal_list_view/horizontal_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Horizontal List View Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HorizontalListViewController _controller = HorizontalListViewController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HorizontalListView.builder(
                itemWidth: 400,
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                controller: _controller,
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return AspectRatio(
                    aspectRatio: 2 / 3,
                    child: Container(
                      color: Colors.orange,
                      child: Center(
                        child: Text(
                          'item: $index',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filled(
                    onPressed: () {
                      _controller.animateToPage(
                        _controller.currentPage - 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linearToEaseOut,
                      );
                    },
                    icon: const Icon(Icons.chevron_left),
                  ),
                  const SizedBox(width: 32),
                  IconButton.filled(
                    onPressed: () {
                      _controller.animateToPage(
                        _controller.currentPage + 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linearToEaseOut,
                      );
                    },
                    icon: const Icon(Icons.chevron_right),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
