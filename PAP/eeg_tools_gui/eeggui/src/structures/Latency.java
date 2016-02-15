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
public class Latency extends JMatlabStructWrapper{
    
    public double s;
    public double ms;
    
    public Latency(){}
    
    public void setJMatDataS(MLStructure lat)
    {
        s   = getDouble(lat, "s");
        ms  = s*1000;
    } 
    public void setJMatDataMS(MLStructure lat)
    {
        ms  = getDouble(lat, "ms");
        s   = ms/1000;
    } 

    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX", new int[] {1,1});
        struct.setField("s",  setDouble(s));
        struct.setField("ms", setDouble(ms));
        return struct;
    } 
    
}
