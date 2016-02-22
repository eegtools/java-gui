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
public class FrequencyBands extends JMatlabStructWrapper{
    
    String name;
    String ref_roi_list;
    String ref_roi_name;
    String ref_cond;
    String ref_tw_name;
    String which_realign_measure;
    
    double[] min;
    double[] max;
    double[] dfmin;
    double[] dfmax;
    double[] ref_tw_list;
    
    public FrequencyBands(){}
    
    public void setJMatData(MLStructure struct)
    {
       name                     = getString(struct, "name");
       ref_roi_list             = getString(struct, "ref_roi_list");
       ref_roi_name             = getString(struct, "ref_roi_name");
       ref_cond                 = getString(struct, "ref_cond");
       ref_tw_name              = getString(struct, "ref_tw_name");
       which_realign_measure    = getString(struct, "which_realign_measure");
       
       min          = getDoubleArray(struct, "min");
       max          = getDoubleArray(struct, "max");
       dfmin        = getDoubleArray(struct, "dfmin");
       dfmax        = getDoubleArray(struct, "dfmax");
       ref_tw_list  = getDoubleArray(struct, "ref_tw_list");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("name",setString(name));
        struct.setField("ref_roi_list",setString(ref_roi_list));
        struct.setField("ref_roi_name",setString(ref_roi_name));
        struct.setField("ref_cond",setString(ref_cond));
        struct.setField("ref_tw_name",setString(ref_tw_name));
        struct.setField("which_realign_measure",setString(which_realign_measure));
        
        struct.setField("min",setDoubleColumnArray(min));
        struct.setField("max",setDoubleColumnArray(max));
        struct.setField("dfmin",setDoubleColumnArray(dfmin));
        struct.setField("dfmax",setDoubleColumnArray(dfmax));
        struct.setField("ref_tw_list",setDoubleColumnArray(ref_tw_list));

        return struct;
    }   
    
}
