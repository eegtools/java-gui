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
public class Ch2transform_imp extends JMatlabStructWrapper{
    
    public String type;
    public int ch1;
    public int ch2;
    public String new_label;
    
    public Ch2transform_imp()
    {
    }    

    public void setJMatData(MLStructure ch2transf)
    {
        type        = getString(ch2transf, "type");
        new_label   = getString(ch2transf, "new_label");
        
        ch1         = getInt(ch2transf, "ch1");
        ch2         = getInt(ch2transf, "ch2");
    }
    
    public MLStructure getJMatData()
    {
        MLStructure ch2transf = new MLStructure("ch2transf",new int[] {1,1});
        
        ch2transf.setField("type",setString(type));
        ch2transf.setField("new_label",setString(new_label));
        
        ch2transf.setField("ch1",setInt(ch1));
        ch2transf.setField("ch2",setInt(ch2));
 
        return ch2transf;
    }
    
}
