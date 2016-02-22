/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.MLStructure;

/**
 *
 * @author PHilt
 */
public class Ersp extends JMatlabStructWrapper{
 
    public StudyParams_TF study_params;
    public Stats_TF stats;
    public Postprocess_TF postprocess;
    public ResultsDisplay_TF results_display;
    
    public Ersp(){}
     
    public void setJMatData(MLStructure struct)
    {
        study_params    = readStudyParams(struct, "study_params");
        postprocess     = readPostprocess_TF(struct, "postprocess");
        stats           = readStats(struct, "stats");
        results_display = readResultsDisplay(struct, "results_display");
    }    
    
    private StudyParams_TF readStudyParams(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        StudyParams_TF vec = new StudyParams_TF();
        vec.setJMatData(structs);
        return vec;
    }
    
    private Stats_TF readStats(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        Stats_TF vec = new Stats_TF();
        vec.setJMatData(structs);
        return vec;
    }
    
    private Postprocess_TF readPostprocess_TF(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        Postprocess_TF vec = new Postprocess_TF();
        vec.setJMatData(structs);
        return vec;
    }
    
    private ResultsDisplay_TF readResultsDisplay(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        ResultsDisplay_TF vec = new ResultsDisplay_TF();
        vec.setJMatData(structs);
        return vec;
    }

    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});

        struct.setField("study_params",writeStudyParams_TF(study_params));
        struct.setField("stats",writeStats_TF(stats));
        struct.setField("postprocess",writePostprocess_TF(postprocess));
        struct.setField("results_display",writeResultsDisplay_TF(results_display));
 
        return struct;
    }
    
    private MLStructure writeStudyParams_TF(StudyParams_TF study_params_tf)
    {
        MLStructure struct = study_params_tf.getJMatData();
        return struct;
    }
    
    private MLStructure writeStats_TF(Stats_TF stats_tf)
    {
        MLStructure struct = stats_tf.getJMatData();
        return struct;
    }
        
    private MLStructure writePostprocess_TF(Postprocess_TF postprocess_tf)
    {
        MLStructure struct = postprocess_tf.getJMatData();
        return struct;
    }
    
    private MLStructure writeResultsDisplay_TF(ResultsDisplay_TF resdisp_tf)
    {
        MLStructure struct = resdisp_tf.getJMatData();
        return struct;
    }
  
}
