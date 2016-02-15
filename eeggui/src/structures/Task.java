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
    
    public Events_ta events;
    
    public Task()
    {
        
    }    

    public void setJMatData(MLStructure task)
    {
        events = readEvents_ta(task,"events");
    }
  
    /*
    public MLStructure getJMatData()
    {
        MLStructure task = new MLStructure("task",new int[] {1,1});
        task.setField("events",setEvents_ta());
        return task;
    }
    */
    
    private Events_ta readEvents_ta(MLStructure event, String field)
    {
        MLStructure events_test = (MLStructure) event.getField(field);
        Events_ta test = new Events_ta();
        test.setJMatData(events_test);
        return test;
    }


    /*
    private Events_ta setEvents_ta(MLStructure condvol, String field)
    {
        MLStructure sub_Events_ta = new MLStructure("sub_Events_ta",new int[] {1,1});
        Events_ta struct = new Events_ta();
        sub_Events_ta = struct.getJMatData();
        return sub_Events_ta;
    }
    */
    
}
