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
public class EeglabStats extends JMatlabStructWrapper{
    
    public ErspEeglab ersp;
    
    public EeglabStats(){}
     
    public void setJMatData(MLStructure struct)
    {
        ersp = readErspEeglab(struct, "ersp");
    }    
    
    private ErspEeglab readErspEeglab(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        ErspEeglab vec = new ErspEeglab();
        vec.setJMatData(structs);
        return vec;
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});

        struct.setField("ersp",writeErspEeglab(ersp));
        
        return struct;
    }
    
    private MLStructure writeErspEeglab(ErspEeglab ersp_eeglab)
    {
        MLStructure struct = ersp_eeglab.getJMatData();
        return struct;
    }
    
}
