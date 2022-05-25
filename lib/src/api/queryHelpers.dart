
import 'package:html_unescape/html_unescape.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'dart:convert';



String basicAuthFixer(username, password) => 'Basic ' + base64Encode(utf8.encode('$username:$password'));



List removeAllHtmlTags(String htmlText) {
    int counter = 0;
    HtmlUnescape unescape = new HtmlUnescape();
    List fullTextBody = [];
    String pictureIdentifier= 'BILD_I';

    //regexp för att plocka bort alla taggar
    RegExp exp = RegExp(
      //r"<[^>]*>",
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
    );

    //regexp för att hitta hela img src taggen o ta bort
    RegExp imgWholeTagWithSrc = RegExp(r'<img.*?src=(.*?).*?>',multiLine: true,
      caseSensitive: true);    

    //regexp för att plocka ut url:n endast
    RegExp imgExp = RegExp(r'src\s*=\s*"([^"]+)"',multiLine: true,
      caseSensitive: true);
    

    //hämtar ut alla bilder i ordning de ligger i texten
    List allImagesInOrder = imgExp.allMatches(htmlText).map((data) => data.group(1)).toList();

    allImagesInOrder.forEach((element) {

        if(element == "http://rightnow.jeeves.se/pictures/Jeeves_1.png") {
          int index = allImagesInOrder.indexOf(element);
          allImagesInOrder[index] = "https://rightnow.jeeves.se/pictures/Jeeves_1.png";
        }
      
    });
    
    //vi ersätter alla texter med ordet BILD_IDENTIFIERARE för att kunna ersätta detta senare med en bild från listan.
    var replacePicsText = htmlText.replaceAll(imgWholeTagWithSrc, pictureIdentifier);

    List<dynamic> allText = unescape.convert(replacePicsText.replaceAll(exp, '')).split("\n");
    String concattedText ='';


    if(allText.contains(pictureIdentifier)) {

    allText.forEach((var text) {
      print('ze counter');
      print(counter);
             print('-*-');
        print(allImagesInOrder.length);
        print(counter);
        print('-*-');
      if(text.trim().contains(pictureIdentifier)) {
        fullTextBody.add({'widgetType':Text(concattedText)});
        concattedText = '';
        //om vi hittar order ovan, vet vi att en bild ska ligga här och lägger den här
        fullTextBody.add({"widgetType":Image.network(allImagesInOrder[counter]), 'url': allImagesInOrder[counter]});
        counter++;
      } else if (counter != allImagesInOrder.length){
        concattedText += text + '\n';
      }
      
      
      else if (counter == allImagesInOrder.length){
        concattedText += text + '\n';
        fullTextBody.add({'widgetType':Text(concattedText)});
        print('---');
        print(concattedText);
        print(allImagesInOrder.length-1);
        print(counter);
        print('---');
        concattedText = '';
      }
    });
    }else {
      fullTextBody.add({'widgetType':Text(allText.join('\n'))});
    }


    //Lista med Text- och Image.Network objekt
    return fullTextBody;

    //return unescape.convert(asd.replaceAll(exp, ''));

}


bool checkIfCreatedByEmployee(user, accounts) {
  accounts.forEach((var acc) {

    if(user.toString() == acc[0].toString()){
        return true;
    }    //print(acc['id'].toString() + ':accid-incident: ' + incident[7].toString());

  });
  return false;


}

String accountFinder(userMessage, fullAccountList) {

  for(var acc in fullAccountList) {
    if(userMessage.toString() == acc[0].toString()){
        return acc[1].toString();
    }    //print(acc['id'].toString() + ':accid-incident: ' + incident[7].toString());

  }
  return 'Kontakt ej hittad';

  /*for(var acc in accounts) {
  if(userMessage.toString() == '9780') {
    print(userMessage.toString());
  }
    if(userMessage.toString() == acc[0].toString()){
        print(acc[1].toString());
      
    */}    //print(acc['id'].toString() + ':accid-incident: ' + incident[7].toString());



getAccountFromDb(asd,db, searchValue)async {
      Database queryDBx = await asd(db);
      List<Map> userlist = await queryDBx.rawQuery('SELECT * FROM User');
      if (userlist.length > 0) {
        String login = userlist[0]['USERNAME'];
        String password = userlist[0]['password'];
      }
      return userlist;
}

