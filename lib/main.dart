import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_example/waves_background.dart';

final counterProvider = StateProvider((ref) => 0);


void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child:  MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod example',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Riverpod Counter Page'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});


  final String title;


  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final int counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
      
        title: Text(title),
        
        actions: [IconButton(onPressed: (){
          ref.invalidate(counterProvider);
        }, icon: Icon(Icons.refresh))],
      ),
      backgroundColor: Colors.brown[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:  100),
                  child:  Text(
                    'Speed of the river flow:',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
              ],
            ),
            
             Expanded(child: WaveBackground(speed: counter,)),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 35),
            child: FloatingActionButton(
              onPressed: (){
                if(counter > 0) {
                  ref.read(counterProvider.notifier).state--;
                }
              },
             
              tooltip: 'Increment', 
              child: const Icon(Icons.arrow_drop_down, size: 30,),
            ),
          ),
          FloatingActionButton(
            onPressed: (){
              if(counter < 10) {
                ref.read(counterProvider.notifier).state++;
              }
            },

            tooltip: 'Increment', 
            child: const Icon(Icons.arrow_drop_up, size: 30,),
          ),
        ],
      ),
      
    );
  }
}
