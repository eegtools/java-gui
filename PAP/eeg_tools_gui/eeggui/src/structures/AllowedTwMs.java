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
public class AllowedTwMs extends JMatlabStructWrapper{
    
    public double[] min;    //double
    public double[] max;    //double
    
    public AllowedTwMs(){}
    
    public void setJMatData(MLStructure alltm)
    {
        min   = getDoubleArray(alltm, "min");
        max   = getDoubleArray(alltm, "max");
    } 

    public MLStructure getJMatData()
    {
        MLStructure alltm = new MLStructure("XXX", new int[] {1,1});
        alltm.setField("min", setDoubleColumnArray(min));
        alltm.setField("max", setDoubleColumnArray(max));
        return alltm;
    } 
    
}
