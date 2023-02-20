import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:xi_zack_client/common/base/extensions/extensions.dart';
import 'package:xi_zack_client/features/room/models/room_player.dart';
import 'package:xi_zack_client/features/room/view/widget/guess/guess_widget.dart';
import 'package:xi_zack_client/features/room/view/widget/player/player_widget.dart';
import 'package:collection/collection.dart';
import '../../bloc/room_bloc.dart';
import '../../bloc/room_event.dart';
import '../../bloc/room_state.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  final String roomId;
  final String roomName;
  static const routePath = "/room";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RoomBloc>(
      create: (context) => inject()..add(InitEvent(roomId: roomId)),
      child: Builder(
        builder: (context) {
          var bloc = BlocProvider.of<RoomBloc>(context);
          return WillPopScope(
            onWillPop: () async {
              bloc.add(LeaveRoomEvent());
              return false;
            },
            child: BlocListener<RoomBloc, RoomState>(
              listener: (context, state) {
                if (state is InitEvent || state is LoadingState) {
                  EasyLoading.show(
                    dismissOnTap: false,
                    maskType: EasyLoadingMaskType.black,
                  );
                } else {
                  EasyLoading.dismiss();
                }

                if (state is ErrorRoomState) {
                  EasyLoading.showError(
                    state.errMess,
                    maskType: EasyLoadingMaskType.black,
                    duration: const Duration(seconds: 3),
                  );
                } else if (state is LeaveRoomSuccess) {
                  Navigator.pop(context);
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    roomName,
                  ),
                ),
                body: _renderBody(bloc),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _renderBody(RoomBloc bloc) {
    return Column(
      children: [
        BlocBuilder<RoomBloc, RoomState>(
          buildWhen: (previous, current) => current is RenderAdminState,
          builder: (context, state) {
            RoomPlayer? admin;
            if (state is RenderAdminState) {
              admin = state.admin;
            }

            if (admin != null) {
              return admin.isMySelf
                  ? PlayerWidget(player: admin)
                  : GuessWidget(
                      guess: admin,
                    );
            } else {
              return Center(
                child: IconButton(
                  icon: const Icon(CupertinoIcons.plus_app),
                  onPressed: () {
                    bloc.add(ChangeAdminEvent());
                  },
                ),
              );
            }
          },
        ),
        Expanded(
          child: _renderAllChild(),
        ),
        _renderReadyStateWidget(bloc)
      ],
    );
  }

  Padding _renderReadyStateWidget(RoomBloc bloc) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: BlocBuilder<RoomBloc, RoomState>(
        buildWhen: (previous, current) => current is RenderReadyButtonState,
        builder: (context, state) {
          bool isReady = false;
          bool isAdmin = false;
          if (state is RenderReadyButtonState) {
            isReady = state.isReady;
            isAdmin = state.isAdmin;
          }
          return ElevatedButton(
            onPressed: (isAdmin && !isReady)
                ? null
                : () {
                    bloc.add(isReady
                        ? isAdmin
                            ? StartGameEvent()
                            : CancelReadyEvent()
                        : ReadyEvent());
                  },
            child: isAdmin
                ? const Text("Start")
                : Text(!isReady ? "Ready" : "Cancel"),
          );
        },
      ),
    );
  }

  BlocBuilder<RoomBloc, RoomState> _renderAllChild() {
    return BlocBuilder<RoomBloc, RoomState>(
      buildWhen: (previous, current) => current is RenderAllChildPlayerState,
      builder: (context, state) {
        final List<RoomPlayer> players = [];
        if (state is RenderAllChildPlayerState) {
          players.clear();
          players.addAll(state.players);
        }
        return players.isNotEmpty
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final player = players
                      .firstWhereOrNull((element) => (element.index - 1) == index);

                  if (player != null) {
                    if (player.isMySelf) {
                      return PlayerWidget(
                        player: player,
                      );
                    } else {
                      return GuessWidget(
                        guess: player,
                      );
                    }
                  } else {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: const SizedBox(),
                    );
                  }
                },
                itemCount: 8,
              )
            : const Center(
                child: Text("Empty"),
              );
      },
    );
  }
}

class RoomArgument {
  final String roomId;
  final String roomName;

  const RoomArgument({
    required this.roomId,
    required this.roomName,
  });
}
