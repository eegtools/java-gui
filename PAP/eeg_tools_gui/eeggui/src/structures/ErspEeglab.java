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
public class ErspEeglab extends JMatlabStructWrapper{
    
    public String method;
    public String correction;
    
    public ErspEeglab(){}
    
    public void setJMatData(MLStructure struct)
    {
        method      = getString(struct,"method");
        correction  = getString(struct,"correction");
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("method", setString(method));
        struct.setField("correction", setString(correction));
 
        return struct;
    }
    
}
