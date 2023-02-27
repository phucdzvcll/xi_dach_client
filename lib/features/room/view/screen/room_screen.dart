import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
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
            if (state is RenderActionButtonState &&
                actionButtonState != ActionButtonState.disable) ...[
              Visibility(
                visible:
                    isAdmin && actionButtonState == ActionButtonState.canStart,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _renderAdminButton(state, bloc),
                ),
              ),
              Visibility(
                visible: ActionButtonState.pull == actionButtonState,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TapDebouncer(
                      cooldown: const Duration(milliseconds: 300),
                      onTap: () async {
                        bloc.add(PullCardEvent());
                      },
                      builder: (context, onTap) {
                        return ElevatedButton(
                          onPressed: onTap,
                          child: Text(_actionButtonTitle(actionButtonState)),
                        );
                      }),
                ),
              ),
              Visibility(
                visible: !isAdmin &&
                    (ActionButtonState.ready == actionButtonState ||
                        ActionButtonState.unReady == actionButtonState),
                child: _renderReadyButton(actionButtonState, bloc),
              ),
              Visibility(
                visible: actionButtonState == ActionButtonState.pull,
                child: TapDebouncer(
                    cooldown: const Duration(milliseconds: 300),
                    onTap: () async {
                      bloc.add(NextTurnEvent());
                    },
                    builder: (context, onTap) {
                      return ElevatedButton(
                        onPressed: onTap,
                        child: Text(
                          isAdmin ? "Check All" : "Next Turn",
                        ),
                      );
                    }),
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

  Padding _renderReadyButton(
      ActionButtonState actionButtonState, RoomBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TapDebouncer(
        onTap: () async {
          if (ActionButtonState.unReady == actionButtonState) {
            bloc.add(ReadyEvent());
          } else {
            bloc.add(CancelReadyEvent());
          }
        },
        builder: (context, onTap) {
          return ElevatedButton(
            onPressed: onTap,
            child: Text(
              _actionButtonTitle(actionButtonState),
            ),
          );
        },
        cooldown: const Duration(milliseconds: 300),
      ),
    );
  }

  Widget _renderPetButton(BuildContext ctx, RoomBloc bloc) {
    return TapDebouncer(
        cooldown: const Duration(milliseconds: 300),
        onTap: () async {
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
        builder: (context, onTap) {
          return ElevatedButton(
            onPressed: onTap,
            child: const Text("Pet"),
          );
        });
  }

  Widget _renderAdminButton(
    RenderActionButtonState state,
    RoomBloc bloc,
  ) {
    return TapDebouncer(
      onTap: () async {
        bloc.add(StartGameEvent());
      },
      cooldown: const Duration(milliseconds: 300),
      builder: (ctx, onTap) {
        return ElevatedButton(
          onPressed: onTap,
          child: Text(_actionButtonTitle(state.buttonState, isAdmin: true)),
        );
      },
    );
  }

  String _actionButtonTitle(
    ActionButtonState actionButtonState, {
    bool isAdmin = false,
  }) {
    switch (actionButtonState) {
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
