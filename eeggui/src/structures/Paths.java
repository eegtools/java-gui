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

    public void setJMatData(MLStructure paths)
    {
        
        project  = getString(paths, "project");
        scripts  = getString(paths, "scripts");
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
        
        
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure paths = new MLStructure("paths",new int[] {1,1});
        
        paths.setField("project",setString(project));
        paths.setField("scripts",setString(scripts));
        paths.setField("original_data",setString(original_data));
        paths.setField("input_epochs",setString(input_epochs));
        paths.setField("output_epochs",setString(output_epochs));
        paths.setField("results",setString(results));
        paths.setField("emg_epochs",setString(emg_epochs));
        paths.setField("scripts",setString(emg_epochs_mat));
        paths.setField("original_data",setString(tf));
        paths.setField("input_epochs",setString(cluster_projection_erp));
        paths.setField("output_epochs",setString(batches));
        paths.setField("results",setString(spmsources));
        paths.setField("emg_epochs",setString(spmstats));
 
        return paths;
    }
  
    
    
  
}
