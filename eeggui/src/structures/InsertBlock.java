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
public class InsertBlock extends JMatlabStructWrapper{
    
    public double[] trials_per_block; //int
    
    public InsertBlock(){}
    
    public void setJMatData(MLStructure insb)
    {
        trials_per_block = getDoubleArray(insb, "trials_per_block");
    } 

    public MLStructure getJMatData()
    {
        MLStructure insb = new MLStructure("XXX", new int[] {1,1});
        insb.setField("trials_per_block", setDoubleColumnArray(trials_per_block));
        return insb;
    } 
    
}
