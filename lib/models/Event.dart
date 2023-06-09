class Event{
    int id;
    late String slider_name, image;

    Event({required this.slider_name, required this.image, required this.id});

    factory Event.fromJson(Map<String, dynamic> json){
      return Event(
        id : json['id'], 
        slider_name : json['slider_name'], 
        image : json['path_file'],
      );
    }

    Map<String, dynamic> toMap() {
      return {
        'id': id,'slider_name': slider_name,'image' :image,
      };
    }
}