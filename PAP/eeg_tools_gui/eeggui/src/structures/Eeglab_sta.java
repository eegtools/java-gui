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
public class Eeglab_sta extends JMatlabStructWrapper{
    
    public Erp_eeg_sta erp;
    public Ersp_eeg_sta ersp;

    
    public Eeglab_sta()
    {
    }
    
    public Eeglab_sta(MLStructure eegsta)
    {
        erp     = getErp_eeg_sta(eegsta, "erp");
        ersp    = getErsp_eeg_sta(eegsta, "ersp");
    } 
    
    public Erp_eeg_sta getErp_eeg_sta(MLStructure erpeegsta, String field)
    {
        MLStructure erpeegstas = (MLStructure) erpeegsta.getField(field);
        Erp_eeg_sta vec = new Erp_eeg_sta(erpeegstas);
        return vec;
    }
    
    public Ersp_eeg_sta getErsp_eeg_sta(MLStructure erspeegsta, String field)
    {
        MLStructure erspeegstas = (MLStructure) erspeegsta.getField(field);
        Ersp_eeg_sta vec = new Ersp_eeg_sta(erspeegstas);
        return vec;
    }
    
    
}
