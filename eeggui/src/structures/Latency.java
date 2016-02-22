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
    
    public double[] s;
    public double[] ms;
    
    public Latency(){}

    public void setJMatDataS(MLStructure lat)
    {
        s   = getDoubleArray(lat, "s");
        double[] tmp_ms = new double[s.length];
        for (int m = 0; m < s.length; m++) 
        {
            tmp_ms[m]  = s[m]*1000;
        }
        ms = tmp_ms;
    } 
    public void setJMatDataMS(MLStructure lat)
    {
        ms  = getDoubleArray(lat, "ms");
        double[] tmp_s = new double[ms.length];
        for (int m = 0; m < ms.length; m++) 
        {
            tmp_s[m]  = ms[m]*1000;
        }
        s = tmp_s;
    } 

    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX", new int[] {1,1});
        struct.setField("s",  setDoubleLineArray(s));
        struct.setField("ms", setDoubleLineArray(ms));
        return struct;
    } 
    
}
