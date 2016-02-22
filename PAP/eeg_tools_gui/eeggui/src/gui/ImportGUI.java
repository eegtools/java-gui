/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gui;

import structures.Ch2transform;
import structures.Import;
/**
 *
 * @author PHilt
 */
public class ImportGUI {
    
    public javax.swing.JComboBox acquisition_system;
    public javax.swing.JTextField original_data_extension;
    public javax.swing.JTextField original_data_folder;
    public javax.swing.JTextField original_data_suffix;
    public javax.swing.JTextField original_data_prefix;
    public javax.swing.JTextField output_folder;
    public javax.swing.JTextField output_suffix;
    public javax.swing.JTextField emg_output_postfix;
    
    public javax.swing.JTable reference_channels;
    public javax.swing.JTable valid_marker;
    
    public Ch2transform[] ch2transform;
     
    public Import import_graphic;
    
}
