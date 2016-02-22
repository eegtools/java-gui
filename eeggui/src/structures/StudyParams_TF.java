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
public class StudyParams_TF extends JMatlabStructWrapper{

    public Latency tmin_analysis;
    public Latency tmax_analysis;
    public Latency ts_analysis;
    public Latency timeout_analysis_interval;
    
    public PrecomputeStruct precompute_struct;
    
    public double[] fmin_analysis;
    public double[] fmax_analysis;
    public double[] fs_analysis;
    public double[] freqout_analysis_interval;
    public double[] padratio;
    public double[] cycles;
    
    public StudyParams_TF(){}
    
    public void setJMatData(MLStructure struct)
    {
        tmin_analysis               = readLatency(struct, "tmin_analysis");
        tmax_analysis               = readLatency(struct, "tmax_analysis");
        ts_analysis                 = readLatency(struct, "ts_analysis");
        timeout_analysis_interval   = readLatency(struct, "timeout_analysis_interval");
        
        precompute_struct           = readPrecomputeStruct(struct, "precompute_struct");
        
        fmin_analysis               = getDoubleArray(struct, "fmin_analysis");
        fmax_analysis               = getDoubleArray(struct, "fmax_analysis");
        fs_analysis                 = getDoubleArray(struct, "fs_analysis");
        freqout_analysis_interval   = getDoubleArray(struct, "freqout_analysis_interval");
        padratio                    = getDoubleArray(struct, "padratio");
        cycles                      = getDoubleArray(struct, "cycles");

    }    
    
    private Latency readLatency(MLStructure lat, String field)
    {
        MLStructure slat = (MLStructure) lat.getField(field);
        Latency vec_lat = new Latency();
        vec_lat.setJMatDataS(slat);
        return vec_lat;
    }
    
    private PrecomputeStruct readPrecomputeStruct(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        PrecomputeStruct vec = new PrecomputeStruct();
        vec.setJMatData(structs);
        return vec;
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("tmin_analysis",writeLatency(tmin_analysis));
        struct.setField("tmax_analysis",writeLatency(tmax_analysis));
        struct.setField("ts_analysis",writeLatency(ts_analysis));
        struct.setField("timeout_analysis_interval",writeLatency(timeout_analysis_interval));
        
        struct.setField("precompute_struct",writePrecomputeStruct(precompute_struct));
        
        struct.setField("fmin_analysis",setDoubleColumnArray(fmin_analysis));
        struct.setField("fmax_analysis",setDoubleColumnArray(fmax_analysis));
        struct.setField("fs_analysis",setDoubleColumnArray(fs_analysis));
        struct.setField("freqout_analysis_interval",setDoubleLineArray(freqout_analysis_interval));
        struct.setField("padratio",setDoubleColumnArray(padratio));
        struct.setField("cycles",setDoubleColumnArray(cycles));
 
        return struct;
    }
    
    private MLStructure writeLatency(Latency latency)
    {
        MLStructure struct = latency.getJMatData();
        return struct;
    }
    
    private MLStructure writePrecomputeStruct(PrecomputeStruct precompute_struct)
    {
        MLStructure struct = precompute_struct.getJMatData();
        return struct;
    }
    
}
