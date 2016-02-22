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
public class InsertTiming extends JMatlabStructWrapper{
    
    public String[] target_event_types;
    public Latency  delay;
    
    public InsertTiming(){}
    
    public void setJMatData(MLStructure marker)
    {
        target_event_types  = getStringCellArray(marker, "target_event_types");
        delay               = readLatency(marker, "delay");
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
        MLStructure struct = new MLStructure("XXX", new int[] {1,1});
        struct.setField("target_event_types", setStringLineArray(target_event_types));
        struct.setField("delay", writeLatency(delay));
        return struct;
    } 
    
    private MLStructure writeLatency(Latency latency)
    {
        MLStructure struct = latency.getJMatData();
        return struct;
    }
    
}
