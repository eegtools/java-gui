/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

/**
 *
 * @author PHilt
 */
 

import com.jmatio.types.MLStructure;

public class SubjectTimeWindows extends JMatlabStructWrapper{

    double[] min;
    double[] max;
    
    public SubjectTimeWindows(){}
    
    public void setJMatData(MLStructure struct)
    {
        min     = getDoubleArray(struct, "min");
        max     = getDoubleArray(struct, "max");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});

        struct.setField("min",setDoubleColumnArray(min));
        struct.setField("max",setDoubleColumnArray(max));

        return struct;
    }  
}