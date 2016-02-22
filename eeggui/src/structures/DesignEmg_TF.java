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
public class DesignEmg_TF extends JMatlabStructWrapper{

    public String[][] deflection_polarity_list;
    public double[] min_duration;
    
    public DesignEmg_TF(){}
    
    public void setJMatData(MLStructure struct)
    {
        deflection_polarity_list    = getStringCellMatrix(struct, "deflection_polarity_list");
        min_duration                = getDoubleArray(struct, "min_duration");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});

        struct.setField("deflection_polarity_list",setStringColumnCell(deflection_polarity_list));
        struct.setField("min_duration",setDoubleColumnArray(min_duration));

        return struct;
    }
    
}