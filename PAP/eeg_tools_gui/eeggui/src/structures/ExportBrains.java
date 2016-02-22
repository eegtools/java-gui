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
public class ExportBrains extends JMatlabStructWrapper{
    
    public double[] spm_vol_downsampling;
    public double[] spm_time_downsampling;
    
    public ExportBrains(){}

    
    public void setJMatData(MLStructure struct)
    {
        spm_vol_downsampling    = getDoubleArray(struct, "spm_vol_downsampling");
        spm_time_downsampling   = getDoubleArray(struct, "spm_time_downsampling");
    } 
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("spm_vol_downsampling",setDoubleColumnArray(spm_vol_downsampling));
        struct.setField("spm_time_downsampling",setDoubleColumnArray(spm_time_downsampling));
        
        return struct;
    }
    
}
