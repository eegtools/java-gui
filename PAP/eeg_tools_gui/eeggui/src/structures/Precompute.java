/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.*;

/**
 *
 * @author PHilt
 */
public class Precompute extends JMatlabStructWrapper{
    
    public String recompute;
    public String do_erp;
    public String do_ersp;
    public String do_erpim;
    public String do_spec;

    public Erpim erpim;
    public Spec spec;
    
    public Precompute(){}
    
     public void setJMatData(MLStructure struct)
    {
        recompute   = getString(struct, "recompute");
        do_erp      = getString(struct, "do_erp");
        do_ersp     = getString(struct, "do_ersp");
        do_erpim    = getString(struct, "do_erpim");
        do_spec     = getString(struct, "do_spec");
        
        spec        = readSpec(struct, "spec");
        erpim       = readErpim(struct, "erpim");
    }    
     
    private Spec readSpec(MLStructure struct, String field)
    {
        MLCell cells = (MLCell) struct.getField(field);
        Spec vec = new Spec();
        vec.setJMatData(cells);
        return vec;
    }
    
    private Erpim readErpim(MLStructure struct, String field)
    {
        MLCell cells = (MLCell) struct.getField(field);
        Erpim vec = new Erpim();
        vec.setJMatData(cells);
        return vec;
    }
    
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        
        struct.setField("recompute",setString(recompute));
        struct.setField("do_erp",setString(do_erp));
        struct.setField("do_ersp",setString(do_ersp));
        struct.setField("do_erpim",setString(do_erpim));
        struct.setField("do_spec",setString(do_spec));
        
        struct.setField("spec",writeSpec(spec));
        struct.setField("erpim",writeErpim(erpim));

        return struct;
    }
    
    private MLCell writeSpec(Spec spec)
    {
        MLCell cell = spec.getJMatData(spec);
        return cell;
    }
    
    private MLCell writeErpim(Erpim erpim)
    {
        MLCell cell = erpim.getJMatData(erpim);
        return cell;
    }

    
}
