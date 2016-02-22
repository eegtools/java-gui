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
public class StudyParams extends JMatlabStructWrapper{
    
    public Latency tmin_analysis;
    public Latency tmax_analysis;
    public Latency ts_analysis;
    public Latency timeout_analysis_interval;
    
    public String[] precompute_param;
    
    public StudyParams(){}
    
    public void setJMatData(MLStructure struct)
    {
        tmin_analysis               = readLatency(struct, "tmin_analysis");
        tmax_analysis               = readLatency(struct, "tmax_analysis");
        ts_analysis                 = readLatency(struct, "ts_analysis");
        timeout_analysis_interval   = readLatency(struct, "timeout_analysis_interval");
        
        precompute_param            = getStringCellArray(struct, "precompute_param");
    }    
    
    private Latency readLatency(MLStructure lat, String field)
    {
        MLStructure slat = (MLStructure) lat.getField(field);
        Latency vec_lat = new Latency();
        vec_lat.setJMatDataS(slat);
        return vec_lat;
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("tmin_analysis",writeLatency(tmin_analysis));
        struct.setField("tmax_analysis",writeLatency(tmax_analysis));
        struct.setField("ts_analysis",writeLatency(ts_analysis));
        struct.setField("timeout_analysis_interval",writeLatency(timeout_analysis_interval));
        
        struct.setField("precompute_param",setStringLineArray(precompute_param));
 
        return struct;
    }
    
    private MLStructure writeLatency(Latency latency)
    {
        MLStructure struct = latency.getJMatData();
        return struct;
    }
    
}
