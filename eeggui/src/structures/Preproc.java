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
public class Preproc extends JMatlabStructWrapper{
    
    public String output_folder;
    public String filter_algorithm;
    
    public double[] ff1_global;     //double
    public double[] ff2_global;     //double
    
    public double[] do_notch;       //int
    public double[] notch_fcenter;  //int
    public double[] notch_fspan;    //int
    public String notch_remove_armonics;

    public double[] ff1_eeg;        //double
    public double[] ff2_eeg;        //int
    public double[] ff1_eog;        //double
    public double[] ff2_eog;        //int
    public double[] ff1_emg;        //int
    public double[] ff2_emg;        //int
    
    public String[][] montage_list;
    
    public Rt rt;
    public InsertBlock insert_block;
    public MarkerType marker_type;
    public InsertTiming insert_begin_trial;
    public InsertTiming insert_end_trial;
    public InsertTiming insert_begin_baseline;
    public InsertTiming insert_end_baseline;
    
    public Preproc(){}
    
    public void setJMatData(MLStructure prep)
    {
        output_folder           = getString(prep, "output_folder");
        filter_algorithm        = getString(prep, "filter_algorithm");
        notch_remove_armonics   = getString(prep, "notch_remove_armonics");
        
        ff1_global          = getDoubleArray(prep, "ff1_global");
        ff2_global          = getDoubleArray(prep, "ff2_global");    
        do_notch            = getDoubleArray(prep, "do_notch");    
        notch_fcenter       = getDoubleArray(prep, "notch_fcenter");    
        notch_fspan         = getDoubleArray(prep, "notch_fspan");    
        ff1_eeg             = getDoubleArray(prep, "ff1_eeg");    
        ff2_eeg             = getDoubleArray(prep, "ff2_eeg");      
        ff1_eog             = getDoubleArray(prep, "ff1_eog");    
        ff2_eog             = getDoubleArray(prep, "ff2_eog");     
        ff1_emg             = getDoubleArray(prep, "ff1_emg");    
        ff2_emg             = getDoubleArray(prep, "ff2_emg"); 
        
        montage_list        = getStringCellMatrix_DiffSizes(prep, "montage_list");
        
        rt                      = readRt(prep, "rt");
        insert_block            = readInsertBlock(prep, "insert_block");
        marker_type             = readMarkerType(prep, "marker_type");
        insert_begin_trial      = readInsertTiming(prep, "insert_begin_trial");
        insert_end_trial        = readInsertTiming(prep, "insert_end_trial");
        insert_begin_baseline   = readInsertTiming(prep, "insert_begin_baseline");
        insert_end_baseline     = readInsertTiming(prep, "insert_end_baseline");
    }
    
    private Rt readRt(MLStructure rt, String field)
    {
        MLStructure srt = (MLStructure) rt.getField(field);
        Rt vec_rt = new Rt();
        vec_rt.setJMatData(srt);
        return vec_rt;
    }
    
    private InsertBlock readInsertBlock(MLStructure block, String field)
    {
        MLStructure sblock = (MLStructure) block.getField(field);
        InsertBlock vec_block = new InsertBlock();
        vec_block.setJMatData(sblock);
        return vec_block;
    }
    
    private MarkerType readMarkerType(MLStructure markertype, String field)
    {
        MLStructure smarkertype = (MLStructure) markertype.getField(field);
        MarkerType vec_markertype = new MarkerType();
        vec_markertype.setJMatData(smarkertype);
        return vec_markertype;
    }
    
    private InsertTiming readInsertTiming(MLStructure insert, String field)
    {
        MLStructure sinsert = (MLStructure) insert.getField(field);
        InsertTiming vec_insert = new InsertTiming();
        vec_insert.setJMatData(sinsert);
        return vec_insert;
    }
    
    
  
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("output_folder",setString(output_folder));
        struct.setField("filter_algorithm",setString(filter_algorithm));
        struct.setField("notch_remove_armonics",setString(notch_remove_armonics));

        struct.setField("ff1_global",setDoubleColumnArray(ff1_global));
        struct.setField("ff2_global",setDoubleColumnArray(ff2_global));
        struct.setField("do_notch",setDoubleColumnArray(do_notch));
        struct.setField("notch_fcenter",setDoubleColumnArray(notch_fcenter));
        struct.setField("notch_fspan",setDoubleColumnArray(notch_fspan));
        struct.setField("ff1_eeg",setDoubleColumnArray(ff1_eeg));
        struct.setField("ff2_eeg",setDoubleColumnArray(ff2_eeg));
        struct.setField("ff1_eog",setDoubleColumnArray(ff1_eog));
        struct.setField("ff2_eog",setDoubleColumnArray(ff2_eog));
        struct.setField("ff1_emg",setDoubleColumnArray(ff1_emg));
        struct.setField("ff2_emg",setDoubleColumnArray(ff2_emg));

        struct.setField("montage_list",setStringColLineCell(montage_list)); //modif getfunc
        
        struct.setField("rt",writeRt(rt));
        struct.setField("insert_block",writeInsertBlock(insert_block));
        struct.setField("marker_type",writeMarkerType(marker_type));
        struct.setField("insert_begin_trial",writeInsertTiming(insert_begin_trial));
        struct.setField("insert_end_trial",writeInsertTiming(insert_end_trial));
        struct.setField("insert_begin_baseline",writeInsertTiming(insert_begin_baseline));
        struct.setField("insert_end_baseline",writeInsertTiming(insert_end_baseline));
        
        return struct;
    }
    

    private MLStructure writeRt(Rt rt)
    {
        MLStructure struct = rt.getJMatData();
        return struct;
    }
    
    private MLStructure writeInsertBlock(InsertBlock insert_block)
    {
        MLStructure struct = insert_block.getJMatData();
        return struct;
    }
    
    private MLStructure writeMarkerType(MarkerType marker_type)
    {
        MLStructure struct = marker_type.getJMatData();
        return struct;
    }
    
    private MLStructure writeInsertTiming(InsertTiming insert_timing)
    {
        MLStructure struct = insert_timing.getJMatData();
        return struct;
    }
  
     
}
