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
public class Events extends JMatlabStructWrapper{
    
    public double[] start_experiment_trigger_value;   //double
    public double[] pause_trigger_value;              //double
    public double[] resume_trigger_value;             //double
    public double[] end_experiment_trigger_value;     //double
    
    public String baseline_start_trigger_value;
    public String baseline_end_trigger_value;
    public String trial_start_trigger_value;
    public String trial_end_trigger_value;
    
    public String[][] mrkcode_cond;
    public String[] valid_marker;
    public String[] import_marker;
    

    public Events(){} 
    
    public void setJMatData(MLStructure struct)
    {
        start_experiment_trigger_value  = getDoubleArray(struct,"start_experiment_trigger_value");
        pause_trigger_value             = getDoubleArray(struct,"pause_trigger_value");
        resume_trigger_value            = getDoubleArray(struct,"resume_trigger_value");
        end_experiment_trigger_value    = getDoubleArray(struct,"end_experiment_trigger_value");
        
        trial_end_trigger_value         = getString(struct,"trial_end_trigger_value");
        baseline_start_trigger_value    = getString(struct,"baseline_start_trigger_value");
        baseline_end_trigger_value      = getString(struct,"baseline_end_trigger_value");
        trial_start_trigger_value       = getString(struct,"trial_start_trigger_value");

        mrkcode_cond                    = getStringCellMatrix(struct,"mrkcode_cond");
        valid_marker                    = getStringCellArray(struct,"valid_marker");
        import_marker                   = getStringCellArray(struct,"import_marker");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("start_experiment_trigger_value",setDoubleColumnArray(start_experiment_trigger_value));
        struct.setField("pause_trigger_value",setDoubleColumnArray(pause_trigger_value));
        struct.setField("resume_trigger_value",setDoubleColumnArray(resume_trigger_value));
        struct.setField("end_experiment_trigger_value",setDoubleColumnArray(end_experiment_trigger_value));

        struct.setField("trial_end_trigger_value",setString(trial_end_trigger_value));
        struct.setField("baseline_start_trigger_value",setString(baseline_start_trigger_value));
        struct.setField("baseline_end_trigger_value",setString(baseline_end_trigger_value));
        struct.setField("trial_start_trigger_value",setString(trial_start_trigger_value));
        
        struct.setField("mrkcode_cond",setStringColLineCell(mrkcode_cond));
        struct.setField("valid_marker",setStringLineArray(valid_marker));
        struct.setField("import_marker",setStringLineArray(import_marker));

        return struct;
    }   
}
