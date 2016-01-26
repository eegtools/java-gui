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
public class GroupTimeWindows extends JMatlabStructWrapper{
    
    String name;
    int min;
    int max;
    
    public GroupTimeWindows(){}
    
    public GroupTimeWindows(MLStructure gtw)
    {
    
    }    
}
