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
public class Stats extends JMatlabStructWrapper{
    
    public Erp_sta erp;
    public Eeglab_sta eeglab;
    public Ersp_sta ersp;
    public Brainstorm_sta brainstorm;
    public Spm_sta spm;
    
    public Stats()
    {
    }
    
    public void setJMatData(MLStructure stats)
    {
        erp         = readErp_sta(stats, "erp");
        eeglab      = readEeglab_sta(stats, "eeglab");
        ersp        = readErsp_sta(stats, "ersp");
        brainstorm  = readBrainstorm_sta(stats, "brainstorm");
        spm         = readSpm_sta(stats, "spm");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure stats = new MLStructure("stats",new int[] {1,1});

        return stats;
    }

    
    public Erp_sta readErp_sta(MLStructure erpsta, String field)
    {
        MLStructure erpstas = (MLStructure) erpsta.getField(field);
        Erp_sta vec = new Erp_sta(erpstas);
        return vec;
    }
    
    public Eeglab_sta readEeglab_sta(MLStructure eegsta, String field)
    {
        MLStructure eegstas = (MLStructure) eegsta.getField(field);
        Eeglab_sta vec = new Eeglab_sta(eegstas);
        return vec;
    }
    
    public Ersp_sta readErsp_sta(MLStructure erspsta, String field)
    {
        MLStructure erspstas = (MLStructure) erspsta.getField(field);
        Ersp_sta vec = new Ersp_sta(erspstas);
        return vec;
    }
    
    public Brainstorm_sta readBrainstorm_sta(MLStructure brainsta, String field)
    {
        MLStructure brainstas = (MLStructure) brainsta.getField(field);
        Brainstorm_sta vec = new Brainstorm_sta(brainstas);
        return vec;
    }
    
    public Spm_sta readSpm_sta(MLStructure spmsta, String field)
    {
        MLStructure spmstas = (MLStructure) spmsta.getField(field);
        Spm_sta vec = new Spm_sta(spmstas);
        return vec;
    }
    

}
