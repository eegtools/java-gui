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
        MLStructure sevents = (MLStructure) task.getField("events");
        events              = new Events_ta(sevents);
    }
  
    public MLStructure getJMatData()
    {
        MLStructure task = new MLStructure("task",new int[] {1,1});
        
        return task;
    }
    
}
