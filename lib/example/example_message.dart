import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExMessage extends StatelessWidget {
  const ExMessage({super.key});

  void getHttp() async{
    String url = 'http://121.147.52.38:8088';
    http.Response res = await http.get(Uri.parse(url));
    print(res.body);

  }

  void getDio() async{
    final dio = Dio();      //post도 가능
    Response res =await dio.get('http://121.147.52.38:8088');
    print(res);
  }

  //dio 사용해서 데이터 보낸 후 서버에 출력

  void sendData() async{ //dio통해서 데이터 보내기
    final dio = Dio(); //전역변수로 선언해도 상관없음
    Response res = await dio.get('http://121.147.52.38:8088/send',
    queryParameters: {'id' : '12345'});

    print(res);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            //getDio();
            sendData();

          },
          child: Text('확인'),
        ),
      ),
    );
  }
}
