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
public class ErspStats extends JMatlabStructWrapper{
    
    public double[] pvalue;
    public double[] num_permutations;
    public double[] num_tails;
    public double[] decimation_factor_times_tf;
    public double[] decimation_factor_freqs_tf;
    
    public String tf_resolution_mode;
    public String measure;
    public String do_narrowband;
    
    public Narrowband narrowband;
    
    public ErspStats(){}
     
    public void setJMatData(MLStructure struct)
    {
        pvalue                      = getDoubleArray(struct,"pvalue");
        num_permutations            = getDoubleArray(struct,"num_permutations");
        num_tails                   = getDoubleArray(struct,"num_tails");
        decimation_factor_times_tf  = getDoubleArray(struct,"decimation_factor_times_tf");
        decimation_factor_freqs_tf  = getDoubleArray(struct,"decimation_factor_freqs_tf");
        
        tf_resolution_mode          = getString(struct,"tf_resolution_mode");
        measure                     = getString(struct,"measure");
        do_narrowband               = getString(struct,"do_narrowband");
        
        narrowband = readNarrowband(struct, "narrowband");
    }    
    
    private Narrowband readNarrowband(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        Narrowband vec = new Narrowband();
        vec.setJMatData(structs);
        return vec;
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("pvalue", setDoubleColumnArray(pvalue));
        struct.setField("num_permutations", setDoubleColumnArray(num_permutations));
        struct.setField("num_tails", setDoubleColumnArray(num_tails));
        struct.setField("decimation_factor_times_tf", setDoubleColumnArray(decimation_factor_times_tf));
        struct.setField("decimation_factor_freqs_tf", setDoubleColumnArray(decimation_factor_freqs_tf));
        
        struct.setField("tf_resolution_mode", setString(tf_resolution_mode));
        struct.setField("measure", setString(measure));
        struct.setField("do_narrowband", setString(do_narrowband));
        
        struct.setField("narrowband", writeNarrowband(narrowband));
 
        return struct;
    }
    
    private MLStructure writeNarrowband(Narrowband narrowband)
    {
        MLStructure struct = narrowband.getJMatData();
        return struct;
    }
}