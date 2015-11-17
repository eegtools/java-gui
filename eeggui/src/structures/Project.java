/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import gui.JTPMain;

/**
 *
 * @author alba
 */
public class Project {
    
    

    
    public void setGUI()
    {
        jtp_main.setGUI(this);
    }
    public Project getGUI()
    {
        Project proj = jtp_main.getGUI();        
        preproc = proj.preproc;
        return this;
    }   
    
    public Project loadMAT(String input_file)
    {
        // open file, fill each project instances
        // preproc = ...
        return this;
    }

    public int saveMAT(String input_file)
    {

        return 1;   // in C++ there is the convention to return 0 if succesfull, or a numeric code to explain the error, 
                    // verify Java standard, that is, if function generally follow this approach.
    }    
    JTPMain jtp_main;
    public Preproc preproc;    
}


