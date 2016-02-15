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
public class ResultsDisplay extends JMatlabStructWrapper{
    
    public Erp_res erp;
    public Ersp_res ersp;
    
    public double[] ylim_plot;
    
    public int filter_freq;
    
    
    public ResultsDisplay()
    {
    }
    
    public void setJMatData(MLStructure resdisp)
    {
        ylim_plot    = getDoubleArray(resdisp, "ylim_plot");
        filter_freq  = getInt(resdisp, "filter_freq");
    }
  
    public MLStructure getJMatData()
    {
        MLStructure resdisp = new MLStructure("resdisp",new int[] {1,1});

        resdisp.setField("ylim_plot",setDoubleColumnArray(ylim_plot));
        resdisp.setField("filter_freq",setInt(filter_freq));
        
        return resdisp;
    }

 
    
}
