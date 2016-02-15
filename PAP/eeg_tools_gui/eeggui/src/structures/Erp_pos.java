/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.MLArray;
import com.jmatio.types.MLStructure;
import java.util.Map;

/**
 *
 * @author PHilt
 */
class Erp_pos extends JMatlabStructWrapper{
    
    public String sel_extrema;
    
    public String[][] roi_list;
    public String[] roi_names;
    
    public int numroi;
    
    public Mode_erp_pos mode;
    public Design_erp_pos design;
    public Eog_erp_pos eog;
    public Emg_erp_pos emg;
    
    public Erp_pos()
    {
        
    }
    
    
    public Erp_pos(MLStructure erppos)
    {
        sel_extrema     = getString(erppos, "sel_extrema");
        roi_names       = getStringCellArray(erppos, "roi_names");
        roi_list        = getStringCellMatrix(erppos, "roi_list");
        numroi          = getInt(erppos, "numroi");
        
        mode            = getMode_erp_pos(erppos, "mode");
        eog             = getEog_erp_pos(erppos, "eog");
        emg             = getEmg_erp_pos(erppos, "emg");

        //design          = getDesign_erp_pos(erppos, "design");
    }
    
    
    public Mode_erp_pos getMode_erp_pos(MLStructure modeerp, String field)
    {
        MLStructure modeerps = (MLStructure) modeerp.getField(field);
        Mode_erp_pos vec = new Mode_erp_pos(modeerps);
        return vec;
    }
    
    public Eog_erp_pos getEog_erp_pos(MLStructure eogerp, String field)
    {
        MLStructure eogerps = (MLStructure) eogerp.getField(field);
        Eog_erp_pos vec = new Eog_erp_pos(eogerps);
        return vec;
    }
    
    public Emg_erp_pos getEmg_erp_pos(MLStructure emgerp, String field)
    {
        MLStructure emgerps = (MLStructure) emgerp.getField(field);
        Emg_erp_pos vec = new Emg_erp_pos(emgerps);
        return vec;
    }
    
    /*
    public Design_erp_pos[] readDesign_erp_pos(MLStructure deserps, String field)
    {
        MLStructure a           = (MLStructure) deserps.getField(field);
        int[] dim               = a.getDimensions();
        
        Design_erp_pos[] arr_deserps = new Design_erp_pos[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  deserp = a.getFields(s);
            //MLStructure str_subj = (MLStructure) subj;//arr_subjs[s].name = getString(str_subj,    "name");

            arr_deserps[s]            = new Design_erp_pos();
            arr_deserps[s].name       = getString(deserp, "name");
            arr_deserps[s].handedness = getString(deserp, "handedness");
            arr_deserps[s].gender     = getString(deserp, "gender");
            arr_deserps[s].group      = getString(deserp, "group");
            arr_deserps[s].age        = getInt(deserp, "age");
        }  
        return arr_deserps;
    }
*/
    
   
    
}
