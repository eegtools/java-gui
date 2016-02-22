/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.MLArray;
import com.jmatio.types.MLStructure;
import java.util.Map;

/**
 *
 * @author PHilt
 */
public class Design extends JMatlabStructWrapper{
    
    public String name;
    public String factor1_name;
    public String factor2_name;
    
    public String[] factor1_levels;
    public String[] factor2_levels;
    
    public String factor1_pairing;
    public String factor2_pairing;
    
    public Design(){}
    
    public void setJMatData(MLStructure struct)
    {
        name                = getString(struct, "name");
        factor1_name        = getString(struct, "factor1_name");
        factor2_name        = getString(struct, "factor2_name");
        factor1_pairing     = getString(struct, "factor1_pairing");
        factor2_pairing     = getString(struct, "factor2_pairing");

        factor1_levels       = getStringCellArray(struct, "factor1_levels");
        factor2_levels       = getStringCellArray(struct, "factor2_levels"); 
    } 
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("name",setString(name));
        struct.setField("factor1_name",setString(factor1_name));
        struct.setField("factor2_name",setString(factor2_name));
        struct.setField("factor1_pairing",setString(factor1_pairing));
        struct.setField("factor2_pairing",setString(factor2_pairing));

        struct.setField("factor1_levels",setStringLineArray(factor1_levels));
        struct.setField("factor2_levels",setStringLineArray(factor2_levels));

        return struct;
    }
    
}
