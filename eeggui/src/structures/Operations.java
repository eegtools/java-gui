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
public class Operations extends JMatlabStructWrapper{
    
    public double[] do_source_analysis;   //double
    public double[]  do_emg_analysis;      //double
    public double[]  do_cluster_analysis;  //double
    
    public Operations(){}
    
    public void setJMatData(MLStructure oper)
    {
        do_source_analysis  = getDoubleArray(oper, "do_source_analysis");
        do_emg_analysis     = getDoubleArray(oper, "do_emg_analysis");
        do_cluster_analysis = getDoubleArray(oper, "do_cluster_analysis");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure oper = new MLStructure("XXX",new int[] {1,1});
        
        oper.setField("do_source_analysis",setDoubleColumnArray(do_source_analysis));
        oper.setField("do_emg_analysis",setDoubleColumnArray(do_emg_analysis));
        oper.setField("do_cluster_analysis",setDoubleColumnArray(do_cluster_analysis));
 
        return oper;
    }
    
}
