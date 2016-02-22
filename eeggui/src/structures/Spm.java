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
public class Spm extends JMatlabStructWrapper{
    
    public StatsSpm stats;
    
    public Spm(){}
    
    public void setJMatData(MLStructure spm)
    {
       stats = readStatsSpm(spm,"stats");
    }
    
    private StatsSpm readStatsSpm(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        StatsSpm vec = new StatsSpm();
        vec.setJMatData(structs);
        return vec;
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});

        struct.setField("stats",writeStatsSpm(stats));
 
        return struct;
    }
    
    private MLStructure writeStatsSpm(StatsSpm stats_spm)
    {
        MLStructure struct = stats_spm.getJMatData();
        return struct;
    }
    
}
