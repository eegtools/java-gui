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
public class ConductorVolume extends JMatlabStructWrapper{
    
    public int type;
    public String surf_bem_file_name;
    public String vol_bem_file_name;
    public String bem_file_name;
    
    
    public ConductorVolume()
    {  
    }
    
    
    public ConductorVolume(MLStructure cond)
    {
        surf_bem_file_name  = getString(cond, "surf_bem_file_name");
        vol_bem_file_name  = getString(cond, "vol_bem_file_name");
        bem_file_name  = getString(cond, "bem_file_name");
        
        type  = getInt(cond, "type"); 
    } 
  
}
