import 'dart:async';

void main() async {
  // * Three type of streaming Transform, Generator & Controller

  /**
  * * They are two types of stream single-subscription & broadcast stream
  * * When error occurs, If we are not using streamSubscription then The stream notifies the first error event and then halts further processing
  * * Ortherwise the stream notifies error event(s) but continues delivering subsequent events
  */

  usingTransformStream();
  usingStreamGenerators();
  usingStreamController();
}

void usingTransformStream() {
  final Stream<int> originalStream = Stream<int>.fromIterable([1, 2, 3, 4, 5]);
  final Stream<int> transformedStream = originalStream.map((int value) {
    return value * 2;
  });

  // * example for broadcast stream
  final StreamSubscription<int> broadcastSubscription =
      transformedStream.asBroadcastStream().listen((int value) {
    print('Transformed value: $value');
  });

  final StreamSubscription<int> subscription =
      transformedStream.listen((int value) {
    print('Transformed value: $value');
  });
}

Stream<int> countStream(max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

void usingStreamGenerators() {
  // * example for broadcast stream
  Stream<int> broadcastStream = countStream(6).asBroadcastStream();
  Stream<int> stream = countStream(6);
  stream.listen(
    (event) {},
    onError: (error) {},
  );
}

void usingStreamController() {
  // * example for broadcast stream
  final broadcastStreamController = StreamController<DateTime>.broadcast();
  final streamController = StreamController<DateTime>.broadcast();
  final afterTime = DateTime.now().add(Duration(seconds: 15));
  late StreamSubscription<DateTime> subscription;

  Timer.periodic(
    Duration(seconds: 2),
    (timer) {
      if (DateTime.now().second % 3 == 0) {
        streamController.addError(() => Exception("Divisible by 3"));
      } else {
        streamController.add(DateTime.now());
      }
    },
  );

  subscription = streamController.stream.listen(
    (event) {
      print(event);
      if (event.isAfter(afterTime)) {
        streamController.close();
      }
    },
    onError: (error) {
      print("error $error");
    },
    onDone: () {
      print("completed");
    },
  );
}
