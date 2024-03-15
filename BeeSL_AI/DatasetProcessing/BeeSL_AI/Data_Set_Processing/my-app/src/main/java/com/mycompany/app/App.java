package com.mycompany.app;

import java.io.BufferedReader;

//import org.codehaus.jackson.map.*;
//import org.codehaus.jackson.*;
//https://www.ngdata.com/parsing-a-large-json-file-efficiently-and-easily/

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;
import java.io.File;

import com.fasterxml.jackson.core.*;
import com.fasterxml.jackson.core.util.DefaultPrettyPrinter;
import com.fasterxml.jackson.databind.*;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;;




/**
 * Hello world!
 *
 */
public class App 
{
    static final int numberOFVideos = 200;
    static final float lengthOFSign = 2;
    static final double radioOfTraining = 0.4;
    
    public static String[] CreateCSV(String[] video, String label, float[] starts , int length)
    {
        String finalCSV[] = new String[length];

        for (int i = 0; i < length; i++) {
            float end = starts[i] + lengthOFSign;
            String parsedCSV = video[i]+".mp4,"+label+","+starts[i] +"," + end;
            finalCSV[i] = parsedCSV;
        }

        return finalCSV;
    }
   
    public static void main( String[] args ) throws JsonParseException, IOException 
    {
        //First we create the CSVfile we want to work on
        BufferedWriter writer = new BufferedWriter(new FileWriter("TrainingData.txt"));
        writer.write("video, label, start, end");
        writer.newLine();

        //First we create the CSVfile we want to work on
        BufferedWriter testwriter = new BufferedWriter(new FileWriter("TestingData.txt"));
        testwriter.write("video, label, start, end");
        testwriter.newLine();
        //Then we set up our json parser

        BufferedWriter listWriter = new BufferedWriter(new FileWriter("Label_to_Action.csv"));
        listWriter.write("label, Action");
        listWriter.newLine();
        int label_Counter = 0;
        //In this file all labels are connection to their wwritten actions

        ObjectMapper mapper = new ObjectMapper();
        ArrayNode jsonArrayTraining = mapper.createArrayNode();
        ArrayNode jsonArrayTesting = mapper.createArrayNode();


        JsonFactory jFactory = new JsonFactory();
        JsonParser jParser = jFactory.createParser(new File("dict_spottings.json"));
        JsonToken currentToken = jParser.nextToken();
        currentToken = jParser.nextToken();
        currentToken = jParser.nextToken();

        int TestCounter = 0;
        int sectionCounter = 0;
        int sectionNumber = 0;
        //Housekeeping values section number holds the type of data we are currently holding

        String ActionName = "";
        String videoNames[] = new String[numberOFVideos];
        float startTimes[] = new float[numberOFVideos];
        //Where the appropriate data will be stored


        //Now we ask what function the user would like the program to do
        Scanner console_Reader = new Scanner(System.in);
        System.out.println("should the system get slimmed dataset or specific data from file?");
        //does the user want to get the slimmed data or the data of specific videos in the number per video file
        String user_Answer = console_Reader.nextLine();
        ArrayList<String> video_Names_From_File = new ArrayList<String>();

        Boolean is_Specific= false;
        if(user_Answer.equals("specific"))
        {
            is_Specific = true;
            System.out.println("Gettimg videos from file");
            BufferedReader specifc_Reader = new BufferedReader(new FileReader("Number_Per_Video.txt"));
            String line_From_File[] = specifc_Reader.readLine().split(",");

            System.out.println(line_From_File[0].substring(0,line_From_File[0].length()-4));

            video_Names_From_File.add(line_From_File[0].substring(0,line_From_File[0].length()-4));
            int number_Per_Video = Integer.parseInt(line_From_File[1]);

            while (number_Per_Video >= 15) 
            {
                line_From_File = specifc_Reader.readLine().split(",");
                video_Names_From_File.add(line_From_File[0].substring(0,line_From_File[0].length()-4));
                number_Per_Video = Integer.parseInt(line_From_File[1]);
            }                
        }

        
        
        //Now it holds the first action for storage
        while (jParser.nextToken() != JsonToken.END_OBJECT && TestCounter < 200 ) {
            

            if (sectionNumber ==0) 
            {
                //This measn we need to initalize 
                ActionName = jParser.currentName();

                listWriter.write(label_Counter+","+ActionName);
                listWriter.newLine();
            
                System.out.print(ActionName + "\n");
                //Action now stores the first action 
                
                    currentToken = jParser.nextToken();
                    currentToken = jParser.nextToken();
                    currentToken = jParser.nextToken();
                    jParser.skipChildren();  
                    //Skips the probability array as we dont want to store that 
                    
                    currentToken = jParser.nextToken();
                    currentToken = jParser.nextToken();
                    sectionNumber = sectionNumber +1;
                    //Sets up the next section so that the next token is a number
            }
            else if (sectionNumber == 1)
            {
                //This means we are collecting global times
                if(sectionCounter < numberOFVideos && jParser.currentToken() != JsonToken.END_ARRAY)
                {
                    currentToken = jParser.currentToken();

                    startTimes[sectionCounter] = jParser.getFloatValue();
                    sectionCounter = sectionCounter + 1;                
                }
                else
                {
                    currentToken = jParser.currentToken();

                    while (jParser.currentToken() != JsonToken.END_ARRAY)
                    {
                        currentToken = jParser.nextToken();
                    }

                    currentToken = jParser.nextToken();
                    currentToken = jParser.nextToken();
                    
                    // Setting up start of new section
                    sectionNumber = sectionNumber + 1;
                    sectionCounter = 0;

                }
            }
            else if (sectionNumber == 2)
            {                
                //This means we are collecting global times
                if(sectionCounter < numberOFVideos && jParser.currentToken() != JsonToken.END_ARRAY)
                //if the number of examples are less than the number of Videos currently being collected this needs to be tested
                {                                        
                    videoNames[sectionCounter] = jParser.getText();
                    sectionCounter = sectionCounter + 1; 
                    
                }
                else
                {
                    while (jParser.currentToken() != JsonToken.END_ARRAY )
                    // if the current node is a end structure 
                    {
                        currentToken = jParser.nextToken();
                    }

                    // Setting up start of new section

                    // ok now all of the arraus are filled with the examples now we write our csv 

                    if(sectionCounter < 25)
                    {   
                        String csvLines[] = CreateCSV(videoNames, String.valueOf(label_Counter), startTimes, sectionCounter);

                        int number_OF_testing = (int)Math.floor(sectionCounter * radioOfTraining);
                        


                        for (int i = 0; i < sectionCounter-number_OF_testing; i++) 
                        {
                            if (is_Specific == true) {
                                if(video_Names_From_File.contains( videoNames[i]))
                                {
                                    writer.write(csvLines[i]);   
                                    writer.newLine();     
                                    //CSV
                                    
                                    ObjectNode child_Node = mapper.createObjectNode();
                                    child_Node.put("video",videoNames[i]+".mp4");
                                    child_Node.put("label",String.valueOf(label_Counter) );
                                    child_Node.put("start",startTimes[i]);
                                    child_Node.put("end",startTimes[i] +lengthOFSign);
        
                                    jsonArrayTraining.add(child_Node);
                                }
                            }
                            else
                            {
                            writer.write(csvLines[i]);   
                            writer.newLine();     
                            //CSV
                            
                            ObjectNode child_Node = mapper.createObjectNode();
                            child_Node.put("video",videoNames[i]+".mp4");
                            child_Node.put("label",String.valueOf(label_Counter) );
                            child_Node.put("start",startTimes[i]);
                            child_Node.put("end",startTimes[i] +lengthOFSign);

                            jsonArrayTraining.add(child_Node);
                            }
                        }
                        //Write all of the training data ro CSV
                        for (int i =  sectionCounter-number_OF_testing; i < sectionCounter; i++) 
                        {
                            if (is_Specific == true) {
                                if(video_Names_From_File.contains( videoNames[i]))
                                {
                                    testwriter.write(csvLines[i]);   
                                    testwriter.newLine();     
                                    //CSV
    
                                    ObjectNode child_Node = mapper.createObjectNode();
                                    child_Node.put("video",videoNames[i]+".mp4");
                                    child_Node.put("label",String.valueOf(label_Counter) );
                                    child_Node.put("start",startTimes[i]);
                                    child_Node.put("end",startTimes[i] +lengthOFSign);
    
                                    jsonArrayTesting.add(child_Node);
                                }
                            }
                            else
                            {
                                testwriter.write(csvLines[i]);   
                                testwriter.newLine();     
                                //CSV

                                ObjectNode child_Node = mapper.createObjectNode();
                                child_Node.put("video",videoNames[i]+".mp4");
                                child_Node.put("label",String.valueOf(label_Counter) );
                                child_Node.put("start",startTimes[i]);
                                child_Node.put("end",startTimes[i] +lengthOFSign);

                                jsonArrayTesting.add(child_Node);
                            }
                        }
                    }
                    //write all the training data
                    label_Counter = label_Counter + 1;
                        
                    //TestCounter++;

                    sectionNumber = 0;
                    sectionCounter = 0;
                    currentToken = jParser.nextToken();
                   
                }
            }
        }

        ObjectWriter objectWriter = mapper.writer(new DefaultPrettyPrinter());
        objectWriter.writeValue(new File("jsonDataTraining.json"), jsonArrayTraining);
        objectWriter.writeValue(new File("jsonDataTesting.json"), jsonArrayTesting);


        writer.close();
        listWriter.close();
        testwriter.close();
        System.out.println("done!!");
    }
}
