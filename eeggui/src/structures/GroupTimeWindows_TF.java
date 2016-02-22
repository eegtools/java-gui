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
public class GroupTimeWindows_TF extends JMatlabStructWrapper{
    
    String name;
    double[] min;
    double[] max;
    String[][] ref_roi;
    
    public GroupTimeWindows_TF(){}
    
    public void setJMatData(MLStructure struct)
    {
        name    = getString(struct, "name");
        min     = getDoubleArray(struct, "min");
        max     = getDoubleArray(struct, "max");
        ref_roi = getStringCellMatrix(struct, "ref_roi");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("name",setString(name));
        struct.setField("min",setDoubleColumnArray(min));
        struct.setField("max",setDoubleColumnArray(max));
        struct.setField("ref_roi",setStringLineCell(ref_roi));

        return struct;
    }   
}