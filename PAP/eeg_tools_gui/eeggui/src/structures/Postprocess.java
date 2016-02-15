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
public class Postprocess extends JMatlabStructWrapper{
    
    public String[][][] design_factors_ordered_levels; // pbe 4 colonnes, 1 ligne -> define new export func.
    public Erp_pos erp;
    public Ersp_pos ersp;
    public Eeglab_pos eeglab;

    
    public Postprocess()
    {
        
    }
    
    
   public void setJMatData(MLStructure postproc)
    {
        
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure postproc = new MLStructure("postproc",new int[] {1,1});
 
        return postproc;
    }

    
}
