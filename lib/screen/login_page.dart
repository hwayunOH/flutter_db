import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_db/model/member_model.dart';
import 'package:flutter_db/screen/join_page.dart';
import 'package:flutter_db/screen/login_success.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


final dio = Dio();
final storage = FlutterSecureStorage(); // flutter secure storage 사용하여 storage에 저장
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  void readStorage()async{
    var memberId = await storage.read(key: 'login');
    if(memberId != null){
      MemberModel member = memberModelFromJson(memberId)[0];
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_)=>
              LoginSuccess(member: member)), (route) => false);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readStorage();
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController emailCon = TextEditingController();
    TextEditingController pwCon = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인 페이지'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: emailCon,
                    decoration: InputDecoration(
                        label: Row(
                          children: [
                            Icon(Icons.account_circle),
                            Text("email 입력 "),
                          ],
                        ),
                        hintText: "example@example.com",
                        hintStyle: TextStyle(color: Colors.grey[300])),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: pwCon,
                      decoration: InputDecoration(
                        label: Row(
                          children: [
                            Icon(Icons.key),
                            Text("pw 입력 "),
                          ],
                        ),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent),
                        onPressed: () {
                           selectId(emailCon.text, pwCon.text, context);
                          // selectId(emailCon.text, pwCon.text, context);
                        },
                        child: Text('로그인하기')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_)=> JoinPage()));

                        },
                        child: Text('회원가입하기'))
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  color: Colors.grey[200],
                  width: double.infinity,
                  height: 2,
                ),
                SizedBox(
                  height: 40,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

void selectId(id, pw, context) async {
  Response res = await dio.get('http://121.147.52.38:8088/member/login',
      queryParameters: {'id': id, 'pw': pw});

  print(res.realUri);
  if (res.data != null) {
    var mm = memberModelFromJson(res.data);
    print(mm[0].name);
    await storage.write(key: 'login', value: res.data
    );
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => LoginSuccess(member: mm[0])),
            (route) => false);
  }


}