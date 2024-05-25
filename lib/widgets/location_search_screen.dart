import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';
import 'package:researchproject/constans/location_constants.dart';
import 'package:researchproject/models/autocomplate_prediction.dart';
import 'package:researchproject/models/place_auto_complate_response.dart';
import 'package:researchproject/widgets/location_list_tile.dart';
import 'package:researchproject/widgets/network_utiliti.dart';
import 'package:researchproject/widgets/search_info.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({Key? key}) : super(key: key);

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {


  //location
  List<Feature> items=[];
//placeAutoComplete
  void placeAutoComplete(String val)async{
    await addressSugestion(val).then((value){
      setState(() {
      items=value;
    });
    });
  }
  Future <List<Feature>>addressSugestion(String address)async{
Response response=await Dio().get('https://photon.komoot.io/api/',queryParameters:{"q":address,"limit":5});
  final json=response.data;
  return(json['features'] as
  List).map((e)=>Feature.fromJson(e)).toList();
  }

  // Function to handle selecting a location
  void selectLocation(Feature selectedLocation) {
    Navigator.pop(context, selectedLocation); // Pass selected location data back as a result
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text(
          "Set Destination Location",
          style: TextStyle(color: textColorLightTheme
          ),
        ),

      ),
      body: Column(
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: TextFormField(
                onChanged: (val) {
                if(val!='') {
placeAutoComplete(val);
                }else{
                  items.clear();
                  setState((){

                  });
                }
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Search location",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0), // Adjust the padding as needed
                    child: SvgPicture.asset(
                      "asset/location_pin.svg",
                      color: secondaryColor40LightTheme,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200], // Change the fill color as needed
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none, // Hide the border
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Adjust the content padding as needed
                ),
              ),
            ),
          ),

          const Divider(
            height: 4,
            thickness: 4,
            color: secondaryColor5LightTheme,
          ),
          //created own component for suggestion
          ...items.map((e) => GestureDetector(
            onTap: () {
              selectLocation(e); // Pass the selected location data back
            },
            child: ListTile(
              leading: const Icon(Icons.place),
              title: Text(e.properties!.name!),
            ),
          )).toList()

        ],
      ),
    );
  }
}
