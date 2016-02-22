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
public class Narrowband extends JMatlabStructWrapper{
    
    public double[] group_tmin;
    public double[] group_tmax;
    public double[] dfmin;
    public double[] dfmax;
    
    public String[] which_realign_measure;
    public String[] which_realign_param;
    
    public Narrowband(){}
    
    public void setJMatData(MLStructure struct)
    {
        group_tmin              = getDoubleArray(struct,"group_tmin");
        group_tmax              = getDoubleArray(struct,"group_tmax");
        dfmin                   = getDoubleArray(struct,"dfmin");
        dfmax                   = getDoubleArray(struct,"dfmax");
        
        which_realign_measure   = getStringCellArray(struct,"which_realign_measure");
        which_realign_param     = getStringCellArray(struct,"which_realign_param");
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("group_tmin", setDoubleColumnArray(group_tmin)); 
        struct.setField("group_tmax", setDoubleColumnArray(group_tmax));
        struct.setField("dfmin", setDoubleColumnArray(dfmin));
        struct.setField("dfmax", setDoubleColumnArray(dfmax));
        
        struct.setField("which_realign_measure", setStringLineArray(which_realign_measure));
        struct.setField("which_realign_param", setStringLineArray(which_realign_param));
 
        return struct;
    }
    
}
