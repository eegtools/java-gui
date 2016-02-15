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
    
    public String[] erp;
    public String[] erpim;
    public String[] spec;
    public String[] ersp;
    
    public Precompute()
    {
    }
    
    public Precompute(MLStructure precomp) 
    {
        recompute = getString(precomp, "recompute");
        do_erp = getString(precomp, "do_erp");
        do_ersp = getString(precomp, "do_ersp");
        do_erpim = getString(precomp, "do_erpim");
        do_spec = getString(precomp, "do_spec");
        
        //erp = getStringCellArray(precomp,"erp");
        //erpim = getStringCellArray(precomp,"erpim");
        //spec = getStringCellArray(precomp,"spec");
        //ersp = getStringCellArray(precomp,"ersp");
        
    } 

    
}
