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
    
    public Latencysms epo_st;
    public Latencysms epo_end;
    public Latencysms bc_st;
    public Latencysms bc_end;
    
    public Latencys emg_epo_st;
    public Latencys emg_epo_end;
    public Latencys emg_bc_st;
    public Latencys emg_bc_end;
    
    public int bc_st_point;
    public int bc_end_point;
    public int emg_bc_st_point;
    public int emg_bc_end_point;
    
    public int numcond;
    public String[][] mrkcode_cond;
    public String[] valid_marker;
    public String[] condition_names;
    
    public Epoching()
    {
        
    }
    
    public void setJMatData(MLStructure epoc)
    {
        input_folder        = getString(epoc, "input_folder");
        input_suffix        = getString(epoc, "input_suffix");
        input_epochs_folder = getString(epoc, "input_epochs_folder");
        bc_type             = getString(epoc, "bc_type");
        
        epo_st              = getLatencysms(epoc, "epo_st");
        epo_end             = getLatencysms(epoc, "epo_end");
        bc_st               = getLatencysms(epoc, "bc_st");
        bc_end              = getLatencysms(epoc, "bc_end");
        
        emg_epo_st          = getLatencys(epoc, "emg_epo_st");
        emg_epo_end         = getLatencys(epoc, "emg_epo_end");
        emg_bc_st           = getLatencys(epoc, "emg_bc_st");
        emg_bc_end          = getLatencys(epoc, "emg_bc_end");

        bc_st_point         = getInt(epoc, "bc_st_point");
        bc_end_point        = getInt(epoc, "bc_end_point");
        emg_bc_st_point     = getInt(epoc, "emg_bc_st_point");
        emg_bc_end_point    = getInt(epoc, "emg_bc_end_point");
        numcond             = getInt(epoc, "numcond");

        mrkcode_cond        = getStringCellMatrix(epoc, "mrkcode_cond");
        
        valid_marker        = getStringCellArray(epoc, "valid_marker");
        condition_names     = getStringCellArray(epoc, "condition_names"); 
    }
  
    public MLStructure getJMatData()
    {
        MLStructure epoc = new MLStructure("epoc",new int[] {1,1});
        
        return epoc;
    }
    
    public Latencysms getLatencysms(MLStructure epoc, String field)
    {
        MLStructure epos = (MLStructure) epoc.getField(field);
        Latencysms vec = new Latencysms(epos);
        return vec;
    }
    
    public Latencys getLatencys(MLStructure epoc, String field)
    {
        MLStructure epos = (MLStructure) epoc.getField(field);
        Latencys vec = new Latencys(epos);
        return vec;
    }
    

}
