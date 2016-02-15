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
public class Erp_st extends JMatlabStructWrapper{
    
    public Latencysms tmin_analysis;
    public Latencysms tmax_analysis;
    public Latencysms ts_analysis;
    
    // Latency[] timeout_analysis_intervall;
    
    public Erp_st() 
    {
        
    } 
    
    public Erp_st(MLStructure erps) 
    {
        tmin_analysis       = getLatency(erps, "tmin_analysis");
        tmax_analysis       = getLatency(erps, "tmax_analysis");
        ts_analysis         = getLatency(erps, "ts_analysis");
        
        // timeout_analysis_intervall = getLatencyArray(erps,"timeout_analysis_intervall");
    } 
    
    public Latencysms getLatency(MLStructure erps, String field)
    {
        MLStructure erpss = (MLStructure) erps.getField(field);
        Latencysms vec = new Latencysms(erpss);
        return vec;
    }
    
    /*
    public Latency[] getLatencyArray(MLStructure erps, String field)
    {
        MLStructure erpss = (MLStructure) erps.getField(field);
        Latency vec = new Latency(erpss);
        return vec;
    }
    */
    
}
