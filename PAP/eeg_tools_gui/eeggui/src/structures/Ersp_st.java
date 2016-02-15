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
public class Ersp_st extends JMatlabStructWrapper{
    
    public Latencysms tmin_analysis;
    public Latencysms tmax_analysis;
    public Latencysms ts_analysis;
    // Latency[] timeout_analysis_intervall;
    
    public int fmin_analysis;
    public int fmax_analysis;
    
    public double fs_analysis;
    
    public double[] freqout_analysis_interval;
    
    public int padratio;
    public int cycles;
    

    public Ersp_st() 
    {
        
    } 
    
    public Ersp_st(MLStructure ersps) 
    {
        tmin_analysis               = getLatency(ersps, "tmin_analysis");
        tmax_analysis               = getLatency(ersps, "tmax_analysis");
        ts_analysis                 = getLatency(ersps, "ts_analysis");
        // timeout_analysis_intervall = getLatencyArray(ersps,"timeout_analysis_intervall");
        
        fmin_analysis               = getInt(ersps, "fmin_analysis"); 
        fmax_analysis               = getInt(ersps, "fmax_analysis"); 
        
        fs_analysis                 = getDouble(ersps, "fs_analysis"); 
        
        freqout_analysis_interval   = getDoubleArray(ersps, "freqout_analysis_interval"); 
        
        padratio                    = getInt(ersps, "padratio"); 
        cycles                      = getInt(ersps, "cycles"); 
          
    } 
    
    public Latencysms getLatency(MLStructure ersps, String field)
    {
        MLStructure erspss = (MLStructure) ersps.getField(field);
        Latencysms vec = new Latencysms(erspss);
        return vec;
    }
    
}
