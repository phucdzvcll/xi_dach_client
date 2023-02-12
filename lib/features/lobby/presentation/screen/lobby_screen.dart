import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:xi_zack_client/common/base/extensions/extensions.dart';
import 'package:xi_zack_client/features/lobby/domain/entities/room.dart';
import 'package:xi_zack_client/features/lobby/presentation/bloc/lobby_bloc.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({Key? key}) : super(key: key);

  static const String routePath = "/lobby";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LobbyBloc>(
      create: (context) => inject()..add(InitEvent()),
      child: Builder(
        builder: (blocContext) {
          final LobbyBloc bloc = BlocProvider.of<LobbyBloc>(blocContext);
          return BlocListener<LobbyBloc, LobbyState>(
            listener: (context, state) {
              if (state is ConnectingToSocket) {
                EasyLoading.show(
                    maskType: EasyLoadingMaskType.black,
                    dismissOnTap: false,
                    status: "Waiting to connect....");
              } else if (state is LobbyErrorState) {
                EasyLoading.showError(
                  state.mess,
                  duration: const Duration(
                    seconds: 10,
                  ),
                  dismissOnTap: true,
                );
              } else if (state is CreatingRoomState) {
                EasyLoading.show(
                    maskType: EasyLoadingMaskType.black,
                    dismissOnTap: false,
                    status: "Creating Room....");
              } else {
                EasyLoading.dismiss();
              }
              if (state is ConnectingToSocketFail) {
                EasyLoading.showError("Connect Fail",
                    duration: const Duration(seconds: 3));
              } else if (state is ConnectingToSocketSuccess) {
                EasyLoading.showSuccess("Connect Success",
                    duration: const Duration(seconds: 3));
              }
            },
            child: Scaffold(
              appBar: _renderAppBar(blocContext, bloc),
              body: _renderLobby(bloc, blocContext),
            ),
          );
        },
      ),
    );
  }

  Widget _renderLobby(LobbyBloc bloc, BuildContext blocContext) {
    final width = MediaQuery.of(blocContext).size.width;
    return BlocBuilder<LobbyBloc, LobbyState>(
      buildWhen: (previous, current) => current is RenderLobbyState,
      builder: (context, state) {
        final List<Room> rooms = [];

        if (state is RenderLobbyState) {
          rooms.clear();
          rooms.addAll(state.rooms);
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          padding: const EdgeInsets.all(7.0),
          itemBuilder: (ctx, index) {
            final room = rooms[index];
            return GestureDetector(
              onTap: () {
                bloc.add(JoinToRoom(roomId: room.roomId));
              },
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.table_bar_rounded,
                        size: width / 14,
                        color: _renderColorByPlayer(room.player.length),
                      ),
                      Text(room.roomName),
                      const Spacer(),
                      Text("players: ${room.player.length.toString()}"),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: rooms.length,
        );
      },
    );
  }

  Color? _renderColorByPlayer(int playerAmount) {
    if (playerAmount <= 4) {
      return Colors.green[600];
    } else if (playerAmount <= 6) {
      return Colors.deepOrange[500];
    } else {
      return Colors.red[900];
    }
  }

  AppBar _renderAppBar(BuildContext blocContext, LobbyBloc bloc) {
    return AppBar(
      title: const Text("Lobby"),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: blocContext,
                builder: (context) {
                  return Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.table_bar),
                        title: const Text('Create Room'),
                        onTap: () async {
                          final TextEditingController controller =
                              TextEditingController();
                          final String? roomName = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Enter Room Name"),
                                content: TextField(
                                  controller: controller,
                                  decoration: const InputDecoration(
                                      hintText: "Room Name"),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(controller.text);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          if (roomName != null && roomName.isNotEmpty) {
                            bloc.add(CreateRoomEvent(roomName: roomName));
                            Navigator.of(blocContext).pop();
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: const Text('Exit Game'),
                        onTap: () {},
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.more_vert))
      ],
    );
  }
}
