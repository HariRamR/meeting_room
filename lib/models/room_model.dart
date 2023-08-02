
class RoomModel {
  int? id;
  String? roomName;
  String? roomDescription;
  int? bookingStatus;
  String? photo;
  String? time;

  RoomModel(
      {this.id,
        this.roomName,
        this.roomDescription,
        this.bookingStatus,
        this.photo,
        this.time
      });

  RoomModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomName = json['room_name'];
    roomDescription = json['room_description'];
    bookingStatus = json['booking_status'];
    photo = json['photo'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['room_name'] = roomName;
    data['room_description'] = roomDescription;
    data['booking_status'] = bookingStatus;
    data['photo'] = photo;
    data['time'] = time;
    return data;
  }
}