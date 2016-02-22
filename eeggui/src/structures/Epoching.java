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
    
    public BaselineReplace baseline_replace;
    
    public String input_suffix;
    public String input_folder;
    public String bc_type;
    
    public Latency epo_st;
    public Latency epo_end;
    public Latency bc_st;
    public Latency bc_end;
    
    public Latency emg_epo_st; //just s
    public Latency emg_epo_end; //just s
    public Latency emg_bc_st; //just s
    public Latency emg_bc_end; //just s
    
    public double[] bc_st_point;        //int
    public double[] bc_end_point;       //int
    public double[] emg_bc_st_point;    //int
    public double[] emg_bc_end_point;   //int
    public double[] numcond;            //int
    
    public String[][] mrkcode_cond;
    public String[] valid_marker;
    public String[] condition_names;
    
    public Epoching(){}
    
    public void setJMatData(MLStructure struct)
    {
        baseline_replace    = readBaselineReplace(struct, "baseline_replace");
                
        input_folder        = getString(struct, "input_folder");
        input_suffix        = getString(struct, "input_suffix");
        bc_type             = getString(struct, "bc_type");
        
        epo_st              = readLatency(struct, "epo_st");
        epo_end             = readLatency(struct, "epo_end");
        bc_st               = readLatency(struct, "bc_st");
        bc_end              = readLatency(struct, "bc_end");
        
        emg_epo_st          = readLatency(struct, "emg_epo_st");
        emg_epo_end         = readLatency(struct, "emg_epo_end");
        emg_bc_st           = readLatency(struct, "emg_bc_st");
        emg_bc_end          = readLatency(struct, "emg_bc_end");

        bc_st_point         = getDoubleArray(struct, "bc_st_point");
        bc_end_point        = getDoubleArray(struct, "bc_end_point");
        emg_bc_st_point     = getDoubleArray(struct, "emg_bc_st_point");
        emg_bc_end_point    = getDoubleArray(struct, "emg_bc_end_point");
        numcond             = getDoubleArray(struct, "numcond");

        mrkcode_cond        = getStringCellMatrix(struct, "mrkcode_cond");
        
        valid_marker        = getStringCellArray(struct, "valid_marker");
        condition_names     = getStringCellArray(struct, "condition_names"); 
    }
    
    private Latency readLatency(MLStructure lat, String field)
    {
        MLStructure slat = (MLStructure) lat.getField(field);
        Latency vec_lat = new Latency();
        vec_lat.setJMatDataS(slat);
        return vec_lat;
    }
    
    private BaselineReplace readBaselineReplace(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        BaselineReplace vec = new BaselineReplace();
        vec.setJMatData(structs);
        return vec;
    }
  
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("baseline_replace",writeBaselineReplace(baseline_replace));
        
        struct.setField("input_folder",setString(input_folder));
        struct.setField("input_suffix",setString(input_suffix));
        struct.setField("bc_type",setString(bc_type));
        
        struct.setField("epo_st",writeLatency(epo_st));
        struct.setField("epo_end",writeLatency(epo_end));
        struct.setField("bc_st",writeLatency(bc_st));
        struct.setField("bc_end",writeLatency(bc_end));
        
        struct.setField("emg_epo_st",writeLatency(emg_epo_st));
        struct.setField("emg_epo_end",writeLatency(emg_epo_end));
        struct.setField("emg_bc_st",writeLatency(emg_bc_st));
        struct.setField("emg_bc_end",writeLatency(emg_bc_end));
        
        struct.setField("bc_st_point",setDoubleColumnArray(bc_st_point));
        struct.setField("bc_end_point",setDoubleColumnArray(bc_end_point));
        struct.setField("emg_bc_st_point",setDoubleColumnArray(emg_bc_st_point));
        struct.setField("emg_bc_end_point",setDoubleColumnArray(emg_bc_end_point));
        struct.setField("numcond",setDoubleColumnArray(numcond));
        
        struct.setField("mrkcode_cond",setStringColLineCell(mrkcode_cond));
        
        struct.setField("valid_marker",setStringLineArray(valid_marker));
        struct.setField("condition_names",setStringLineArray(condition_names));
        
        return struct;
    }
    
    private MLStructure writeLatency(Latency latency)
    {
        MLStructure struct = latency.getJMatData();
        return struct;
    }
    
    private MLStructure writeBaselineReplace(BaselineReplace baseline_replace)
    {
        MLStructure struct = baseline_replace.getJMatData();
        return struct;
    }
    
}
