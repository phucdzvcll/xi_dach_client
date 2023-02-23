import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                backgroundColor: Colors.green[400],
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
            Player? admin;
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

  Widget _renderReadyStateWidget(RoomBloc bloc) {
    return BlocBuilder<RoomBloc, RoomState>(
      buildWhen: (previous, current) => current is RenderActionButtonState,
      builder: (ctx, state) {
        bool isAdmin = false;
        ActionButtonState actionButtonState = ActionButtonState.disable;
        if (state is RenderActionButtonState) {
          isAdmin = state.isAdmin;
          actionButtonState = state.buttonState;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state is RenderActionButtonState) ...[
              Visibility(
                visible: isAdmin,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _renderAdminButton(state, bloc),
                ),
              ),
              Visibility(
                visible: !isAdmin &&
                    (ActionButtonState.ready == actionButtonState ||
                        ActionButtonState.unReady == actionButtonState),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (ActionButtonState.unReady == actionButtonState) {
                        bloc.add(ReadyEvent());
                      } else {
                        bloc.add(CancelReadyEvent());
                      }
                    },
                    child: Text(
                      _actionButtonTitle(actionButtonState),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible:
                    !isAdmin && actionButtonState == ActionButtonState.unReady,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _renderPetButton(ctx, bloc),
                ),
              ),
            ] else ...[
              const SizedBox.shrink(),
            ],
          ],
        );
      },
    );
  }

  ElevatedButton _renderPetButton(BuildContext ctx, RoomBloc bloc) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
            context: ctx,
            builder: (ctx) {
              TextEditingController controller = TextEditingController();
              return _renderPetDialog(controller, ctx);
            }).then((value) {
          if (value is int) {
            bloc.add(PetEvent(pet: value));
          }
        });
      },
      child: Text("Pet"),
    );
  }

  Widget _renderAdminButton(
    RenderActionButtonState state,
    RoomBloc bloc,
  ) {
    return ElevatedButton(
      onPressed: state.buttonState == ActionButtonState.canStart
          ? () {
              bloc.add(StartGameEvent());
            }
          : null,
      child: Text(_actionButtonTitle(state.buttonState, isAdmin: true)),
    );
  }

  String _actionButtonTitle(
    ActionButtonState state, {
    bool isAdmin = false,
  }) {
    switch (state) {
      case ActionButtonState.ready:
        return "Cancel";
      case ActionButtonState.unReady:
        return isAdmin ? "Start" : "Ready";
      case ActionButtonState.canStart:
        return "Start";
      case ActionButtonState.disable:
        return "";
      case ActionButtonState.pull:
        return "Pull";
      case ActionButtonState.showCard:
        return "Show Card";
      case ActionButtonState.checkCard:
        return "Check Card";
    }
  }

  AlertDialog _renderPetDialog(
      TextEditingController controller, BuildContext context) {
    return AlertDialog(
      title: const Text("Enter The Pet Number"),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: const InputDecoration(hintText: "Pet"),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text("OK"),
          onPressed: () {
            int number = int.tryParse(controller.text) ?? 0;
            Navigator.of(context).pop(number <= 0 ? null : number);
          },
        ),
      ],
    );
  }

  BlocBuilder<RoomBloc, RoomState> _renderAllChild() {
    return BlocBuilder<RoomBloc, RoomState>(
      buildWhen: (previous, current) => current is RenderAllChildPlayerState,
      builder: (context, state) {
        final List<Player> players = [];
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
                  final player = players.firstWhereOrNull(
                      (element) => (element.index - 1) == index);

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
