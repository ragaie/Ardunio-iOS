//#include <Servo.h>
#include <SoftwareSerial.h>
//Servo servo1;

SoftwareSerial ble(0, 1); //2, 3 RX, TX  --> to TX and RX of module


//
//Arduino | HM-10
//D2          | TX
//D3          | RX
//GND      | GND
//3.3V       | VCC
 




// setup for first motor 
//first motor
#define enA 9 //for pwm pin enable motor
#define in1 8
#define in2 7
//secand motor
#define enB 4
#define in3 6
#define in4 5

//light and sign light pin 

#define left 12
#define right 13

#define light 2




int  moveLeft = 0;
int moveRight = 0;
int  lastStateMoveLeft = 0;
int lastStateMoveRight = 0;


int speed = 0;

//push buuton 
const int  leftPin = 10;    // the pin that the pushbutton is attached to
const int rightPin = 11;
void setup() {

  setupSerial();
  setupDC();
//  setupServo();
//setup stop pins 
  pinMode(leftPin, INPUT);
  pinMode(rightPin, INPUT);

}
void loop() {


   moveLeft = digitalRead(leftPin);
   moveRight =  digitalRead(rightPin);

if (moveLeft != lastStateMoveLeft  || moveRight != lastStateMoveRight ){

      if (moveLeft == HIGH  || moveRight == HIGH ){

            changeDirection('s');
      }
 lastStateMoveLeft = moveLeft;
 lastStateMoveRight = moveRight;
}


   
 



 if (ble.available()){  

  char action = ble.read();
 

//if(action == '1' || action == '2' ||action == '3' || action == '4' || action == '5'){
////write spped 
//Serial.print(int(action));
//Serial.print("\n");
//
//Serial.print( int(action) * 5 );
//Serial.print("\n");
//
//    analogWrite(enA, ( int(action) * 2 )); // Send PWM signal to motor A
//  }


  if ( action == '1'){
        analogWrite(enA, 90);
    } else if ( action == '2'){
         analogWrite(enA, 110);
    } else if ( action == '3'){
        analogWrite(enA, 150);
    } else if ( action == '4'){
        analogWrite(enA, 180);
    } else if ( action == '5'){
              analogWrite(enA, 220);

    }



  
  //commant for moveing
  else if ( action == 's'){
         digitalWrite(in1, LOW);
         digitalWrite(in2, LOW);
    } else if ( action == 'f'){
         // Set Motor A forward
         digitalWrite(in1, HIGH);
         digitalWrite(in2, LOW);
    } else if ( action == 'b'){
          // Set Motor A to move back with speed 90 
          analogWrite(enA, 110);
          digitalWrite(in1, LOW);
          digitalWrite(in2, HIGH);
    }
    ///command for direction move 

    else if ( action == 'l'){
         if (moveLeft == 0){
            digitalWrite(in3, HIGH);
            digitalWrite(in4, LOW);

            //open light
            digitalWrite(left, HIGH);

        }
    }else if ( action == 'r'){
         if (moveRight == 0){
             digitalWrite(in3, LOW);
             digitalWrite(in4, HIGH);
             //open light
             digitalWrite(right, HIGH);
        }
    }else if ( action == 'S'){
         digitalWrite(in3, LOW);
         digitalWrite(in4, LOW);
        //turn off light
         digitalWrite(left, LOW);
         digitalWrite(right, LOW);

    }


///light left  6-7 middle -8 right

else if ( action == 'y'){
        digitalWrite(left, HIGH);
    }else if ( action == 'x'){
        digitalWrite(light, HIGH);
    }else if ( action == 'z'){
        digitalWrite(right, HIGH);
    }else if ( action == 'Y'){
        digitalWrite(left, LOW);
    }else if ( action == 'X'){
        digitalWrite(light, LOW);
    }else if ( action == 'Z'){
        digitalWrite(right, LOW);
    }
  
} 
}



void setupSerial(){
    // Open serial port
  Serial.begin(9600);
  // begin bluetooth serial port communication
  ble.begin(9600);
  
}



void setupDC(){
    //define pins output for first motor and secand motor
   pinMode(enA, OUTPUT);
  pinMode(enB, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  pinMode(in3, OUTPUT);
  pinMode(in4, OUTPUT);
  
//direction motor
   analogWrite(enB, 140); // Send PWM signal to motor B
   
   //moving motor
    analogWrite(enA, 90); // Send PWM signal to motor A


/// light pins 
  pinMode(left, OUTPUT);
  pinMode(right, OUTPUT);
  pinMode(light, OUTPUT);

  }






void changeDirection(char dir){

    digitalWrite(in3, LOW);
    digitalWrite(in4, LOW);

switch (dir){
  case 'S':
      digitalWrite(in3, LOW);
      digitalWrite(in4, LOW);
        //turn off light
         digitalWrite(left, LOW);
         digitalWrite(right, LOW);
      
    break;
   case 'l':
    // Set Motor A forward

    if (moveLeft == 0){
      digitalWrite(in3, HIGH);
    digitalWrite(in4, LOW);
    }
  break;
  case 'r':
    // Set Motor A forward
    if (moveRight == 0){
     digitalWrite(in3, LOW);
     digitalWrite(in4, HIGH);
    }
  break;
  }


  
  }

