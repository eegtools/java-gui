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
public class Erpim extends JMatlabStructWrapper{

    public String interp;
    public String allcomps;
    public String erpim;
    public String recompute;
    
    public ErpimParams erpimparams;
    
    public Erpim(){}
    
    public void setJMatData(MLCell cells)
    {
        interp         = ((MLChar) cells.get(1)).getString(0);
        allcomps       = ((MLChar) cells.get(3)).getString(0);
        erpim          = ((MLChar) cells.get(5)).getString(0);
        
        erpimparams    = readErpimParams(cells);
        
        recompute      = ((MLChar) cells.get(9)).getString(0);
    } 
    
    private ErpimParams readErpimParams(MLCell cells)
    {
        MLCell subcells = (MLCell) cells.get(7);
        ErpimParams vec = new ErpimParams();
        vec.setJMatData(subcells);
        return vec;
    }
    
    public MLCell getJMatData(Erpim erpim)
    {
        MLCell cell = new MLCell("XXX",new int[] {1,10});
        
        MLChar mlchar1 = new MLChar("XXX","interp");
        cell.set(mlchar1,0,0);
        cell.set(setString(erpim.interp),0,1);
        
        MLChar mlchar2 = new MLChar("XXX","allcomps");
        cell.set(mlchar2,0,2);
        cell.set(setString(erpim.allcomps),0,3);
        
        MLChar mlchar3 = new MLChar("XXX","spec");
        cell.set(mlchar3,0,4);
        cell.set(setString(erpim.erpim),0,5);
        
        MLChar mlchar4 = new MLChar("XXX","specparams");
        cell.set(mlchar4,0,6);
        cell.set(writeErpimParams(erpim.erpimparams),0,7);
        
        MLChar mlchar5 = new MLChar("XXX","recompute");
        cell.set(mlchar5,0,8);
        cell.set(setString(erpim.recompute),0,9);

        return cell;
    }
    
    private MLCell writeErpimParams(ErpimParams erpimparams)
    {
        MLCell mlcell = erpimparams.getJMatData(erpimparams);
        return mlcell;
    }

    
}
