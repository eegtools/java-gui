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
public class Paths  extends JMatlabStructWrapper{
    
    public String project;
    public String scripts;
    public String original_data;
    public String input_epochs;
    public String output_epochs;
    public String results;
    public String emg_epochs;
    public String emg_epochs_mat;
    public String tf;
    public String cluster_projection_erp;
    public String batches;
    public String spmsources;
    public String spmstats;
    
    public Paths()
    {
    }

    public Paths(MLStructure pat)
    {
        
        project  = getString(pat, "project");
        scripts  = getString(pat, "scripts");
        original_data  = getString(pat, "original_data");
        input_epochs  = getString(pat, "input_epochs");
        output_epochs  = getString(pat, "output_epochs");
        results  = getString(pat, "results");
        emg_epochs  = getString(pat, "emg_epochs");
        emg_epochs_mat  = getString(pat, "emg_epochs_mat");
        tf  = getString(pat, "tf");
        cluster_projection_erp  = getString(pat, "cluster_projection_erp");
        batches  = getString(pat, "batches");
        spmsources  = getString(pat, "spmsources");
        spmstats  = getString(pat, "spmstats");
        
        
    }    
    
    
  
}
