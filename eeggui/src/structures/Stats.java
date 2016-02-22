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
public class Stats extends JMatlabStructWrapper{
    
    public double[] pvalue;
    public double[] num_permutations;
    public double[] num_tails;
    
    public Eeglab eeglab;
    
    
    public Stats(){}
    
    public void setJMatData(MLStructure struct)
    {
        pvalue              = getDoubleArray(struct, "pvalue");
        num_permutations    = getDoubleArray(struct, "num_permutations");
        num_tails           = getDoubleArray(struct, "num_tails");
        
        eeglab              = readEeglab(struct, "eeglab");
    }    
     
    private Eeglab readEeglab(MLStructure eeg, String field)
    {
        MLStructure eegs = (MLStructure) eeg.getField(field);
        Eeglab vec_eeg = new Eeglab();
        vec_eeg.setJMatData(eegs);
        return vec_eeg;
    }
    
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("pvalue", setDoubleColumnArray(pvalue));
        struct.setField("num_permutations", setDoubleColumnArray(num_permutations));
        struct.setField("num_tails", setDoubleColumnArray(num_tails));
        
        struct.setField("eeglab", writeEeglab(eeglab));

        return struct;
    }
    
    private MLStructure writeEeglab(Eeglab eeglab)
    {
        MLStructure struct = eeglab.getJMatData();
        return struct;
    }

}
