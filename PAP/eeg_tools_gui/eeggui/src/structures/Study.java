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
    
    public Precompute precompute;
    
    public Factors[] factors;
    public Design[] design;


    public Study(){} 
    
    public void setJMatData(MLStructure struct)
    {
        filename        = getString(struct, "filename");
        
        precompute      = readPrecompute(struct, "precompute");
        
        design          = readDesign(struct, "design");
        factors         = readFactors(struct, "factors");
    }    
    
      
    private Precompute readPrecompute(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        Precompute vec = new Precompute();
        vec.setJMatData(structs);
        return vec;
    }

    
    private Factors[] readFactors(MLStructure study , String field)
    {
        MLStructure a           = (MLStructure) study.getField(field);
        int[] dim               = a.getDimensions();
        
        Factors[] arr_facs = new Factors[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  fac = a.getFields(s);
            arr_facs[s]             = new Factors();
            arr_facs[s].factor      = getString(fac, "factor");
            arr_facs[s].level       = getString(fac, "level");
            arr_facs[s].file_match  = getStringCellArray(fac, "file_match");
        }  
        return arr_facs;
    }
    
    public Design[] readDesign(MLStructure des , String field)
    {
        MLStructure a           = (MLStructure) des.getField(field);
        int[] dim               = a.getDimensions();
        
        Design[] arr_des = new Design[dim[1]];
        for (int s=0; s < dim[1]; s++)
        {
            Map<String, MLArray>  des1 = a.getFields(s);
            arr_des[s]                  = new Design();
            arr_des[s].name             = getString(des1, "name");
            arr_des[s].factor1_name     = getString(des1, "factor1_name");
            arr_des[s].factor2_name     = getString(des1, "factor2_name");
            arr_des[s].factor1_pairing  = getString(des1, "factor1_pairing");
            arr_des[s].factor2_pairing  = getString(des1, "factor2_pairing");
            arr_des[s].factor1_levels    = getStringCellArray(des1, "factor1_levels");
            arr_des[s].factor2_levels    = getStringCellArray(des1, "factor2_levels"); 
        }  
        return arr_des;
    }   
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("filename",setString(filename));
        
        struct.setField("precompute",writePrecompute(precompute));

        struct.setField("factors",writeFactors(factors));
        struct.setField("design",writeDesign(design));
 
        return struct;
    }
    
    private MLStructure writePrecompute(Precompute precompute)
    {
        MLStructure struct = precompute.getJMatData();
        return struct;
    }
    
    private MLStructure writeFactors(Factors[] factors)
    {
        int dim = factors.length;
        MLStructure struct = new MLStructure("XXX",new int[] {1,dim});
        
        for (int s=0; s < dim; s++)
        {
            struct.setField("factor", setString(factors[s].factor), s);
            struct.setField("level", setString(factors[s].level), s);
            struct.setField("file_match", setStringLineArray(factors[s].file_match), s);
        }
        return struct;
    }
    
    private MLStructure writeDesign(Design[] design)
    {
        int dim = design.length;
        MLStructure struct = new MLStructure("XXX",new int[] {1,dim});
        
        for (int s=0; s < dim; s++)
        {
            struct.setField("name", setString(design[s].name), s);
            struct.setField("factor1_name", setString(design[s].factor1_name), s);
            struct.setField("factor2_name", setString(design[s].factor2_name), s);
            struct.setField("factor1_pairing", setString(design[s].factor1_pairing), s);
            struct.setField("factor2_pairing", setString(design[s].factor2_pairing), s);
            
            struct.setField("factor1_levels", setStringLineArray(design[s].factor1_levels), s);
            struct.setField("factor2_levels", setStringLineArray(design[s].factor2_levels), s);
        }
        return struct;
    }
 
}
