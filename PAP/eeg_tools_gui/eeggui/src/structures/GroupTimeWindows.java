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
public class GroupTimeWindows extends JMatlabStructWrapper{
    
    String name;
    double[] min;
    double[] max;
    
    public GroupTimeWindows(){}
    
    public void setJMatData(MLStructure struct)
    {
        name    = getString(struct, "name");
        min     = getDoubleArray(struct, "min");
        max     = getDoubleArray(struct, "max");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("name",setString(name));
        struct.setField("min",setDoubleColumnArray(min));
        struct.setField("max",setDoubleColumnArray(max));

        return struct;
    }   
}
