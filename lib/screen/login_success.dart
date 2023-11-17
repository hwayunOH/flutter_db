import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_db/model/member_model.dart';
import 'package:flutter_db/screen/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'member_update_page.dart';

final dio = Dio();
final storage = FlutterSecureStorage();

class LoginSuccess extends StatelessWidget {
  const LoginSuccess({super.key, required this.member});
  final MemberModel member;

  void showPopup(context, id) {
    showDialog(context: context, builder: (context){
      return Dialog(

        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 180,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Column(
            children: [
              const SizedBox(height: 32,),

              Text(
                '정말 회원탈퇴를 진행 하시겠습니까?',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),

              SizedBox(height: 40,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(onPressed: ()  {
                      deleteMember((member.id), context);
                    }
                        , icon: Icon(Icons.close), label: Text('회원 탈퇴 하기'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey)),
                    SizedBox(width: 10,),
                    ElevatedButton.icon(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close), label: Text('아니오')),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${member.name} 님 환영합니다.'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(12),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent),
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (_) => MemberUpdatePage(users: member)));

                        },
                        child: Text('회원 수정하기')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        onPressed: () {

                          showPopup(context, member.id);
                        },
                        child: Text('회원 탈퇴하기'))
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
                TextButton(onPressed: () {

                  logout(context);
                }, child: Text('로그아웃하기'))

              ],
            ),
          ),
        ),
      ),
    );
  }
}

void logout(context) async{
  await storage.delete(key: 'login');
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (_)=> LoginPage()), (route) => false);

}

void deleteMember(id, context) async{
  Response res = await dio.get(
      'http://121.147.52.38:8088/member/deleteMember',
      queryParameters: {'id' :id});
  print(res.realUri);
  if(res.data == 'success'){
    logout(context);
    // Navigator.pushAndRemoveUntil(context,
    //     MaterialPageRoute(builder: (_)=>LoginPage()), (route) => false);
  }

}