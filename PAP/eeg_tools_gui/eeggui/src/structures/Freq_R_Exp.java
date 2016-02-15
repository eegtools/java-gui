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
public class Freq_R_Exp extends JMatlabStructWrapper{
    
    public double[] freq;
    public String name;
    
    public Freq_R_Exp()
    {
        
    }
    
    
    public Freq_R_Exp(MLStructure freq_r_exp)
    {
        freq    = getDoubleArray(freq_r_exp, "freq");
        name    = getString(freq_r_exp, "name");
    } 
    
}
