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
public class Erp extends JMatlabStructWrapper{
    
    public StudyParams study_params;
    public Stats stats;
    public Postprocess postprocess;
    public ResultsDisplay results_display;
    
    public Erp(){}
    
    public void setJMatData(MLStructure erp)
    {
        study_params    = readStudyParams(erp, "study_params");
        stats           = readStats(erp, "stats");
        postprocess     = readPostprocess(erp, "postprocess");
        results_display = readResultsDisplay(erp, "results_display");
    }    
    
    private StudyParams readStudyParams(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        StudyParams vec = new StudyParams();
        vec.setJMatData(structs);
        return vec;
    }
    
    private Stats readStats(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        Stats vec = new Stats();
        vec.setJMatData(structs);
        return vec;
    }
    
    private Postprocess readPostprocess(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        Postprocess vec = new Postprocess();
        vec.setJMatData(structs);
        return vec;
    }
    
    private ResultsDisplay readResultsDisplay(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        ResultsDisplay vec = new ResultsDisplay();
        vec.setJMatData(structs);
        return vec;
    }

    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});

        struct.setField("study_params",writeStudyParams(study_params));
        struct.setField("stats",writeStats(stats));
        struct.setField("postprocess",writePostprocess(postprocess));
        struct.setField("results_display",writeResultsDisplay(results_display));
 
        return struct;
    }
    
    private MLStructure writeStudyParams(StudyParams study_params)
    {
        MLStructure struct = study_params.getJMatData();
        return struct;
    }
    
    private MLStructure writeStats(Stats stats)
    {
        MLStructure struct = stats.getJMatData();
        return struct;
    }
    
    private MLStructure writePostprocess(Postprocess postprocess)
    {
        MLStructure struct = postprocess.getJMatData();
        return struct;
    }
    
    private MLStructure writeResultsDisplay(ResultsDisplay results_display)
    {
        MLStructure struct = results_display.getJMatData();
        return struct;
    }
}
