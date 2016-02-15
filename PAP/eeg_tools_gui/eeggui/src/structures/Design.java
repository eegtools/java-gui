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
    
    public String[] factor1_level;
    public String[] factor2_level;
    
    public String factor1_pairing;
    public String factor2_pairing;
    
    public Design(){}
    
    public Design(MLStructure dess)
    {
        name                = getString(dess, "name");
        factor1_name        = getString(dess, "factor1_name");
        factor2_name        = getString(dess, "factor2_name");
        factor1_pairing     = getString(dess, "factor1_pairing");
        factor2_pairing     = getString(dess, "factor2_pairing");

        factor1_level       = getStringCellArray(dess, "factor1_level");
        factor2_level       = getStringCellArray(dess, "factor2_level"); 
    } 
}
