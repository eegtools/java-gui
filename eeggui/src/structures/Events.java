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
    
    public String start_experiment_trigger_value;
    public String pause_trigger_value  ;
    public String resume_trigger_value;
    public String end_experiment_trigger_value;

    public String[][] mrkcode_cond; 
    
    public Events(MLStructure events)
    {
        mrkcode_cond = getStringCellMatrix(events, "mrkcode_cond");
    }    
}
