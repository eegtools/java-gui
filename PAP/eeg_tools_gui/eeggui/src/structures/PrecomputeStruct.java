/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.MLCell;
import com.jmatio.types.MLStructure;

/**
 *
 * @author PHilt
 */
public class PrecomputeStruct extends JMatlabStructWrapper{
    
    public String interp;
    public String allcomps;
    public String ersp;
    public String itc;
    public String recompute;
    
    public ErspParams erspparams;
    
    public PrecomputeStruct(){}
    
    public void setJMatData(MLStructure struct)
    {
        interp      = getString(struct, "interp");
        allcomps    = getString(struct, "allcomps");
        ersp        = getString(struct, "ersp");
        itc         = getString(struct, "itc");
        recompute   = getString(struct, "recompute");
        
        erspparams  = readErspParams(struct, "erspparams");
    }    
    
    private ErspParams readErspParams(MLStructure struct, String field)
    {
        MLCell cells = (MLCell) struct.getField(field);
        ErspParams vec = new ErspParams();
        vec.setJMatData(cells);
        return vec;
    }   
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("interp",setString(interp));
        struct.setField("allcomps",setString(allcomps));
        struct.setField("ersp",setString(ersp));
        struct.setField("itc",setString(itc));
        struct.setField("recompute",setString(recompute));
        
        struct.setField("erspparams",writeErspParams(erspparams));
 
        return struct;
    }
    
    private MLCell writeErspParams(ErspParams ersp_params)
    {
        MLCell cell = ersp_params.getJMatData(ersp_params);
        return cell;
    }
}
