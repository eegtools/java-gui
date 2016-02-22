/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.*;

/**
 *
 * @author PHilt
 */
public class StatsBrains extends JMatlabStructWrapper{
    
    double[] ttest_abstype;
    double[] pvalue;
    public String correction;
    
    public StatsBrains(){}
    
    public void setJMatData(MLStructure struct)
    {
        ttest_abstype   = getDoubleArray(struct, "ttest_abstype");
        pvalue          = getDoubleArray(struct, "pvalue");
        correction      = getString(struct, "correction");
    }
    
     public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("ttest_abstype",setDoubleColumnArray(ttest_abstype));
        struct.setField("pvalue",setDoubleColumnArray(pvalue));
        
        struct.setField("correction",setString(correction));
        
        return struct;
    }
    
    
}
