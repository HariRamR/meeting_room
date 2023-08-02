import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeting_room/blocs/room_detail/room_detail_bloc.dart';
import 'package:meeting_room/models/room_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../res/constants.dart';

class RoomDetailScreen extends StatelessWidget {
  final RoomModel roomModel;
  final WebSocketChannel channel;
  final Stream broadcastStream;

  const RoomDetailScreen(this.roomModel, this.channel, this.broadcastStream,
      {super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight50 = MediaQuery.of(context).size.height * 50 / 100;
    var screenHeight20 = MediaQuery.of(context).size.height * 20 / 100;
    var roomModel = this.roomModel;

    var bloc = BlocProvider.of<RoomDetailBloc>(context);
    bloc.add(InitialEvent(broadcastStream));

    return Scaffold(
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.only(
            left: Constants.d16,
            right: Constants.d16,
            bottom: Constants.d16,
          ),
          child: BlocBuilder<RoomDetailBloc, RoomDetailState>(
            builder: (context, state) {
              if (state is RoomUpdated) {
                if (roomModel.id == state.room.id) {
                  roomModel = state.room;
                  const SnackBar(
                    content: Text('Room booked!!'),
                    duration: Duration(milliseconds: 3000),
                  );
                }
              }
              return ElevatedButton(
                onPressed: () {
                  if (roomModel.bookingStatus == 0) {
                    // not booked yet
                    DateTime startTime = DateTime.now().toUtc();
                    DateTime endTime =
                        DateTime.now().add(const Duration(minutes: 30)).toUtc();
                    RoomModel updatedRoom = RoomModel(
                        id: roomModel.id,
                        roomName: roomModel.roomName,
                        roomDescription: roomModel.roomDescription,
                        bookingStatus: 1, // not necessary
                        photo: roomModel.photo,
                        time: "$startTime - $endTime");
                    var data =
                        "{\"event\": \"bookRoom\", \"payload\":${jsonEncode(updatedRoom)}}";
                    channel.sink.add(data);
                  } else {
                    const SnackBar(
                      content:
                          Text('Room booked, please try booking other rooms'),
                      duration: Duration(milliseconds: 3000),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, Constants.d50),
                    backgroundColor: roomModel.bookingStatus == 0
                        ? Constants.goldenClr
                        : Constants.secondaryTextClr,
                    textStyle: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
                child: const Text(
                  Constants.bookNow,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Constants.d16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            },
          ),
        ),
      ],
      backgroundColor: Theme.of(context).primaryColorDark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight50,
              child: Stack(
                children: [
                  Hero(
                    tag: roomModel.id!,
                    child: CachedNetworkImage(
                      height: screenHeight50,
                      imageUrl: "${roomModel.photo}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: screenHeight20 / 2,
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0),
                            Theme.of(context).primaryColorDark.withOpacity(0.8),
                            Theme.of(context).primaryColorDark,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Constants.d16),
                        child: Text(
                          roomModel.roomName ?? Constants.empty,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: Constants.d30,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: Constants.d30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.angleLeft,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const FaIcon(
                              FontAwesomeIcons.share,
                              color: Colors.white,
                              size: Constants.d20,
                            ),
                          )
                        ]),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: Constants.d20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Constants.d16),
              child: BlocBuilder<RoomDetailBloc, RoomDetailState>(
                builder: (context, state) {
                  if (state is RoomUpdated) {
                    if (roomModel.id == state.room.id) {
                      roomModel = state.room;
                    }
                  }
                  return createRoomDetails(roomModel);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createRoomDetails(RoomModel roomModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        roomModel.time != null && roomModel.time!.isNotEmpty
            ? Text(
                "${Constants.busyUntil} ${roomModel.time}",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: Constants.d16),
              )
            : const SizedBox(),
        SizedBox(
            height: roomModel.time != null && roomModel.time!.isNotEmpty
                ? Constants.d20
                : Constants.d0),
        Text(
          roomModel.roomDescription ?? "",
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: Constants.d16),
        ),
        const SizedBox(height: Constants.d10),
      ],
    );
  }
}
