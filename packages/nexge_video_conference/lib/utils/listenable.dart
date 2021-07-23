import 'package:eventify/eventify.dart';

class Listenable {
  EventEmitter? eventEmitter;

  Listenable() {
    this.eventEmitter = new EventEmitter();
  }

  Listenable.named(EventEmitter? eventEmitter) {
    this.eventEmitter = eventEmitter;
  }

  setEventEmitter(EventEmitter eventEmitter) {
    this.eventEmitter = eventEmitter;
  }

  // Listenable.withEventEmitter(EventEmitter eventEmitter) {
  //   this.eventEmitter = eventEmitter;
  // }

  on(eventName, listener) {
    return this.eventEmitter?.on(eventName, this, listener);
  }

  off(eventName, listener) {
    this.eventEmitter?.removeListener(eventName, listener);
  }

  emit(eventName, data) {
    this.eventEmitter?.emit(eventName, null, data);
  }
}
