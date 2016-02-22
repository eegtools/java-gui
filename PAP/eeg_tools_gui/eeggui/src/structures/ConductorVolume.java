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
    
    public double[] type;
    public String surf_bem_file_name;
    public String vol_bem_file_name;
    public String bem_file_name;
    
    
    public ConductorVolume(){}
    
    
    public void setJMatData(MLStructure struct)
    {
        surf_bem_file_name  = getString(struct, "surf_bem_file_name");
        vol_bem_file_name   = getString(struct, "vol_bem_file_name");
        bem_file_name       = getString(struct, "bem_file_name");
        type                = getDoubleArray(struct, "type"); 
    } 
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("surf_bem_file_name",setString(surf_bem_file_name));
        struct.setField("vol_bem_file_name",setString(vol_bem_file_name));
        struct.setField("bem_file_name",setString(bem_file_name));
        struct.setField("type",setDoubleColumnArray(type));
 
        return struct;
    }
  
}
