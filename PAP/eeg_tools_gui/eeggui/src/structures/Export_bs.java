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
public class Export_bs extends JMatlabStructWrapper{
    
    public int spm_vol_downsampling;
    public int spm_time_downsampling;
    
    public Export_bs()
    {  
    }
    
    
    public Export_bs(MLStructure exp_bs)
    {
        spm_vol_downsampling  = getInt(exp_bs, "spm_vol_downsampling");
        spm_time_downsampling  = getInt(exp_bs, "spm_time_downsampling");
    } 
    
}
