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
public class Ersp_sta extends JMatlabStructWrapper{
    
    public double pvalue;
    
    public int num_permutations;
    public int num_tails;
    public int decimation_factor_times_tf;
    public int decimation_factor_freqs_tf;
    
    public String tf_resolution_mode;
    public String measure;
    public String do_narrowband;
    
    public Narrowband_ers_sta narrowband;
    
    public Ersp_sta()
    {
    }
    
    public Ersp_sta(MLStructure erspsta)
    {
        num_permutations            = getInt(erspsta, "num_permutations");
        num_tails                   = getInt(erspsta, "num_tails");
        decimation_factor_times_tf  = getInt(erspsta, "decimation_factor_times_tf");
        decimation_factor_freqs_tf  = getInt(erspsta, "decimation_factor_freqs_tf");
        
        tf_resolution_mode          = getString(erspsta, "tf_resolution_mode");
        measure                     = getString(erspsta, "measure");
        do_narrowband               = getString(erspsta, "do_narrowband");
        
        narrowband                  = getNarrowband_ers_sta(erspsta, "narrowband");
        
    } 
    
    public Narrowband_ers_sta getNarrowband_ers_sta(MLStructure narrowband, String field)
    {
        MLStructure Narrowband_ers_stas = (MLStructure) narrowband.getField(field);
        Narrowband_ers_sta vec = new Narrowband_ers_sta(Narrowband_ers_stas);
        return vec;
    }
    
    
}
