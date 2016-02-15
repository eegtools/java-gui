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
    
    public int do_source_analysis;
    public int do_emg_analysis;
    public int do_cluster_analysis;
    
    public Paths paths;  
    public Task task;    
    public Import imp;
    public EEGdata eegdata;
    public Preproc preproc;
    public Epoching epoching;
    public Subjects subjects;
    public Study study;
    public Design design;
    public Stats stats;
    public Postprocess postprocess;
    public ResultsDisplay results_display;
    public Export export;
    public Clustering clustering;
    public Brainstorm brainstorm;

    
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
        
            do_source_analysis  = getInt(prj, "do_source_analysis");
            do_emg_analysis     = getInt(prj, "do_emg_analysis");
            do_cluster_analysis = getInt(prj, "do_cluster_analysis");
  
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
            // EEG DATA - see if list are String or String[]
            MLStructure sdata = (MLStructure) prj.getField("eegdata");
            eegdata = new EEGdata();
            eegdata.setJMatData(sdata);
  
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
            // STUDY - Pbes in Precomput, change struct
            MLStructure sstudy = (MLStructure) prj.getField("study");
            study = new Study();
            study.setJMatData(sstudy);
            
            // ------------------------------------------------------------------------------------------------------------------------------------
            // DESIGN - Pbes, change struct
            //MLStructure sdesign = (MLStructure) prj.getField("design");
            //design = new Design();
            //design.setJMatData(sdesign);
            
            // ------------------------------------------------------------------------------------------------------------------------------------
            // STATS - Pbes in Precomput, change struct
            MLStructure sstats = (MLStructure) prj.getField("stats");
            stats = new Stats();
            stats.setJMatData(sstats);
            
            // ------------------------------------------------------------------------------------------------------------------------------------
            // POSTPROCESS - A remplir !!
            MLStructure spostproc = (MLStructure) prj.getField("postprocess");
            postprocess = new Postprocess();
            postprocess.setJMatData(spostproc);
            
            // ------------------------------------------------------------------------------------------------------------------------------------
            // RESULTS DISPLAY
            MLStructure sresdisp = (MLStructure) prj.getField("results_display");
            results_display = new ResultsDisplay();
            results_display.setJMatData(sresdisp);
            
            /* -> doesn't exist anymore ??
            // ------------------------------------------------------------------------------------------------------------------------------------
            // EXPORT - Pbes pour instancier bands
            MLStructure sexport = (MLStructure) prj.getField("export");
            export = new Export();
            export.setJMatData(sexport);
            */
            
            // ------------------------------------------------------------------------------------------------------------------------------------
            // CLUSTERING
            MLStructure scluster = (MLStructure) prj.getField("clustering");
            clustering = new Clustering();
            clustering.setJMatData(scluster);
            
            // ------------------------------------------------------------------------------------------------------------------------------------
            // BRAINSTORMING
            MLStructure sbrainstorm = (MLStructure) prj.getField("brainstorm");
            brainstorm = new Brainstorm();
            brainstorm.setJMatData(sbrainstorm);

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
            MLStructure a = new MLStructure("a",new int[] {1,1});
            
            
            
            // Test Func to write String[]
            String[] test11 = new String[]{"test1","test2","test3"};
            MLCell str_arr11 = setStringLineArray(test11);
            a.setField("LineVec",str_arr11);
            MLCell str_arr12 = setStringColumnArray(test11);
            a.setField("ColumnVec",str_arr12);
            
            
            
            // Test Func for 2D merged cell
            String[][] test_encore = new String[4][3];
            test_encore[0][0] = "aa";
            test_encore[0][1] = "ab";
            test_encore[0][2] = "ac";
            test_encore[1][0] = "ba";
            test_encore[1][1] = "bb";
            test_encore[1][2] = "bc";
            test_encore[2][0] = "ba";
            test_encore[2][1] = "bb";
            test_encore[2][2] = "bc";
            test_encore[3][0] = "ba";
            test_encore[3][1] = "bb";
            test_encore[3][2] = "bc";
            MLCell str_test_encore = setStringColLineCell(test_encore);
            a.setField("str_test_encore",str_test_encore);
            
            // Test Func for 3D merged cell
            String[][][] test_pf = new String[2][3][2];
            test_pf[0][0][0] = "aaa";
            test_pf[0][0][1] = "aab";
            test_pf[0][1][0] = "aba";
            test_pf[0][1][1] = "abb";
            test_pf[0][2][0] = "aca";
            test_pf[0][2][1] = "acb";
            test_pf[1][0][0] = "baa";
            test_pf[1][0][1] = "bab";
            test_pf[1][1][0] = "bba";
            test_pf[1][1][1] = "bbb";
            test_pf[1][2][0] = "bca";
            test_pf[1][2][1] = "bcb";
            MLCell cell_test_pf = setStringTripleColumnCell(test_pf);
            a.setField("cell_test_pf",cell_test_pf);
            

            clctn.add(a);   
            
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


