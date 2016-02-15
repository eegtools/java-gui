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
class Ersp_eeg_sta extends JMatlabStructWrapper{
    
    public String method;
    public String correction;
    
    public Ersp_eeg_sta()
    {
    }
    
    public Ersp_eeg_sta(MLStructure erspeegsta)
    {
        method      = getString(erspeegsta,"method");
        correction  = getString(erspeegsta,"correction");
    } 

    
}
