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
public class BaselineReplace extends JMatlabStructWrapper{
    
    public String mode;
    public String baseline_originalposition;
    public String baseline_finalposition;
    public String replace;
    
    public BaselineReplace(){}
    
     public void setJMatData(MLStructure struct)
    {
        mode = getString(struct, "mode");
        baseline_originalposition = getString(struct, "baseline_originalposition");
        baseline_finalposition = getString(struct, "baseline_finalposition");
        replace = getString(struct, "replace");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("mode",setString(mode));
        struct.setField("baseline_originalposition",setString(baseline_originalposition));
        struct.setField("baseline_finalposition",setString(baseline_finalposition));
        struct.setField("replace",setString(replace));

        return struct;
    }
    
    
}
