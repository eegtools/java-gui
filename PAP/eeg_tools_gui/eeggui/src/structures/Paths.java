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
    public String spm;
    public String eeglab;
    public String brainstorm;
    
    public Paths(){}

    public void setJMatData(MLStructure struct)
    {
        project  = getString(struct, "project");
        original_data  = getString(struct, "original_data");
        input_epochs  = getString(struct, "input_epochs");
        output_epochs  = getString(struct, "output_epochs");
        results  = getString(struct, "results");
        emg_epochs  = getString(struct, "emg_epochs");
        emg_epochs_mat  = getString(struct, "emg_epochs_mat");
        tf  = getString(struct, "tf");
        cluster_projection_erp  = getString(struct, "cluster_projection_erp");
        batches  = getString(struct, "batches");
        spmsources  = getString(struct, "spmsources");
        spmstats  = getString(struct, "spmstats");
        spm  = getString(struct, "spm");
        eeglab  = getString(struct, "eeglab");
        brainstorm  = getString(struct, "brainstorm");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("project",setString(project));
        struct.setField("original_data",setString(original_data));
        struct.setField("input_epochs",setString(input_epochs));
        struct.setField("output_epochs",setString(output_epochs));
        struct.setField("results",setString(results));
        struct.setField("emg_epochs",setString(emg_epochs));
        struct.setField("emg_epochs_mat",setString(emg_epochs_mat));
        struct.setField("tf",setString(tf));
        struct.setField("cluster_projection_erp",setString(cluster_projection_erp));
        struct.setField("batches",setString(batches));
        struct.setField("spmsources",setString(spmsources));
        struct.setField("spmstats",setString(spmstats));
        struct.setField("spm",setString(spm));
        struct.setField("eeglab",setString(eeglab));
        struct.setField("brainstorm",setString(brainstorm));
 
        return struct;
    }
  
    
    
  
}
