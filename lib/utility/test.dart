import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KonlakraengScreen extends StatefulWidget {

  @override
  _KonlakraengScreenState createState() => _KonlakraengScreenState();
}

class _KonlakraengScreenState extends State<KonlakraengScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Container(
          width: 120,
          height: 100,
          child: Icon(Icons.qr_code),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.lightBlueAccent,
                Colors.greenAccent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 0.4, 1],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Colors.black54,),
           // title: Text('หน้าแรก',style: TextStyle(color: Colors.black54),),
            label: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.business,
               color: Colors.white,
            ),
            label: 'สแกนจ่าย',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'กระเป๋าตังค์',
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(size: size),
              CenterWidget(size: size),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: [
                    IconWidget(icon: Icons.account_balance, label: 'ธนาคาร'),
                    IconWidget(
                        icon: Icons.account_balance_wallet, label: 'ถอนเงิน '),
                    IconWidget(
                        icon: Icons.add_business_outlined, label: 'ฝากเงิน '),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IconWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  const IconWidget({
    Key key,
    this.icon,
    this.label,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
        onPressed: () {},
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.lightBlueAccent,
            ),
            Text(
              label,
              style: TextStyle(color: Colors.lightBlueAccent),
            ),
          ],
        ),
      ),
    );
  }
}

class CenterWidget extends StatelessWidget {
  const CenterWidget({
    Key key,
    this.size,
  }) : super(key: key);
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              'https://paaktai.com/files/com_news_economy/2018-01_34946e33f0ec19e.jpg',
              height: 200,
              width: size.width,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              'https://pmcu.co.th/wp-content/uploads/2020/06/poster-shoptidfarm.jpg',
              height: 200,
              width: size.width,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key key,
    this.size,
  }) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: ClipPath(
            clipper: ClipPathClass(),
            child: Container(
              width: double.infinity,
              height: size.height * 0.23,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent,
                    Colors.lightBlueAccent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              Row(
                children: [
                  ClipOval(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.white70,
                      child: FlutterLogo(
                        size: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'A - Wallet',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '123-1231-123123',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add_alert_sharp),
                    color: Colors.white70,
                  )
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'นายไทบ้าน',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'เติมเงิน วอลล์เล็ต ',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    '3,000 บาท',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: RaisedButton.icon(
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Color(0xFF90CF3F),
              onPressed: () {},
              label: Text(
                'เติมเงิน เข้า A-Wallet',
                style: TextStyle(color: Colors.white),
              ),
              icon: ClipOval(
                child: Container(
                  color: Color(0xFF669E30),
                  child: Icon(
                    Icons.add,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);
    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
