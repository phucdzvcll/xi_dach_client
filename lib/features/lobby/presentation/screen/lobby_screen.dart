import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:xi_zack_client/common/base/extensions/extensions.dart';
import 'package:xi_zack_client/features/domain/entities/room.dart';
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
              body: _renderLobby(),
            ),
          );
        },
      ),
    );
  }

  Widget _renderLobby() {
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
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
          ),
          padding: const EdgeInsets.all(7.0),
          itemBuilder: (ctx, index) {
            final room = rooms[index];
            return DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(room.roomName),
                      Text(room.roomId),
                      Text(room.dateTime.toString()),
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
