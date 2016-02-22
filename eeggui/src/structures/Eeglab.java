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
public class Eeglab extends JMatlabStructWrapper{
    
    public String method;
    public String correction;
    
    public Eeglab(){}
    
    public void setJMatData(MLStructure eeglab)
    {
        method      = getString(eeglab, "method");
        correction  = getString(eeglab, "correction");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure eeglab = new MLStructure("stats",new int[] {1,1});
        
        eeglab.setField("method",setString(method));
        eeglab.setField("correction",setString(correction));

        return eeglab;
    }

    
}
