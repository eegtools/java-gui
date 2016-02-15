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
    
    public Paths()
    {
    }

    public void setJMatData(MLStructure paths)
    {
        
        project  = getString(paths, "project");
        original_data  = getString(paths, "original_data");
        input_epochs  = getString(paths, "input_epochs");
        output_epochs  = getString(paths, "output_epochs");
        results  = getString(paths, "results");
        emg_epochs  = getString(paths, "emg_epochs");
        emg_epochs_mat  = getString(paths, "emg_epochs_mat");
        tf  = getString(paths, "tf");
        cluster_projection_erp  = getString(paths, "cluster_projection_erp");
        batches  = getString(paths, "batches");
        spmsources  = getString(paths, "spmsources");
        spmstats  = getString(paths, "spmstats");
        spm  = getString(paths, "spm");
        eeglab  = getString(paths, "eeglab");
        brainstorm  = getString(paths, "brainstorm");

    }    
    
    public MLStructure getJMatData()
    {
        MLStructure paths = new MLStructure("paths",new int[] {1,1});
        
        paths.setField("project",setString(project));
        paths.setField("original_data",setString(original_data));
        paths.setField("input_epochs",setString(input_epochs));
        paths.setField("output_epochs",setString(output_epochs));
        paths.setField("results",setString(results));
        paths.setField("emg_epochs",setString(emg_epochs));
        paths.setField("emg_epochs_mat",setString(emg_epochs_mat));
        paths.setField("tf",setString(tf));
        paths.setField("cluster_projection_erp",setString(cluster_projection_erp));
        paths.setField("batches",setString(batches));
        paths.setField("spmsources",setString(spmsources));
        paths.setField("spmstats",setString(spmstats));
        paths.setField("spm",setString(spm));
        paths.setField("eeglab",setString(eeglab));
        paths.setField("brainstorm",setString(brainstorm));
 
        return paths;
    }
  
    
    
  
}
