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
public class Events_ta extends JMatlabStructWrapper{
    
    public String start_experiment_trigger_value;
    public String pause_trigger_value;
    public String resume_trigger_value;
    public String end_experiment_trigger_value;
    public String trial_end_trigger_value;
    public String videoend_trigger_value;
    public String question_trigger_value;
    public String AOCS_audio_trigger_value;
    public String AOIS_audio_trigger_value;
    
    public String baseline_start_trigger_value;
    public String baseline_end_trigger_value;
    public String trial_start_trigger_value;
    public String preAOCS_audio_trigger_value;
    public String preAOIS_audio_trigger_value;
    public String preAO_audio_trigger_equiv_value;
    public String AO_audio_trigger_equiv_value;
    
    public String[] mrkcode_cond;
    public String[][] mrkcode_movement_start;
    
    public double[] valid_marker;
    public double[] import_marker;
    

    public Events_ta()
    {
    } 
    
    public void setJMatData(MLStructure events)
    {
        start_experiment_trigger_value  = getString(events,"start_experiment_trigger_value");
        pause_trigger_value             = getString(events,"pause_trigger_value");
        resume_trigger_value            = getString(events,"resume_trigger_value");
        end_experiment_trigger_value    = getString(events,"end_experiment_trigger_value");
        trial_end_trigger_value         = getString(events,"trial_end_trigger_value");
        videoend_trigger_value          = getString(events,"videoend_trigger_value");
        question_trigger_value          = getString(events,"question_trigger_value");
        AOCS_audio_trigger_value        = getString(events,"AOCS_audio_trigger_value");
        AOIS_audio_trigger_value        = getString(events,"AOIS_audio_trigger_value");
        
        baseline_start_trigger_value    = getString(events,"baseline_start_trigger_value");
        baseline_end_trigger_value      = getString(events,"baseline_end_trigger_value");
        trial_start_trigger_value       = getString(events,"trial_start_trigger_value");
        preAOCS_audio_trigger_value     = getString(events,"preAOCS_audio_trigger_value");
        preAOIS_audio_trigger_value     = getString(events,"preAOIS_audio_trigger_value");
        preAO_audio_trigger_equiv_value = getString(events,"preAO_audio_trigger_equiv_value");
        AO_audio_trigger_equiv_value    = getString(events,"AO_audio_trigger_equiv_value");

        //mrkcode_cond                    = getStringCellArray(events,"mrkcode_cond");
        mrkcode_movement_start          = getStringCellMatrix(events,"mrkcode_movement_start");
        
        //valid_marker                    = getDoubleArray(events,"valid_marker");
        //import_marker                   = getDoubleArray(events,"import_marker");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure events = new MLStructure("events",new int[] {1,1});
        
        events.setField("start_experiment_trigger_value",setString(start_experiment_trigger_value));
        events.setField("pause_trigger_value",setString(pause_trigger_value));
        events.setField("resume_trigger_value",setString(resume_trigger_value));
        events.setField("end_experiment_trigger_value",setString(end_experiment_trigger_value));
        events.setField("videoend_trigger_value",setString(videoend_trigger_value));
        events.setField("question_trigger_value",setString(question_trigger_value));
        events.setField("AOCS_audio_trigger_value",setString(AOCS_audio_trigger_value));
        events.setField("AOIS_audio_trigger_value",setString(AOIS_audio_trigger_value));

        events.setField("baseline_start_trigger_value",setString(baseline_start_trigger_value));
        events.setField("baseline_end_trigger_value",setString(baseline_end_trigger_value));
        events.setField("trial_start_trigger_value",setString(trial_start_trigger_value));
        events.setField("preAOCS_audio_trigger_value",setString(preAOCS_audio_trigger_value));
        events.setField("preAOIS_audio_trigger_value",setString(preAOIS_audio_trigger_value));
        events.setField("preAO_audio_trigger_equiv_value",setString(preAO_audio_trigger_equiv_value));
        events.setField("AO_audio_trigger_equiv_value",setString(AO_audio_trigger_equiv_value));
        
        //events.setField("mrkcode_cond",setStringColumnArray(mrkcode_cond));
        events.setField("mrkcode_movement_start",setStringColLineCell(mrkcode_movement_start));
        
        //events.setField("valid_marker",setDoubleColumnArray(valid_marker));
        //events.setField("import_marker",setDoubleColumnArray(import_marker));

        return events;
    }   
}
