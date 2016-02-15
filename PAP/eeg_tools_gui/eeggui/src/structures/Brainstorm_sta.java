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
public class Brainstorm_sta extends JMatlabStructWrapper{
    
    public double pvalue;
    public String correction;
    
    public Brainstorm_sta()
    {
    }
    
    public Brainstorm_sta(MLStructure brainstorm)
    {
        pvalue      = getDouble(brainstorm, "pvalue");
        correction  = getString(brainstorm, "correction");
    } 
    
    
    
}
