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
public class Latency  extends JMatlabStructWrapper{
    
    public double s;
    public double ms;
    
    public Latency()
    {
        
    }
    
    
    public Latency(MLStructure lat)
    {
        s   = getDouble(lat, "s");
        ms  = getDouble(lat, "ms"); 
    } 

    
    public Latency getLatency(MLStructure lat)
    {
        Latency vec; 
        vec = new Latency(lat);
        return vec;
    }

    
}
