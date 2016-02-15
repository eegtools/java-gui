/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.*;
import java.util.Map;

/**
 *
 * @author alba
 */
public class Study  extends JMatlabStructWrapper{
   
    public String filename;
    
    public Precompute_st precompute;
    
    public Erp_st erp;
    public Ersp_st ersp;
    
    // public Factors_st[] factors;
    
    

    public Study()
    {
    } 
    
    public void setJMatData(MLStructure study)
    {
        filename        = getString(study, "filename");
        
        precompute      = readPrecompute(study, "precompute");
        erp             = readErp(study, "erp");
        ersp            = readErsp(study, "ersp");
        
        //factors         = readFactors(study, "factors");
    }    
    
    public MLStructure getJMatData()
    {
        MLStructure study = new MLStructure("study",new int[] {1,1});
        
        study.setField("filename",setString(filename));
        
        // precompute
        // erp
        // ersp
        
        // factors
 
        return study;
    }
  
    private Precompute_st readPrecompute(MLStructure study, String field)
    {
        MLStructure precomp = (MLStructure) study.getField(field);
        Precompute_st vec = new Precompute_st(precomp);
        return vec;
    }
    
    private Erp_st readErp(MLStructure study, String field)
    {
        MLStructure precomp = (MLStructure) study.getField(field);
        Erp_st vec = new Erp_st(precomp);
        return vec;
    }
    
    private Ersp_st readErsp(MLStructure study, String field)
    {
        MLStructure precomp = (MLStructure) study.getField(field);
        Ersp_st vec = new Ersp_st(precomp);
        return vec;
    }
    
    private Factors_st[] readFactors(MLStructure study , String field)
    {
        MLStructure a           = (MLStructure) study.getField(field);
        int[] dim               = a.getDimensions();
        
        Factors_st[] arr_facs = new Factors_st[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  fac = a.getFields(s);
            //MLStructure str_subj = (MLStructure) subj;//arr_subjs[s].name = getString(str_subj,    "name");

            arr_facs[s]             = new Factors_st();
            arr_facs[s].factor      = getString(fac, "factor");
            arr_facs[s].level       = getString(fac, "level");
            arr_facs[s].file_match  = getStringCellArray(fac, "file_match");
        }  
        return arr_facs;
    }
    
    
}
