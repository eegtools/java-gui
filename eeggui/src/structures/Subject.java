/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.MLStructure;

/**
 *
 * @author alba
 */
public class Subject extends JMatlabStructWrapper{
   
    public String name;
    public String group;
    public int age;
    public String gender;
    public String handedness;
    public String[] bad_ch;
    
    public Subject(){}
    
    public Subject(MLStructure subj)
    {    
        name        = getString(subj, "name");
        group       = getString(subj, "group");
        gender      = getString(subj, "gender");
        handedness  = getString(subj, "handedness");
        age         = getInt(subj, "age");
        bad_ch      = getStringCellArray(subj, "bad_ch");
    }
}
