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
public class Narrowband_ers_sta extends JMatlabStructWrapper{
    
    public double group_tmin;
    public double group_tmax;
    public double dfmin;
    public double dfmax;
    
    public String[] which_realign_measure;
    public String[] which_realign_param;
    
    public Narrowband_ers_sta()
    {
    }
    
    public Narrowband_ers_sta(MLStructure narrowband)
    {
        group_tmin              = getDouble(narrowband,"group_tmin");
        group_tmax              = getDouble(narrowband,"group_tmax");
        dfmin                   = getDouble(narrowband,"dfmin");
        dfmax                   = getDouble(narrowband,"dfmax");
        
        which_realign_measure   = getStringCellArray(narrowband,"which_realign_measure");
        which_realign_param   = getStringCellArray(narrowband,"which_realign_param");
    } 
    
}
