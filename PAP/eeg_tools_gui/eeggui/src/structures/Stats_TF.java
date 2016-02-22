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
public class Stats_TF extends JMatlabStructWrapper{
    
    public ErspStats ersp;
    public EeglabStats eeglab;
    
    public Stats_TF(){}
     
    public void setJMatData(MLStructure struct)
    {
        ersp    = readErspStats(struct, "ersp");
        eeglab  = readEeglabStats(struct, "eeglab");
    }   
    
    private ErspStats readErspStats(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        ErspStats vec = new ErspStats();
        vec.setJMatData(structs);
        return vec;
    }
    
    private EeglabStats readEeglabStats(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        EeglabStats vec = new EeglabStats();
        vec.setJMatData(structs);
        return vec;
    }
    
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("ersp",writeErspStats(ersp));
        struct.setField("eeglab",writeEeglabStats(eeglab));
 
        return struct;
    }
    
    private MLStructure writeErspStats(ErspStats ersp_stats)
    {
        MLStructure struct = ersp_stats.getJMatData();
        return struct;
    }
    
    private MLStructure writeEeglabStats(EeglabStats eeglab_stats)
    {
        MLStructure struct = eeglab_stats.getJMatData();
        return struct;
    }
    
    
    
}
