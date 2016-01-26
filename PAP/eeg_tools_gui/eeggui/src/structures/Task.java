/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.MLArray;
import com.jmatio.types.MLStructure;
import java.io.IOException;
import java.util.Collection;

/**
 *
 * @author PHilt
 */
public class Task extends JMatlabStructWrapper{
    
    public Events events;
    
    public Task()
    {
        
    }    
    public Task(MLStructure task)
    {
        MLStructure sevents = (MLStructure) task.getField("events");
        events = new Events(sevents);
    }
    
}
