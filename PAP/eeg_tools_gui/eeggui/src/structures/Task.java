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
public class Task extends JMatlabStructWrapper{
    
    public Events events;
    
    public Task(){}    

    public void setJMatData(MLStructure task)
    {
        events = readEvents(task,"events");
    }
    
    private Events readEvents(MLStructure struct, String field)
    {
        MLStructure structs = (MLStructure) struct.getField(field);
        Events vec = new Events();
        vec.setJMatData(structs);
        return vec;
    }
    

    public MLStructure getJMatData()
    {
        MLStructure struct = new MLStructure("XXX",new int[] {1,1});
        struct.setField("events",writeEvents(events));
        return struct;
    }

    private MLStructure writeEvents(Events events)
    {
        MLStructure struct = events.getJMatData();
        return struct;
    }
    
}
