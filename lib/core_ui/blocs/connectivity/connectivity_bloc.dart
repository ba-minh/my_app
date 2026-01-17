import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- EVENTS ---
abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class ConnectivityObserve extends ConnectivityEvent {}

class ConnectivityNotify extends ConnectivityEvent {
  final bool isConnected;

  const ConnectivityNotify({required this.isConnected});

  @override
  List<Object> get props => [isConnected];
}

// --- STATES ---
abstract class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivitySuccess extends ConnectivityState {} // Có mạng

class ConnectivityFailure extends ConnectivityState {} // Mất mạng

// --- BLOC ---
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityBloc() : super(ConnectivityInitial()) {
    on<ConnectivityObserve>(_onObserve);
    on<ConnectivityNotify>(_onNotify);
  }

  void _onObserve(ConnectivityObserve event, Emitter<ConnectivityState> emit) {
    // Lắng nghe sự thay đổi của mạng
    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
       // Nếu danh sách chứa .none thì coi như mất mạng (hoặc check kỹ hơn)
       // Logic đơn giản: Nếu contains(none) và length == 1 -> Mất
       // Thực tế: connectivity_plus trả về List. Nếu có wifi/mobile thì ok.
       
       bool isConnected = !results.contains(ConnectivityResult.none);
       add(ConnectivityNotify(isConnected: isConnected));
    });
  }

  void _onNotify(ConnectivityNotify event, Emitter<ConnectivityState> emit) {
    if (event.isConnected) {
      emit(ConnectivitySuccess());
    } else {
      emit(ConnectivityFailure());
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
