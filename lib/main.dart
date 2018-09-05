import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  const MyApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Names',
      home:  MyHomePage(title:'Baby Name Votes'),
    );
  }
}
class MyHomePage extends StatelessWidget {
  MyHomePage({Key key,this.title}):super(key:key);
  final String title;
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      key: ValueKey(document.documentID),
      title: Container(
       decoration:BoxDecoration(
         border: Border.all(color: Color(0x80000000)),
         borderRadius:BorderRadius.circular(5.0),

       ) ,

       padding: EdgeInsets.all(10.0),
        child: Row(

          children: <Widget>[
            Expanded(
                child: Text(document['name'],
                style: TextStyle(color: Colors.blue,fontStyle: FontStyle.italic),),
            ),
           Text(document['votes'].toString(),
             style: TextStyle(color: Colors.deepOrange,fontStyle: FontStyle.italic),),
          ],
        ),
      ),
onTap: ()=> Firestore.instance.runTransaction((transaction)async {
  DocumentSnapshot freshSnap = await transaction.get(document.reference);
  await transaction.update(freshSnap.reference, {'votes': freshSnap['votes'] + 1});

}),



    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: StreamBuilder(

        stream: Firestore.instance.collection('baby').snapshots(),
          builder: (context,snapshot){
          if(!snapshot.hasData) return Text("Loading......");
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
              padding: EdgeInsets.only(top: 10.5),
              itemExtent: 55.0,
              itemBuilder: (context,index) =>
              _buildListItem(context,snapshot.data.documents[index]),
              
          );
          }

      ),

    );
  }


}
