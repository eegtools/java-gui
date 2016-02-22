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
public class Mode extends JMatlabStructWrapper{
    
    public Tw continous;
    public Tw tw_group_noalign;
    public Tw tw_group_align;
    public Tw tw_individual_noalign;
    public Tw tw_individual_align;
    
    public Mode(){}
    
    public void setJMatData(MLStructure struct)
    {
        continous              = readTw(struct, "continous");
        tw_group_noalign        = readTw(struct, "tw_group_noalign");
        tw_group_align          = readTw(struct, "tw_group_align");
        tw_individual_noalign   = readTw(struct, "tw_individual_noalign");
        tw_individual_align     = readTw(struct, "tw_individual_align");
    }
    
    private Tw readTw(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        Tw vec = new Tw();
        vec.setJMatData(structs);
        return vec;
    }
    
        
    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});

        struct.setField("continous", writeTw(continous));
        struct.setField("tw_group_noalign", writeTw(tw_group_noalign));
        struct.setField("tw_group_align", writeTw(tw_group_align));
        struct.setField("tw_individual_noalign", writeTw(tw_individual_noalign));
        struct.setField("tw_individual_align", writeTw(tw_individual_align));
 
        return struct;
    }
    
    private MLStructure writeTw(Tw tw)
    {
        MLStructure struct = tw.getJMatData();
        return struct;
    }
    

}
