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
public class ErpPostProc extends JMatlabStructWrapper{
    
    public String sel_extrema;
    
    public ErpPostProc(){}
    
    public void setJMatData(MLStructure struct)
    {
        sel_extrema = getString(struct, "sel_extrema");
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("sel_extrema",setString(sel_extrema));
        
        return struct;
    }
    
}
