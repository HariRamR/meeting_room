
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeting_room/blocs/home/home_bloc.dart' as home_bloc;
import 'package:meeting_room/models/room_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../res/constants.dart';
import '../utils/common_widgets.dart';
import 'room_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  List<RoomModel> rooms = [];
  TextEditingController searchController = TextEditingController();
  late WebSocketChannel channel;
  late Stream broadcastStream;
  late double screenHeight25;
  late double screenWidth;
  late double screenWidth35;
  late double newReleaseCardHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight25 = MediaQuery.of(context).size.height * 25 / 100;
    screenWidth = MediaQuery.of(context).size.width;
    screenWidth35 = screenWidth * 40 / 100;
    newReleaseCardHeight = screenWidth35 * 1.5;

    return BlocProvider(
      create: (context) =>
          home_bloc.HomeBloc()..add(home_bloc.InitEvent()),
      child: BlocBuilder<home_bloc.HomeBloc, home_bloc.HomeState>(
        builder: (context, state) {
          if (state is home_bloc.ConnectionState) {
            rooms = state.rooms;
            channel = state.channel;
            broadcastStream = state.broadcastStream;
            return createHomeContent(context);
          } else if (state is home_bloc.RoomUpdated) {
            if (rooms.isNotEmpty) {
              for (int i = 0; i < rooms.length; i++) {
                if (state.room.id == rooms[i].id) {
                  rooms.removeAt(i);
                  rooms.insert(i, state.room);
                }
              }
            }
            return createHomeContent(context);
          } else {
            return progressBar(context);
          }
        },
      ),
    );
  }

  Widget createHomeContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(Constants.d16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: Constants.d16,
                        right: Constants.d16,
                      ),
                      height: Constants.d50,
                      decoration: const BoxDecoration(
                        color: Constants.primaryClr,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            Constants.d30,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: searchController,
                        cursorColor: Colors.white,
                        onChanged: (input) {
                          // filter movie list from here
                        },
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: Constants.d16,
                        ),
                        decoration: const InputDecoration(
                          hintText: Constants.searchHint,
                          hintStyle: TextStyle(
                            color: Constants.bottomNavIconClr,
                            fontSize: Constants.d16,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.magnifyingGlass,
                              color: Constants.bottomNavIconClr,
                              size: Constants.d16,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: Constants.d16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: Constants.d20,
                  ),
                  InkWell(
                    onTap: () {},
                    child: const FaIcon(
                      FontAwesomeIcons.bell,
                      size: Constants.d20,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const SizedBox(height: Constants.d30),
              const Text(
                Constants.findRoom,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Constants.d30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: Constants.d30),
              rooms.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          Constants.youHaveBooked,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Constants.d18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          Constants.seeAll,
                          style: TextStyle(
                            color: Constants.selectedColor,
                            fontSize: Constants.d14,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              rooms.isNotEmpty
                  ? SizedBox(
                      height: newReleaseCardHeight,
                      child: ListView.separated(
                        padding: const EdgeInsets.only(top: Constants.d16),
                        separatorBuilder: (context, pos) => const SizedBox(
                          width: Constants.d15,
                        ),
                        itemCount: rooms.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RoomDetailScreen(
                                  rooms[index],
                                  channel,
                                  broadcastStream
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Constants.d10),
                            child: SizedBox(
                              width: screenWidth35,
                              height: newReleaseCardHeight,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Hero(
                                    tag: rooms[index].id!,
                                    child: CachedNetworkImage(
                                      imageUrl: rooms[index].photo ?? Constants.empty,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      width: screenWidth35,
                                      padding:
                                          const EdgeInsets.all(Constants.d16),
                                      alignment: Alignment.bottomCenter,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        gradient: LinearGradient(
                                          begin: FractionalOffset.topCenter,
                                          end: FractionalOffset.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.0),
                                            Colors.black,
                                            Colors.black,
                                          ],
                                          stops: const [0.0, 0.8, 1.0],
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rooms[index].roomName ??
                                                Constants.empty,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: Constants.d14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: Constants.d10,
                                          ),
                                          Text(
                                            rooms[index].time ??
                                                Constants.empty,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: Constants.d14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: Constants.d30),
              rooms.isNotEmpty
                  ? const Text(
                      Constants.availableRooms,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Constants.d18,
                          fontWeight: FontWeight.w700),
                    )
                  : const SizedBox(),
              ListView.separated(
                padding: const EdgeInsets.only(top: Constants.d16),
                separatorBuilder: (context, pos) => const SizedBox(
                  height: Constants.d15,
                ),
                itemCount: rooms.length,
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RoomDetailScreen(
                          rooms[index],
                          channel,
                          broadcastStream
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Constants.d10),
                    child: SizedBox(
                      height: screenHeight25,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            rooms[index].photo ?? Constants.empty,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            width: screenWidth,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(Constants.d16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                gradient: LinearGradient(
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.0),
                                    Colors.black,
                                    Colors.black,
                                  ],
                                  stops: const [0.0, 0.8, 1.0],
                                ),
                              ),
                              child: Text(
                                rooms[index].roomName ?? Constants.empty,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: Constants.d16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
