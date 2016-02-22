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
public class Tw extends JMatlabStructWrapper{
    
    public String time_resolution_mode;
    public String peak_type;
    public String align;
    public String tw_stat_estimator;
    
    public Tw(){}
    
    public void setJMatData(MLStructure struct)
    {
        time_resolution_mode    = getString(struct, "time_resolution_mode");
        peak_type               = getString(struct, "peak_type");
        align                   = getString(struct, "align");
        tw_stat_estimator       = getString(struct, "tw_stat_estimator");
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("time_resolution_mode",setString(time_resolution_mode));
        struct.setField("peak_type",setString(peak_type));
        struct.setField("align",setString(align));
        struct.setField("tw_stat_estimator",setString(tw_stat_estimator));

        return struct;
    }
    
}



