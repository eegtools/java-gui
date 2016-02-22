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
public class Factors  extends JMatlabStructWrapper{

    public String factor;
    public String level;
    public String[] file_match;
    
    public Factors(){}
    
    public void setJMatData(MLStructure struct)
    {    
        factor      = getString(struct, "factor");
        level       = getString(struct, "level");
        file_match  = getStringCellArray(struct, "file_match");
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("factor",setString(factor));
        struct.setField("level",setString(level));

        struct.setField("file_match",setStringLineArray(file_match));

        return struct;
    }
    
}
