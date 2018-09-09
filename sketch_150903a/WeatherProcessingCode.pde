//Visual Weather Forecast

//Imports
import processing.serial.*;
import java.net.URL;
import java.net.URLConnection;
import java.io.InputStreamReader;
import java.util.StringTokenizer;

//The website which stores the data.
String feed = "http://api.openweathermap.org/data/2.5/forecast/daily?q=London&mode=xml&units=metric&cnt=7";

int interval = 10;  // retrieve feed every 60 seconds;
int lastTime;       // the last time the content was fetched

// Variables for counting the weather conditions.
int clear_count = 0;
int clouds_count = 0;
int drizzle_count = 0;
int rain_count = 0;
int thunder_count = 0;
int other_count = 0;

Serial port;
color d;
String weatherdata;

String buffer = ""; // Accumulates characters coming from Arduino

PFont font;

/*

XML STUFF

//Defnitions
XML xml;
int id = 0;
String name;
String coloring;

void setup() {

xml = loadXML("test.xml");
XML[] children = xml.getChildren("time");
println(xml.listChildren());

xml = loadXML("test.xml");
XML[] children = xml.getChildren("symbol");
println(firstChild.getContent());


for (int i = 0; i < children.length; i++) 
{
  int id = children[i].getInt("number");
  String coloring = children[i].getString("name");
  //String name = children[i].getContent();
  println(coloring + ", " + id + ", ");
}
}

*/


void setup() {
  
  size(640,580);
  frameRate(10);    // we don't need fast updates

  font = loadFont("Garamond-32.vlw");  
  fill(255);  
  textFont(font, 32);
  
  //Connecting Processing to the COM3 Arduinos port.
  String arduinoPort = Serial.list()[0];
  port = new Serial(this, arduinoPort, 9600); // connect to Arduino

  lastTime = 0;
  fetchData();
}

void draw() {
  
  background( d );
  int n = (interval - ((millis()-lastTime)/1000));
  
  d = color(50, 50, 50);

  weatherdata = "*" + clear_count + clouds_count + drizzle_count + rain_count + thunder_count + other_count;
  

  text("Visual Weather Updates", 10,40);
  text("Reading feed:", 10, 100);
  text(feed, 10, 140);

  //text("Next update in "+ n + " seconds",10,500);
  
  text("clear" ,10,200);
  text(" " + clear_count, 130, 200);

  text("clouds ",10,240);
  text(" " + clouds_count, 130, 240);

  text("drizzle ",10,280);
  text(" " + drizzle_count, 130, 280);
  
  text("rain ",10, 320);
  text(" " + rain_count, 130, 320);
  
  text("thunder ",10, 360);
  text(" " + thunder_count, 130, 360);
  
  text("other",10, 395);
  text(" " + other_count, 130, 395);

  text("sending", 10, 430); 
  text(weatherdata, 135,430);


  if (n <= 0) {
    fetchData();
    lastTime = millis();
  }
  
  port.write(weatherdata); // send data to Arduino
 
}

void fetchData() {
  
  // Strings to parse the feed
  String data; 
  String chunk;

  // zero the counters
  clear_count = 0;
  clouds_count = 0;
  drizzle_count = 0;
  rain_count = 0;
  thunder_count = 0;
  other_count = 0;
  
  try {
    URL url = new URL(feed);  // An object to represent the URL.
    // Prepare a connection.   
    URLConnection conn = url.openConnection(); 
    conn.setRequestProperty("User-Agent", "Mozilla/5.0");
    conn.connect(); // now connect to the Website
   
    // Data from the feed is connected to a buffered
    // reader that reads the data one line at a time.
    BufferedReader in = new
      BufferedReader(new InputStreamReader(conn.getInputStream()));

    // Read each line from the feed.
    while ((data = in.readLine()) != null) {

      StringTokenizer st =
        new StringTokenizer(data,"\"<>,.()[] ");// break it down
      while (st.hasMoreTokens()) {
        // Each chunk of data is made lowercase.
        chunk= st.nextToken().toLowerCase() ;

        if (chunk.indexOf("01d") >= 0 )// found "clear"
          clear_count++; // increment clear by 1
        if ((chunk.indexOf("02d")  >= 0) || (chunk.indexOf("03d")  >= 0) || (chunk.indexOf("04d")  >= 0))
          clouds_count++;
        if ((chunk.indexOf("09d") >= 0)) 
          drizzle_count++; 
        if ((chunk.indexOf("10d") >= 0))
          rain_count++; 
        if ((chunk.indexOf("11d") >= 0)) 
          thunder_count++;        
      }
      
    }    
    //other = snow or mist.
    other_count = 7 - clear_count - clouds_count - drizzle_count - rain_count - thunder_count;    
    
  } 
  catch (Exception ex) { // If there was an error, stop the sketch
    ex.printStackTrace();
    System.out.println("ERROR: "+ex.getMessage());
  }

}