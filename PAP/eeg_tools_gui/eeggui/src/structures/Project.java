/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.io.*;
import com.jmatio.types.*;
import gui.JTPMain;
import java.io.IOException;
import java.util.Collection;
import java.util.Map;

/**
 *
 * @author alba
 */
public class Project extends JMatlabStructWrapper{
    
    

    
    public void setGUI()
    {
        jtp_main.setGUI(this);
    }
    public Project getGUI()
    {
        Project proj = jtp_main.getGUI();        
        preproc = proj.preproc;
        return this;
    }   
    
    public Project loadMAT(String file_name)
    {
        try
        {
            MatFileReader mfr = new MatFileReader(file_name);
            Map<String, MLArray> mlArrayRetrieved = mfr.getContent();
            MLStructure prj = (MLStructure) mlArrayRetrieved.get("project");  
            
            // ------------------------------------------------------------------------------------------------------------------------------------
            // TASK 
            MLStructure stask = (MLStructure) prj.getField("task");
            task = new Task(stask);

            // ------------------------------------------------------------------------------------------------------------------------------------
            // IMPORT 
            MLStructure simp = (MLStructure) prj.getField("import");
            imp = new Import(simp);
         
            // ------------------------------------------------------------------------------------------------------------------------------------
            // EEG DATA 
            MLStructure sdata = (MLStructure) prj.getField("eegdata");
            eegdata = new EEGdata(sdata);
            

            // Test 3D
            MLStructure stest3D = (MLStructure) prj.getField("test3D");
            
            int[] dim3D   = stest3D.getDimensions();
            //int rows    = dim[0];      int cols = dim[1];
            
            
            int grggdgdfhtrdh = 1;
            
           
        }
        catch(IOException e)
        {
            e.toString();
        }
                
        

        
        //String str_array = dy.contentToString();
        //System.out.print(str_array);
        
        //Map<String, MLArray> mat_struct = m.read(input_file);

        // open file, fill each project instances
        // preproc = ...
        return this;
    }

    public int saveMAT(String input_file, Collection<MLArray> clctn) throws IOException
    {
         try
        {
            MatFileWriter mfw = new MatFileWriter();
            mfw.write(input_file, clctn);
        }
        catch(IOException e){
            e.printStackTrace();
        }
         
        return 1;   // in C++ there is the convention to return 0 if succesfull, or a numeric code to explain the error, 
                    // verify Java standard, that is, if function generally follow this approach.
    }    
    
    JTPMain jtp_main;
    public Preproc preproc;    
    public Import imp;
    public EEGdata eegdata;
    public Task task;
}


