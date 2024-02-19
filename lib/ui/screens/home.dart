import 'package:bondy/providers/theme.dart';
import 'package:bondy/providers/weather_provider.dart';
import 'package:bondy/styles.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider('34892dee8e50ad1f088d6d9a6271c58b&'),
      child: Consumer<AppTheme>(
        builder: (context, appTheme, child) => MaterialApp(
          theme:
              appTheme.themeData, // Usa el tema proporcionado por el Provider
          home: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 255, 225, 126),
              title: const Text(
                'B o n d y',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              centerTitle: true,
            ),
            body: const WeatherApp(),
          ),
        ),
      ),
    );
  }
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        SizedBox(
          width: 1500,
          height: 400,
          child: FlutterLocationPicker(
            initZoom: 11,
            minZoomLevel: 5,
            maxZoomLevel: 16,
            trackMyPosition: true,
            searchBarBackgroundColor: Colors.white,
            selectLocationButtonText: 'Save location',
            //mapLanguage: 'en',
            onPicked: (pickedData) async {
              provider.saveLat(pickedData.latLong.latitude.toString());
              provider.saveLon(pickedData.latLong.longitude.toString());
            },
          ),
        ),
        const SizedBox(height: 15),
        _buttons(provider),
        const Divider(
          height: 20.0,
          thickness: 2.0,
        ),
        Expanded(child: _resultView(provider)),
      ],
    );
  }

  Widget _resultView(WeatherProvider provider) {
    if (provider.appState == AppState.FINISHED_DOWNLOADING) {
      return contentFinishedDownload(provider);
    } else if (provider.appState == AppState.DOWNLOADING) {
      return contentDownloading();
    } else {
      return contentNotDownloaded();
    }
  }

  Widget contentFinishedDownload(WeatherProvider provider) {
    return Center(
      child: ListView.separated(
        itemCount: provider.weatherData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(provider.weatherData[index].weatherInfo),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }

  Widget contentDownloading() {
    return Container(
      margin: const EdgeInsets.all(25),
      child: Column(children: [
        const Text(
          'Fetching weather...',
          style: AppStyles.bodyBlack,
        ),
        Container(
          margin: const EdgeInsets.only(top: 50),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 3)),
        ),
      ]),
    );
  }

  Widget contentNotDownloaded() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Select a location on the map to view the weather forecast',
            style: AppStyles.bodyGrey,
          ),
        ],
      ),
    );
  }

  Widget _buttons(WeatherProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(5),
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                provider.queryWeather(provider.lat!, provider.lon!);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 247, 192, 66)),
              ),
              child: const Text(
                'Fetch weather',
                style: AppStyles.bodyBlack,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(5),
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                provider.queryForecast(provider.lat!, provider.lon!);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 247, 192, 66)),
              ),
              child: const Text(
                'Fetch forecast',
                style: AppStyles.bodyBlack,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
