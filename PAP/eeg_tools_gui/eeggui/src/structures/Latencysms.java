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
public class Latencysms  extends JMatlabStructWrapper{
    
    public double s;
    public double ms;
    
    public Latencysms()
    {
        
    }
    
    
    public Latencysms(MLStructure lat)
    {
        s   = getDouble(lat, "s");
        ms  = getDouble(lat, "ms"); 
    } 
    
}
