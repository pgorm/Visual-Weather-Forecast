// Visual Weather Forecast

//Defining the pins that connect the Arduino to each weather condition LED.
#define other 2
#define thunder 4
#define clear 7   
#define rain 8
#define drizzle 5
#define cloudy 13

//Variables for storing the weather condition frequency.
int clear_count = 0;
int cloudy_count = 0;
int drizzle_count = 0;
int rain_count = 0;
int thunder_count = 0;
int other_count = 0;

char buffer[7] ;
int pointer = 0;
byte inByte = 0;


void setup() 
{
  Serial.begin(9600);  // Serial port is opened and the baud rate is set.
}

void loop() 
{

  while (Serial.available() > 0)  {    //Wait for data to be sent from Processing.

    //Flash an LED while waiting for an '*' to be sent.
    for (int i = 0; i < 2; i++) {
      digitalWrite(other, HIGH);  
      delay(1000);              
      digitalWrite(other, LOW);    
      delay(1000); 
    }

    // Read the incoming byte:
    inByte = Serial.read();

    // If the asterix is found then store the next six chars.
    if (inByte == '*') { 
          
      while (pointer < 6) { 
        buffer[pointer] = Serial.read(); // store the char in the buffer
        pointer++; // move the pointer forward by 1
      }

      //Convert the Hex chars to decimal.
      clear_count = hextodec(buffer[0]);
      cloudy_count = hextodec(buffer[1]);
      drizzle_count = hextodec(buffer[2]);
      rain_count = hextodec(buffer[3]);
      thunder_count = hextodec(buffer[4]);
      other_count = hextodec(buffer[5]);
      
      int i;
      int delayvar = 500;

      //Flash the LED's for the amount of times each weather condition is to occur.
      delay(1000);
      for (i = 0; i < clear_count; i++) {
        digitalWrite(clear, HIGH); 
        delay(delayvar);              
        digitalWrite(clear, LOW);    
        delay(delayvar); 
      }
        delay(delayvar);
        
      for (i = 0; i < cloudy_count; i++) {
        digitalWrite(cloudy, HIGH);  
        delay(delayvar);             
        digitalWrite(cloudy, LOW);    
        delay(delayvar); 
      }
      delay(delayvar);

      for (i = 0; i < drizzle_count; i++) {
        digitalWrite(drizzle, HIGH); 
        delay(delayvar);             
        digitalWrite(drizzle, LOW);  
        delay(delayvar); 
      }
      delay(delayvar);

      for (i = 0; i < rain_count; i++) {
        digitalWrite(rain, HIGH);  
        delay(delayvar);              
        digitalWrite(rain, LOW);    
        delay(delayvar); 
      }
      delay(delayvar);

      for (i = 0; i < thunder_count; i++) {
        digitalWrite(thunder, HIGH);  
        delay(delayvar);              
        digitalWrite(thunder, LOW);  
        delay(delayvar); 
      }
      delay(delayvar);

      for (i = 0; i < other_count; i++) {
        digitalWrite(other, HIGH); 
        delay(delayvar);             
        digitalWrite(other, LOW);    
        delay(delayvar); 
      }

      delay(5000);
            
      pointer = 0; // reset the pointer so the buffer can be reused
     
    }    
  }   
}

// converts one HEX character into a number
int hextodec(byte c) {
    if (c >= '0' && c <= '9') {
      return c - '0';
    } 
    else if (c >= 'A' && c <= 'F') {
      return c - 'A' + 10;
    }
}

