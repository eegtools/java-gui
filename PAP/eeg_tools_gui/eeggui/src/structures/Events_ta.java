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
    
    public int start_experiment_trigger_value;
    public int pause_trigger_value  ;
    public int resume_trigger_value;
    public int end_experiment_trigger_value;
    public int videoend_trigger_value;
    public int question_trigger_value;
    public int AOCS_audio_trigger_value;
    public int AOIS_audio_trigger_value;
    public int cross_trigger_value;

    
    public Events_ta(MLStructure events)
    {
        
        start_experiment_trigger_value  = getInt(events,"start_experiment_trigger_value");
        pause_trigger_value             = getInt(events,"pause_trigger_value");
        resume_trigger_value            = getInt(events,"resume_trigger_value");
        end_experiment_trigger_value    = getInt(events,"end_experiment_trigger_value");
        videoend_trigger_value          = getInt(events,"videoend_trigger_value");
        question_trigger_value          = getInt(events,"question_trigger_value");
        AOCS_audio_trigger_value        = getInt(events,"AOCS_audio_trigger_value");
        AOIS_audio_trigger_value        = getInt(events,"AOIS_audio_trigger_value");
        cross_trigger_value             = getInt(events,"cross_trigger_value");
        
    }    
}
