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
public class StatsSpm extends JMatlabStructWrapper{
    
    public double[] pvalue;
    public String correction;
    
    public StatsSpm(){}
    
    public void setJMatData(MLStructure struct)
    {
       pvalue = getDoubleArray(struct,"pvalue");
       correction = getString(struct,"correction");
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("pvalue",setDoubleColumnArray(pvalue));
        struct.setField("correction",setString(correction));
 
        return struct;
    }
}
