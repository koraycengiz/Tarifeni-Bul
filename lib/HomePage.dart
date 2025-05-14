import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'TariffProvider.dart';
import 'FavoritesPage.dart';
import 'ProfilePage.dart';
import 'AIPredictor.dart';
import 'UserDataProvider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    FavoritesPage(),
    HomeScreenContent(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Container(
          height: 80,
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.favorite, 'Favorites', 0),
              _buildNavItem(Icons.home, 'Home', 1),
              _buildNavItem(Icons.person, 'Profile', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: isSelected
          ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Color(0xFF207648),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      )
          : Icon(icon, color: Colors.grey),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  String _searchQuery = '';
  late AIPredictor predictor;
  bool predictorReady = false;
  List<Tariff> _filteredTariffs = [];
  final TextEditingController predictedGbController = TextEditingController();
  bool globalTurkcell = false;
  bool globalVodafone = false;
  bool globalTurkTelekom = false;
  String _selectedSortOption = 'Default';


  @override
  void initState() {
    super.initState();
    print("init state çalıştı");
    AIPredictor.load().then((loadedPredictor) {
      setState(() {
        print("init statenin içindeki load() çalıştı.");
        predictor = loadedPredictor;
        predictorReady = true;
        print("init statenin içindeki load()'ın sonu çalıştı.");
        print(predictorReady);
        print(predictor);
      });
    });
  }

  void filterTariffs() {
    final tariffProvider = Provider.of<TariffProvider>(context, listen: false);
    final userData = Provider.of<UserDataProvider>(context, listen: false);
    final allTariffs = tariffProvider.tariffs;
    String selectedOperator = Provider.of<UserDataProvider>(context, listen: false).selectedOperator;

    globalTurkcell = userData.globalTurkcell;
    print("Global Turkcell: ${userData.globalTurkcell}");
    globalVodafone = userData.globalVodafone;
    print("Global Vodafone: ${userData.globalVodafone}");
    print("Normal Turk Telekom: ${globalTurkTelekom}");
    globalTurkTelekom = userData.globalTurkTelekom;
    print("Global Turk Telekom: ${userData.globalTurkTelekom}");

    setState(() {
      _filteredTariffs = allTariffs.where((tariff) {
        bool matchesSearch = (tariff.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            tariff.gb.toString().contains(_searchQuery.toLowerCase()) ||
            tariff.minutes.toLowerCase().contains(_searchQuery.toLowerCase())||
            tariff.price.toString().contains(_searchQuery.toLowerCase())||
            tariff.specification.toLowerCase().contains(_searchQuery.toLowerCase()));

        bool isNotNewUserTariff = tariff.specification.toLowerCase() != "${selectedOperator.toLowerCase()}_new_user";
        bool operatorFilterActive = globalTurkcell || globalVodafone || globalTurkTelekom;
        bool matchesOperator = !operatorFilterActive || (
            (globalTurkcell && tariff.specification.toLowerCase() == "turkcell") ||
            (globalVodafone && tariff.specification.toLowerCase() == "vodafone") ||
            (globalTurkTelekom && tariff.specification.toLowerCase() == "türk telekom")
        );
        return matchesSearch && isNotNewUserTariff && matchesOperator;
      }).toList();

      // Apply sort based on selected option
      if (_selectedSortOption == 'Price ↑') {
        _filteredTariffs.sort((a, b) => a.price.compareTo(b.price));
      } else if (_selectedSortOption == 'Price ↓') {
        _filteredTariffs.sort((a, b) => b.price.compareTo(a.price));
      }
      // Default means no sorting (original insertion order)
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tariffProvider = Provider.of<TariffProvider>(context);
    if (tariffProvider.tariffs.isNotEmpty && _filteredTariffs.isEmpty) {
      filterTariffs();
    }
  }

  void _showOperatorFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Filter"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: Text("Turkcell"),
                    value: globalTurkcell,
                    onChanged: (bool? value) {
                      setState(() {
                        globalTurkcell = value!;
                        final userData = Provider.of<UserDataProvider>(context, listen: false);
                        userData.setGlobalTurkcell(value);
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text("Vodafone"),
                    value: globalVodafone,
                    onChanged: (bool? value) {
                      setState(() {
                        globalVodafone = value!;
                        final userData = Provider.of<UserDataProvider>(context, listen: false);
                        userData.setGlobalVodafone(value);
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text("Türk Telekom"),
                    value: globalTurkTelekom,
                    onChanged: (bool? value) {
                      setState(() {
                        globalTurkTelekom = value!;
                        final userData = Provider.of<UserDataProvider>(context, listen: false);
                        userData.setGlobalTurkTelekom(value);
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text("Apply"),
                  onPressed: () {
                    print("Turkcell: ${globalTurkcell}");
                    print("Vodafone: ${globalVodafone}");
                    print("Türk Telekom: ${globalTurkTelekom}");
                    filterTariffs();
                    Navigator.of(context).pop([
                      if (globalTurkcell) 'Turkcell',
                      if (globalVodafone) 'Vodafone',
                      if (globalTurkTelekom) 'Türk Telekom',
                    ]);
                  },
                ),
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      },
    ).then((selectedOperators) {
      if (selectedOperators != null && selectedOperators is List<String>) {
        // Use selectedOperators to filter your list
        print("Selected: $selectedOperators");
        // TODO: implement your filtering logic
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tariffProvider = Provider.of<TariffProvider>(context);
    final userDataProvider = Provider.of<UserDataProvider>(context);

    return Scaffold(
      /*
      appBar: AppBar(
        title: Center(child: Text('TARİFENİ BUL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        backgroundColor: Color(0xFFE6AF2E),
      ),

       */
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            //colors: [Colors.white, Color(0xFF76689A)]
            //colors: [Colors.white, Color(0xFFFFD6D6)],
            colors: [Colors.white, Color(0xFFFFEEDD)]
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8), // adjust for corner roundness
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.indigo[100],
                            child: Image.asset(
                              'assets/tarifenibul_logo.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8), // adjust for corner roundness
                          child: Container(
                            width: 160,
                            height: 60,
                            color: Colors.indigo[100],
                            child: Image.asset(
                              'assets/tarifenibul_text.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        /*
                        Text('TARİFENİ BUL',style: GoogleFonts.poppins(textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                        )),),

                         */
                      ],
                    )),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  filterTariffs();
                },
                decoration: InputDecoration(
                  hintText: 'Search for a tariff...',
                  prefixIcon: Icon(Icons.search, color: Color(0xFF207648)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: () async {
                        print("suggest for me buttonu başlangıcı çalıştı");
                        if (!predictorReady) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("predictor ready = false")),
                          );
                          return;
                        }

                        List<double> last5Months = userDataProvider.monthlyData; // Example data
                        if (last5Months.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("last5Months boş")),
                          );
                          return;
                        }
                        print("Last 5 months data: $last5Months");
                        double predictedGB = await predictor.predict(last5Months);
                        predictedGbController.text = predictedGB.toStringAsFixed(1);

                        setState(() {
                          _filteredTariffs.sort((a, b) {
                            double diffA = (a.gb.toDouble() - predictedGB).abs();
                            double diffB = (b.gb.toDouble() - predictedGB).abs();
                            return diffA.compareTo(diffB);
                          });
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Predicted usage: ${predictedGB.toStringAsFixed(1)} GB",
                            style: GoogleFonts.poppins(textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                          )),)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF207648),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("Suggest for me",style: GoogleFonts.poppins(textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                      )),),
                    ),
                  ),
                  SizedBox(width: 23),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        TextField(
                          controller: predictedGbController,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: '...',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showOperatorFilterDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF207648),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("Filter",style: GoogleFonts.poppins(textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                      )),),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedSortOption,
                      icon: Icon(Icons.arrow_drop_down),
                      iconEnabledColor: Colors.black,
                      style: GoogleFonts.poppins(textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF207648)
                      )), // text color
                      dropdownColor: Colors.white, // background of the dropdown menu
                      underline: Container(
                        height: 2,
                        color: Color(0xFF207648),
                      ),
                      items: <String>['Default', 'Price ↑', 'Price ↓'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSortOption = newValue!;
                        });
                        filterTariffs(); // Reapply filtering with new sort
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: _filteredTariffs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9, // Makes cards square
                  ),
                  itemBuilder: (context, index) {
                    final tariff = _filteredTariffs[index];
                    final isFav = tariffProvider.isFavorite(tariff);

                    // Determine the logo based on specification
                    String logoAssetPath = '';
                    if (tariff.specification == 'Turkcell' || tariff.specification == 'Turkcell_new_user') {
                      logoAssetPath = 'assets/turkcell.png'; // Path to Turkcell logo
                    } else if (tariff.specification == 'Vodafone') {
                      logoAssetPath = 'assets/vodafone.png'; // Path to Vodafone logo
                    } else if (tariff.specification == 'Türk Telekom') {
                      logoAssetPath = 'assets/turktelekom.png'; // Path to Türk Telekom logo
                    }

                    return Card(
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tariff.name,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF207648)
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '${tariff.gb} GB | ${tariff.minutes}',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87
                                    ),
                                  ),
                                ),
                                tariff.hasSpecialPricing
                                    ? Column(
                                  children: [
                                    Text(
                                      'İlk ${tariff.firstMonthsCount} ay',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[700]
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${tariff.specialPriceFirstMonths} TL/AY',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green[700]
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Sonraki ${tariff.remainingMonthsCount} ay ${tariff.specialPriceRemainingMonths} TL/AY',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[700]
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                    : Text(
                                  '${tariff.price} TL',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green[700]
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: isFav ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () => tariffProvider.toggleFavorite(tariff),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 8, // Move logo down a bit so it's not blocking text
                            right: 8, // Adjust position if necessary
                            child: ClipOval(
                              child: Image.asset(
                                logoAssetPath, // Use the dynamic path
                                width: 30, // Smaller logo size
                                height: 30, // Smaller logo size
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
