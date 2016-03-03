/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
* TODOLIST
* check cell array 1xn or nx1
* fill matlab wrapper with set function
* modify existing constructors and create set/setJMat
* complete get/set of EASY classes


 */
package structures;

import com.jmatio.io.*;
import com.jmatio.types.*;
import gui.JTPMain;
import java.io.IOException;
import java.util.LinkedList;
import java.util.Map;

/**
 *
 * @author alba
 */
public class Project extends JMatlabStructWrapper{
    
        
    JTPMain jtp_main;
    
    public String name;
    public String study_suffix;
    public String analysis_name;
    
    public double[] null_double;
    
    public Operations operations;
    public Paths paths;  
    public Task task;    
    public Import imp;
    public Preproc preproc;
    public Epoching epoching;
    public Subjects subjects;
    public Study study;
    public Erp erp;
    public Ersp ersp;
    public Brainstorm brainstorm;
    public Spm spm;

    
    public Project(){}

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
            // Test Func dbke array
            MatFileReader mfr = new MatFileReader(file_name);
            Map<String, MLArray> mlArrayRetrieved = mfr.getContent();
            MLStructure prj = (MLStructure) mlArrayRetrieved.get("project"); 

            //
            name                = getString(prj, "name");
            study_suffix        = getString(prj, "study_suffix");
            analysis_name       = getString(prj, "analysis_name");

            // ------------------------------------------------------------------------------------------------------------------------------------
            // OPERATIONS
            MLStructure sope = (MLStructure) prj.getField("operations");
            operations = new Operations();
            operations.setJMatData(sope);
  
            // ------------------------------------------------------------------------------------------------------------------------------------
            // PATHS
            MLStructure spaths = (MLStructure) prj.getField("paths");
            paths = new Paths();
            paths.setJMatData(spaths);

            // ------------------------------------------------------------------------------------------------------------------------------------
            // TASK 
            MLStructure stask = (MLStructure) prj.getField("task");
            task = new Task();
            task.setJMatData(stask);

            // ------------------------------------------------------------------------------------------------------------------------------------
            // IMPORT 
            MLStructure simp = (MLStructure) prj.getField("import");
            imp = new Import();
            imp.setJMatData(simp);

            // ------------------------------------------------------------------------------------------------------------------------------------
            // PREPROC
            MLStructure spreproc = (MLStructure) prj.getField("preproc");
            preproc = new Preproc();
            preproc.setJMatData(spreproc);

            // ------------------------------------------------------------------------------------------------------------------------------------
            // EPOCHING 
            MLStructure sepoching = (MLStructure) prj.getField("epoching");
            epoching = new Epoching();
            epoching.setJMatData(sepoching);

            // ------------------------------------------------------------------------------------------------------------------------------------
            // SUBJECTS 
            MLStructure ssubjs = (MLStructure) prj.getField("subjects");
            subjects = new Subjects();
            subjects.setJMatData(ssubjs);
       
            // ------------------------------------------------------------------------------------------------------------------------------------
            // STUDY
            MLStructure sstudy = (MLStructure) prj.getField("study");
            study = new Study();
            study.setJMatData(sstudy);

            // ------------------------------------------------------------------------------------------------------------------------------------
            // ERP
            MLStructure serp = (MLStructure) prj.getField("erp");
            erp = new Erp();
            erp.setJMatData(serp);

            // ------------------------------------------------------------------------------------------------------------------------------------
            // ERSP
            MLStructure sersp = (MLStructure) prj.getField("ersp");
            ersp = new Ersp();
            ersp.setJMatData(sersp);

            // ------------------------------------------------------------------------------------------------------------------------------------
            // BRAINSTORM
            MLStructure sbrainstorm = (MLStructure) prj.getField("brainstorm");
            brainstorm = new Brainstorm();
            brainstorm.setJMatData(sbrainstorm);

            // ------------------------------------------------------------------------------------------------------------------------------------
            // SPM
            MLStructure sspm = (MLStructure) prj.getField("spm");
            spm = new Spm();
            spm.setJMatData(sspm);

            int a = 1;
            
           
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

    public int saveMAT(String input_file) throws IOException
    {
         try
        {
            LinkedList<MLArray> clctn = new LinkedList<MLArray>();
            MLStructure project = new MLStructure("project",new int[] {1,1});
            
            //
            project.setField("name",setString(name));
            project.setField("study_suffix",setString(study_suffix)); //- null
            project.setField("analysis_name",setString(analysis_name));

            // ----------------------------------------------------------------
            // OPERATIONS
            project.setField("operations",operations.getJMatData());
  
            // ----------------------------------------------------------------
            // PATHS
            project.setField("paths",paths.getJMatData());

            // ----------------------------------------------------------------
            // TASK
            project.setField("task",task.getJMatData());

            // ------------------------------------------------------------------------------------------------------------------------------------
            // IMPORT
            project.setField("import",imp.getJMatData());

            // ------------------------------------------------------------------------------------------------------------------------------------
            // PREPROC 
            project.setField("preproc",preproc.getJMatData());

            // ------------------------------------------------------------------------------------------------------------------------------------
            // EPOCHING  
            project.setField("epoching",epoching.getJMatData());

            // ------------------------------------------------------------------------------------------------------------------------------------
            // SUBJECTS
            project.setField("subjects",subjects.getJMatData());

            // ------------------------------------------------------------------------------------------------------------------------------------
            // STUDY
            project.setField("study",study.getJMatData());

            // ------------------------------------------------------------------------------------------------------------------------------------
            // ERP
            project.setField("erp",erp.getJMatData());

            // ------------------------------------------------------------------------------------------------------------------------------------
            // ERSP - create diffsize for String[][][]
            project.setField("ersp",ersp.getJMatData());

            // ------------------------------------------------------------------------------------------------------------------------------------
            // BRAINSTORM - null + nested matrix (14x3)
            project.setField("brainstorm",brainstorm.getJMatData());

            // ------------------------------------------------------------------------------------------------------------------------------------
            // SPM
            project.setField("spm",spm.getJMatData());
            
            // ----------------------------------------------------------
            // ----------------------------------------------------------
            clctn.add(project); 
            
            MatFileWriter mfw = new MatFileWriter();
            mfw.write(input_file, clctn);
            
        }
        catch(IOException e)
        {
            e.toString();
        }
         
        return 1;   // in C++ there is the convention to return 0 if succesfull, or a numeric code to explain the error, 
                    // verify Java standard, that is, if function generally follow this approach.
    }    

}


