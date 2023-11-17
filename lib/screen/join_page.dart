import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

//dio 사용시 객체 생성
final dio = Dio();

class JoinPage extends StatelessWidget {
  const JoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController input_id = TextEditingController();
    TextEditingController input_pw = TextEditingController();
    TextEditingController input_age = TextEditingController();
    TextEditingController input_name = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 페이지'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
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
              controller: input_id,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                label: Row(
                  children: [
                    Icon(Icons.key),
                    Text("비밀번호 입력 "),
                  ],
                ),

              ),
              keyboardType: TextInputType.text,
              obscureText: true,
              controller: input_pw,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  label: Text("나이 입력 "),
                  hintText: "20",
                  hintStyle: TextStyle(color: Colors.grey[300])),
              keyboardType: TextInputType.number,
              controller: input_age,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  label: Text("이름 입력 "),
                  hintText: "플러터",
                  hintStyle: TextStyle(color: Colors.grey[300])),
              keyboardType: TextInputType.text,
              controller: input_name,
            ),
          ),

          ElevatedButton(onPressed: () {
            joinMember(
                input_id.text, input_pw.text, input_age.text, input_name.text,
                context);
          }, child: Text('회원 가입'))
        ],
      ),
    );
  }
}

void joinMember(id, pw, age, name, context) async{
  //값을 보내기
  Response res = await dio.get('http://121.147.52.38:8088/member/join',
  queryParameters: {'id' : id, 'pw':pw, 'age' : age, 'name':name});

  print(res.realUri);

  if(res.statusCode ==200){
    if(res.data == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 완료')));
      Navigator.pop(context);

    }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패'))
      );
  };
}