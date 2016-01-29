/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.MLStructure;

/**
 *
 * @author alba
 */
public class Epoching extends JMatlabStructWrapper{
    
    public String input_folder;
    public String input_suffix;
    public String input_epochs_folder;
    public String bc_type;
    
    public Latency epo_st;
    public Latency epo_end;
    public Latency bc_st;
    public Latency bc_end;
    public Latency emg_epo_st;
    public Latency emg_epo_end;
    public Latency emg_bc_st;
    public Latency emg_bc_end;
    
    public int bc_st_point;
    public int bc_end_point;
    public int emg_bc_st_point;
    public int emg_bc_end_point;
    
    public int numcond;
    public String[] mrkcode_cond;
    public String[] valid_marker;
    public String[] condition_names;
    
    public Epoching()
    {
        
    }
    
    
    public Epoching(MLStructure epoc)
    {
        input_folder        = getString(epoc, "input_folder");
        input_suffix        = getString(epoc, "input_suffix");
        input_epochs_folder = getString(epoc, "input_epochs_folder");
        bc_type             = getString(epoc, "bc_type");
        
        epo_st              = getLatency(epoc, "epo_st");
        epo_end             = getLatency(epoc, "epo_end");
        bc_st               = getLatency(epoc, "bc_st");
        bc_end              = getLatency(epoc, "bc_end");
        emg_epo_st          = getLatency(epoc, "emg_epo_st");
        emg_epo_end         = getLatency(epoc, "emg_epo_end");
        emg_bc_st           = getLatency(epoc, "emg_bc_st");
        emg_bc_end          = getLatency(epoc, "emg_bc_end");

        bc_st_point         = getInt(epoc, "bc_st_point");
        bc_end_point        = getInt(epoc, "bc_end_point");
        emg_bc_st_point     = getInt(epoc, "emg_bc_st_point");
        emg_bc_end_point    = getInt(epoc, "emg_bc_end_point");
        numcond             = getInt(epoc, "numcond");

        mrkcode_cond        = getStringCellArray(epoc, "mrkcode_cond");
        valid_marker        = getStringCellArray(epoc, "valid_marker");
        condition_names     = getStringCellArray(epoc, "condition_names");  
    } 
    
    
    public Latency getLatency(MLStructure epoc, String field)
    {
        MLStructure epos = (MLStructure) epoc.getField(field);
        Latency vec = new Latency(epos);
        return vec;
    }
    

}
