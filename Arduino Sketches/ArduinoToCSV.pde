import processing.serial.*;

Serial myPort;
String val;
String heading1 = "Sensor Value";      //initialize the column header names
String heading2 = "Volts";
String heading3 = "Degrees (C)";
String heading4 = "Degrees (F)";
int headingNums = 4;
int readings = 100;

Table table;

void setup() 
{
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
  
  table = new Table();                  //create empty table
  table.addColumn(heading1);            //add colu7mns to the table
  table.addColumn(heading2);
  table.addColumn(heading3);
  table.addColumn(heading4);
  noLoop();
}  

void draw()
{
  int count = 0;
  while(count < readings){
    
  if (myPort.available() > 0)            //check for incoming information from Arduino
  {
  val = myPort.readStringUntil('\n');
  }
  if (val != null){                      //make sure incoming value is not null
  //print(val);
  String[] values = val.split(":");       //coordinate with Arduino code to split
                                          //incoming data correctly
  
  if(values.length == headingNums){        
  TableRow newRow = table.addRow();      //create new row
  newRow.setString(heading1, values[0]);  //add incoming values to correct columns
  newRow.setString(heading2, values[1]);
  newRow.setString(heading3, values[2]);
  newRow.setString(heading4, values[3]);
  count++;
  }
  
  }
  saveTable(table, "temperatureSensor/tempTable.csv");    //choose location to save table
  }
}