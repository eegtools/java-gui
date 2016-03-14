/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gui;

import java.awt.Component;
import java.util.Arrays;
import javax.swing.DefaultCellEditor;
import javax.swing.DefaultListModel;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JTable;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellEditor;
import javax.swing.table.TableCellRenderer;
import structures.Project;
import structures.Study;

/**
 *
 * @author PHilt
 */
public class JPStudyDesign extends javax.swing.JPanel {

    private JTPMain controller;
    public Study study;
    public Project project;    
    
    ModelTable_design jTableDM_design;
    ModelTable_factors jTableDM_factors;
    
    
    public JPStudyDesign(JTPMain ctrl) 
    {
        controller = ctrl;
        initComponents();
    }
    
    public void initGUI(Project proj)
    {
        project = proj;
        study = project.study;
        initTable_factors(1);
        initTable_design(1);
    }

    public void setGUI(Project proj)
    {
        project = proj;
        study = project.study;
        
        initGUI(project);
        
        jTextField_filename.setText(project.study.filename);

        boolean do_recomp = (project.study.precompute.recompute.equals("on"));
        jCheckBox_precompute_recompute.setSelected(do_recomp);
        boolean do_erp = (project.study.precompute.do_erp.equals("on"));
        jCheckBox_precompute_do_erp.setSelected(do_erp);
        boolean do_ersp = (project.study.precompute.do_ersp.equals("on"));
        jCheckBox_precompute_do_ersp.setSelected(do_ersp);
        boolean do_erpim = (project.study.precompute.do_erpim.equals("on"));
        jCheckBox_precompute_do_erpim.setSelected(do_erpim);
        boolean do_spec = (project.study.precompute.do_spec.equals("on"));
        jCheckBox_precompute_do_spec.setSelected(do_spec);

        boolean do_erpimparams_interp = (project.study.precompute.erpim.interp.equals("on"));
        jCheckBox_precompute_erpimparams_interp.setSelected(do_erpimparams_interp);
        boolean do_erpimparams_allcomps = (project.study.precompute.erpim.allcomps.equals("on"));
        jCheckBox_precompute_erpimparams_allcomps.setSelected(do_erpimparams_allcomps);
        boolean do_erpimparams_erpim = (project.study.precompute.erpim.erpim.equals("on"));
        jCheckBox_precompute_erpimparams_erpim.setSelected(do_erpimparams_erpim);
        boolean do_erpimparams_recompute = (project.study.precompute.erpim.recompute.equals("on"));
        jCheckBox_precompute_erpimparams_recompute.setSelected(do_erpimparams_recompute);
        
        jTextField_precompute_erpimparams_erpim_nlines.setText(String.valueOf(project.study.precompute.erpim.erpimparams.nlines[0]));
        jTextField_precompute_erpimparams_erpim_smoothing.setText(String.valueOf(project.study.precompute.erpim.erpimparams.smoothing[0]));
        
        boolean do_specparams_interp = (project.study.precompute.spec.interp.equals("on"));
        jCheckBox_precompute_specparams_interp.setSelected(do_specparams_interp);
        boolean do_specparams_allcomps = (project.study.precompute.spec.allcomps.equals("on"));
        jCheckBox_precompute_specparams_allcomps.setSelected(do_specparams_allcomps);
        boolean do_specparams_spec = (project.study.precompute.spec.spec.equals("on"));
        jCheckBox_precompute_specparams_spec.setSelected(do_specparams_spec);
        boolean do_specparams_recompute = (project.study.precompute.spec.recompute.equals("on"));
        jCheckBox_precompute_specparams_recompute.setSelected(do_specparams_recompute);
        
        jTextField_precompute_specparams_spec_mode.setText(project.study.precompute.spec.specparams.specmode);
        jTextField_precompute_specparams_spec_freqs_low.setText(String.valueOf(project.study.precompute.spec.specparams.freqs[0]));
        jTextField_precompute_specparams_spec_freqs_high.setText(String.valueOf(project.study.precompute.spec.specparams.freqs[1]));

        setTable_factors();
        setList_file_match();
        setTable_design();
        
        setCombo_factor1InTable_design();
        setCombo_factor2InTable_design();
        
        setList_file_match();
        
        initList_factor1_levels();
        initList_factor2_levels();
    }
    
    public Study getGUI()
    {
        study.filename = jTextField_filename.getText();
        
        boolean do_recompute    = jCheckBox_precompute_recompute.isSelected();
        boolean do_erp          = jCheckBox_precompute_do_erp.isSelected();
        boolean do_ersp         = jCheckBox_precompute_do_ersp.isSelected();
        boolean do_erpim        = jCheckBox_precompute_do_erpim.isSelected();
        boolean do_spec         = jCheckBox_precompute_do_spec.isSelected();
        study.precompute.recompute = do_recompute? "on" : "off"; 
        study.precompute.do_erp    = do_erp? "on" : "off"; 
        study.precompute.do_ersp   = do_ersp? "on" : "off"; 
        study.precompute.do_erpim  = do_erpim? "on" : "off"; 
        study.precompute.do_spec   = do_spec? "on" : "off"; 
        
        for (int i = 0; i < jTable_factors.getColumnCount(); i++) 
        {
            study.factors[i].factor        = (String) jTable_factors.getValueAt(i,0);
            study.factors[i].level         = (String) jTable_factors.getValueAt(i,1);
            
            if ((jTable_factors.getValueAt(i,2)!=null) || (!((String) jTable_factors.getValueAt(i,2)).isEmpty()))
            {study.factors[i].file_match     = ((String) jTable_factors.getValueAt(i,2)).split(";");}
        }

        for (int i = 0; i < jTable_design.getRowCount(); i++) 
        {
            study.design[i].name               = (String) jTable_design.getValueAt(i,0);
            study.design[i].factor1_name       = (String) jTable_design.getValueAt(i,1); 
            study.design[i].factor2_name       = (String) jTable_design.getValueAt(i,4);
            
            Object pair1 = jTable_design.getValueAt(i,2);
            boolean bool_pair1 = (Boolean) pair1;
            if (bool_pair1)
            {study.design[i].factor1_pairing = "on";}
            else {study.design[i].factor1_pairing = "off";}
            
            Object pair2 = jTable_design.getValueAt(i,5);
            boolean bool_pair2 = (Boolean) pair2;
            if (bool_pair2)
            {study.design[i].factor2_pairing = "on";}
            else {study.design[i].factor2_pairing = "off";}
            
            if ((jTable_design.getValueAt(i,3)!=null))
            {study.design[i].factor1_levels     = ((String) jTable_design.getValueAt(i,3)).split(";");}
            if ((jTable_design.getValueAt(i,6)!=null))
            {study.design[i].factor2_levels     = ((String) jTable_design.getValueAt(i,6)).split(";");}
            
        }
        
        boolean bool_erpim_interp = jCheckBox_precompute_erpimparams_interp.isSelected();
        if (bool_erpim_interp)
        {study.precompute.erpim.interp = "on";}
        else {study.precompute.erpim.interp = "off";}
        
        boolean bool_erpim_allcomps = jCheckBox_precompute_erpimparams_allcomps.isSelected();
        if (bool_erpim_allcomps)
        {study.precompute.erpim.allcomps = "on";}
        else {study.precompute.erpim.allcomps = "off";}
        
        boolean bool_erpim_erpim = jCheckBox_precompute_erpimparams_erpim.isSelected();
        if (bool_erpim_erpim)
        {study.precompute.erpim.erpim = "on";}
        else {study.precompute.erpim.erpim = "off";}
        
        boolean bool_erpim_recompute = jCheckBox_precompute_erpimparams_recompute.isSelected();
        if (bool_erpim_recompute)
        {study.precompute.erpim.recompute = "on";}
        else {study.precompute.erpim.recompute = "off";}
        
        study.precompute.erpim.erpimparams.nlines[0] = Double.parseDouble(jTextField_precompute_erpimparams_erpim_nlines.getText());
        study.precompute.erpim.erpimparams.smoothing[0] = Double.parseDouble(jTextField_precompute_erpimparams_erpim_smoothing.getText());
        
        boolean bool_spec_interp = jCheckBox_precompute_specparams_interp.isSelected();
        if (bool_spec_interp)
        {study.precompute.spec.interp = "on";}
        else {study.precompute.spec.interp = "off";}
        
        boolean bool_spec_allcomps = jCheckBox_precompute_specparams_allcomps.isSelected();
        if (bool_spec_allcomps)
        {study.precompute.spec.allcomps = "on";}
        else {study.precompute.spec.allcomps = "off";}
        
        boolean bool_spec_spec = jCheckBox_precompute_specparams_spec.isSelected();
        if (bool_spec_spec)
        {study.precompute.spec.spec = "on";}
        else {study.precompute.spec.spec = "off";}
        
        boolean bool_spec_recompute = jCheckBox_precompute_specparams_recompute.isSelected();
        if (bool_spec_recompute)
        {study.precompute.spec.recompute = "on";}
        else {study.precompute.spec.recompute = "off";}
        
        study.precompute.spec.specparams.specmode = jTextField_precompute_specparams_spec_mode.getText();
        study.precompute.spec.specparams.freqs[0] = Double.parseDouble(jTextField_precompute_specparams_spec_freqs_low.getText());
        study.precompute.spec.specparams.freqs[1] = Double.parseDouble(jTextField_precompute_specparams_spec_freqs_high.getText());
        
        return study;
    }
    
    
    // ---------------------------------------------------------------------------
    // INIT GUI
    
    private void initTable_factors(int nb_rows)
    {
        String[] columnNames = {"factor","level","file match"}; 
        Object[][] data = new Object[nb_rows][columnNames.length];         
        jTableDM_factors = new ModelTable_factors(data,columnNames);  
        
        jTable_factors.setModel(jTableDM_factors);  
        
        DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
        centerRenderer.setHorizontalAlignment(JLabel.CENTER);
        for (int i = 0; i < columnNames.length; i++)
        {jTable_factors.getColumnModel().getColumn(i).setCellRenderer(centerRenderer);}
        
        DefaultTableCellRenderer renderer = (DefaultTableCellRenderer) jTable_factors.getTableHeader().getDefaultRenderer();
        renderer.setHorizontalAlignment(JLabel.CENTER);
    }
    
    class ModelTable_factors extends DefaultTableModel {
 
    public ModelTable_factors(Object rowData[][], Object columnNames[]) {
         super(rowData, columnNames);
      }
    
    @Override
      public Class getColumnClass(int col) {
          return String.class;  
    }
 
    @Override
      public boolean isCellEditable(int row, int col) {
        if (col == 2) 
            return false;
        else return true;
      }
    }

    
    private void initTable_design(int nb_rows)
    {
        String[] columnNames = {"name","factor1","pair1","level1","factor2","pair2","level2"};     
        Object[][] data = new Object[nb_rows][columnNames.length];         
        jTableDM_design = new ModelTable_design(data,columnNames); 
        
        jTable_design.setModel(jTableDM_design); 
        
        DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
        centerRenderer.setHorizontalAlignment(JLabel.CENTER);
        for (int i = 0; i < columnNames.length; i++)
        {jTable_design.getColumnModel().getColumn(i).setCellRenderer(centerRenderer);}
        
        DefaultTableCellRenderer renderer = (DefaultTableCellRenderer) jTable_design.getTableHeader().getDefaultRenderer();
        renderer.setHorizontalAlignment(JLabel.CENTER);
        
        JCheckBox checkBox = new JCheckBox();
        TableCellEditor editor = new DefaultCellEditor(checkBox);        
        jTable_design.getColumnModel().getColumn(2).setCellEditor(editor);        
        jTable_design.getColumnModel().getColumn(5).setCellEditor(editor);
        
        JPStudyDesign.CheckBoxRenderer checkBoxRenderer = new JPStudyDesign.CheckBoxRenderer();
        jTable_design.getColumnModel().getColumn(2).setCellRenderer(checkBoxRenderer);
        jTable_design.getColumnModel().getColumn(5).setCellRenderer(checkBoxRenderer);
    }
    
    class ModelTable_design extends DefaultTableModel {
 
    public ModelTable_design(Object rowData[][], Object columnNames[]) {
         super(rowData, columnNames);
      }
    
    @Override
      public Class getColumnClass(int col) {
          if ((col == 2)||(col == 5))
          {return JCheckBox.class;}
          else {return String.class;}
    }
 
    }
    
    public class CheckBoxRenderer extends JCheckBox implements TableCellRenderer {

          CheckBoxRenderer() {
            setHorizontalAlignment(JLabel.CENTER);
          }

          public Component getTableCellRendererComponent(JTable table, Object value,
              boolean isSelected, boolean hasFocus, int row, int column) {
            if (isSelected) {
              setForeground(table.getSelectionForeground());
              //super.setBackground(table.getSelectionBackground());
              setBackground(table.getSelectionBackground());
            } else {
              setForeground(table.getForeground());
              setBackground(table.getBackground());
            }
            setSelected((value != null && ((Boolean) value).booleanValue()));
            return this;
          }
        }
    
        
    private void initList_factor1_levels()
    {
        DefaultListModel ListMD_factor1_levels = new DefaultListModel();   
        jList_factor1_levels.setModel(ListMD_factor1_levels);
    }
    
        
    private void initList_factor2_levels()
    {
        DefaultListModel ListMD_factor2_levels = new DefaultListModel();   
        jList_factor2_levels.setModel(ListMD_factor2_levels);
    }

    
    
    // ---------------------------------------------------------------------------
    // SET GUI
    
    private void setTable_factors()
    {
        int l_factors = project.study.factors.length;
        initTable_factors(l_factors);
        
        for (int i = 0; i < l_factors; i++)
        {
            String str_chaine = new String();
            jTable_factors.setValueAt(project.study.factors[i].factor, i, 0);
            jTable_factors.setValueAt(project.study.factors[i].level, i, 1);
            if (project.study.factors[i].file_match!=null)
            {
            for (int j = 0; j < project.study.factors[i].file_match.length; j++)
            {
                if (j==0)
                {str_chaine = str_chaine + project.study.factors[i].file_match[j];}
                else
                {str_chaine = str_chaine + ";" + project.study.factors[i].file_match[j];}
            }
            }
            jTable_factors.setValueAt(str_chaine, i, 2);
        }
         
    }
    
    private void setList_file_match()
    {        
        Object[] columnName = project.epoching.condition_names; 
        DefaultListModel ListMD_FileMatch = new DefaultListModel();

        for (int i = 0; i < columnName.length; i++) 
        {ListMD_FileMatch.addElement(columnName[i]);}
         
        jList_file_match.setModel(ListMD_FileMatch);
    }

    
    private void setList_factor1_levels(String[] RowNames)
    {
        DefaultListModel ListMD_factor1_levels = new DefaultListModel();
        
        if (RowNames.length > 0)
        {
        for (int i = 0; i < RowNames.length; i++) 
        {ListMD_factor1_levels.addElement(RowNames[i]);}
        }
            
        jList_factor1_levels.setModel(ListMD_factor1_levels);
    }
    
    private void setList_factor2_levels(String[] RowNames)
    {
        DefaultListModel ListMD_factor1_levels = new DefaultListModel();
        
        if (RowNames.length > 0)
        {
        for (int i = 0; i < RowNames.length; i++) 
        {ListMD_factor1_levels.addElement(RowNames[i]);}
        }
        
        jList_factor2_levels.setModel(ListMD_factor1_levels);
    }
    
    private void setTable_design()
    {
        int l_design = project.study.design.length;
        initTable_design(l_design);
        
        for (int i = 0; i < l_design; i++) 
        {
            jTable_design.setValueAt(project.study.design[i].name, i, 0);
            jTable_design.setValueAt(project.study.design[i].factor1_name, i, 1);
            jTable_design.setValueAt(project.study.design[i].factor2_name, i, 4);
            
            boolean bool_pair1 = (project.study.design[i].factor1_pairing.equals("on"));
            boolean bool_pair2 = (project.study.design[i].factor2_pairing.equals("on"));
            jTable_design.setValueAt(bool_pair1, i, 2);
            jTable_design.setValueAt(bool_pair2, i, 5);
            
            String str_chaine1 = new String();
            if (project.study.design[i].factor1_levels!=null)
            {
            for (int j1 = 0; j1 < project.study.design[i].factor1_levels.length; j1++)
            {
                if (j1==0)
                {str_chaine1 = str_chaine1 + project.study.design[i].factor1_levels[j1];}
                else
                {str_chaine1 = str_chaine1 + ";" + project.study.design[i].factor1_levels[j1];}
            }
            }
            jTable_design.setValueAt(str_chaine1, i, 3);
            
            String str_chaine2 = new String();
            if (project.study.design[i].factor2_levels!=null)
            {
            for (int j2 = 0; j2 < project.study.design[i].factor2_levels.length; j2++)
            {
                if (j2==0)
                {str_chaine2 = str_chaine2 + project.study.design[i].factor2_levels[j2];}
                else
                {str_chaine2 = str_chaine2 + ";" + project.study.design[i].factor2_levels[j2];}
            }
            }
            jTable_design.setValueAt(str_chaine2, i, 6);
            
        }
        
    }
    
    private void setCombo_factor1InTable_design()
    {
        String[] groups     = project.subjects.group_names;
        String[] cond       = project.epoching.condition_names;
        String[] factors    = getFactors();
        
        Object[] cmbinitvalues = new Object[factors.length+2];
        for (int i = 0; i < factors.length; i++)
        {cmbinitvalues[i] = factors[i];}
        
        cmbinitvalues[factors.length] = "group";
        cmbinitvalues[factors.length+1] = "condition";
        
        JComboBox comboBox = new JComboBox(cmbinitvalues);
        TableCellEditor editor = new DefaultCellEditor(comboBox);        
        jTable_design.getColumnModel().getColumn(1).setCellEditor(editor);

    }
    
    private void setCombo_factor2InTable_design()
    {
        String[] groups     = project.subjects.group_names;
        String[] cond       = project.epoching.condition_names;
        String[] factors    = getFactors();

        Object[] cmbinitvalues = new Object[factors.length+3];
        for (int i = 0; i < factors.length; i++)
        {cmbinitvalues[i] = factors[i];}
        
        cmbinitvalues[factors.length] = "group";
        cmbinitvalues[factors.length+1] = "condition";
        
        cmbinitvalues[factors.length+2] = "";
        
        JComboBox comboBox = new JComboBox(cmbinitvalues);
        TableCellEditor editor = new DefaultCellEditor(comboBox);        
        jTable_design.getColumnModel().getColumn(4).setCellEditor(editor);
    }
    
    private String[] getFactors()
    {
        int l_factors       = project.study.factors.length;
        String[] factors    = new String[l_factors];
        int compt = 0;
        for (int i = 0; i < l_factors; i++)
        {
            if (i==0)
            {
                factors[compt] = project.study.factors[i].factor;
                compt++;
            }
            else
            {
                boolean bool_compare = false;
                for (int i2 = 0; i2 < factors.length ; i2++)
                {
                    if (project.study.factors[i].factor.equals(factors[i2]))
                    {bool_compare = true;}
                }
                if (!bool_compare)
                {
                    factors[compt] = project.study.factors[i].factor;
                    compt++;
                }
            }
        }
        
        String[] factors_resize = new String[compt];
        for (int i = 0; i < compt ; i++)
        {factors_resize[i] = factors[i];}
        
        return factors_resize;
    }
    
    private String[] getLevels(String factor_name)
    {
        int l_factors = jTable_factors.getRowCount();
        String[] tmp_levels = new String[20];
        
        int compt_levels = 0;
        for (int i = 0; i < l_factors; i++)
        {
            if (jTable_factors.getValueAt(i,0).equals(factor_name))
            {
                tmp_levels[compt_levels] = (String) jTable_factors.getValueAt(i,1);
                compt_levels++;
            }
        }
        
        String[] levels = new String[compt_levels];
        
        for (int i = 0; i < compt_levels; i++)
        {levels[i] = tmp_levels[i];}
        
        return levels;
    }
    
    
    
    

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPstudy_design = new javax.swing.JPanel();
        jLabel_factors = new javax.swing.JLabel();
        jButton_factors_remove = new javax.swing.JButton();
        jButton_factors_new = new javax.swing.JButton();
        jButton_file_match = new javax.swing.JButton();
        jScrollPane12 = new javax.swing.JScrollPane();
        jTable_factors = new javax.swing.JTable();
        jScrollPane8 = new javax.swing.JScrollPane();
        jList_file_match = new javax.swing.JList();
        jLabel_design = new javax.swing.JLabel();
        jScrollPane9 = new javax.swing.JScrollPane();
        jTable_design = new javax.swing.JTable();
        jScrollPane11 = new javax.swing.JScrollPane();
        jList_factor2_levels = new javax.swing.JList();
        jScrollPane13 = new javax.swing.JScrollPane();
        jList_factor1_levels = new javax.swing.JList();
        jLabel_factor1_levels = new javax.swing.JLabel();
        jLabel_factor2_levels = new javax.swing.JLabel();
        jButton_design_new = new javax.swing.JButton();
        jButton_design_remove = new javax.swing.JButton();
        jButton_factor1_levels_update = new javax.swing.JButton();
        jLabel_file_match = new javax.swing.JLabel();
        jCheckBox_precompute_recompute = new javax.swing.JCheckBox();
        jCheckBox_precompute_do_ersp = new javax.swing.JCheckBox();
        jCheckBox_precompute_do_erp = new javax.swing.JCheckBox();
        jCheckBox_precompute_do_spec = new javax.swing.JCheckBox();
        jCheckBox_precompute_do_erpim = new javax.swing.JCheckBox();
        jLabel_filename = new javax.swing.JLabel();
        jTextField_filename = new javax.swing.JTextField();
        jButton_factors_apply = new javax.swing.JButton();
        jLabel_study = new javax.swing.JLabel();
        jLabel_precompute_erpimparams = new javax.swing.JLabel();
        jCheckBox_precompute_erpimparams_interp = new javax.swing.JCheckBox();
        jCheckBox_precompute_erpimparams_allcomps = new javax.swing.JCheckBox();
        jCheckBox_precompute_erpimparams_recompute = new javax.swing.JCheckBox();
        jCheckBox_precompute_erpimparams_erpim = new javax.swing.JCheckBox();
        jLabel_precompute_erpimparams_erpim_nlines = new javax.swing.JLabel();
        jLabel_precompute_erpimparams_erpim_smoothing = new javax.swing.JLabel();
        jTextField_precompute_erpimparams_erpim_nlines = new javax.swing.JTextField();
        jTextField_precompute_erpimparams_erpim_smoothing = new javax.swing.JTextField();
        jLabel_precompute_specparams = new javax.swing.JLabel();
        jCheckBox_precompute_specparams_interp = new javax.swing.JCheckBox();
        jCheckBox_precompute_specparams_allcomps = new javax.swing.JCheckBox();
        jCheckBox_precompute_specparams_recompute = new javax.swing.JCheckBox();
        jCheckBox_precompute_specparams_spec = new javax.swing.JCheckBox();
        jLabel_precompute_specparams_spec_mode = new javax.swing.JLabel();
        jLabel_precompute_specparams_spec_freqs = new javax.swing.JLabel();
        jTextField_precompute_specparams_spec_mode = new javax.swing.JTextField();
        jLabel_precompute_specparams_spec_freqs_low = new javax.swing.JLabel();
        jTextField_precompute_specparams_spec_freqs_low = new javax.swing.JTextField();
        jLabel_precompute_specparams_spec_freqs_high = new javax.swing.JLabel();
        jTextField_precompute_specparams_spec_freqs_high = new javax.swing.JTextField();
        jButton_factor1_levels_apply = new javax.swing.JButton();
        jButton_factor2_levels_update = new javax.swing.JButton();
        jButton_factor2_levels_apply = new javax.swing.JButton();

        jPstudy_design.setName("study_design"); // NOI18N

        jLabel_factors.setText("EXP. FACTORS");

        jButton_factors_remove.setText("R");
        jButton_factors_remove.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_factors_removeActionPerformed(evt);
            }
        });

        jButton_factors_new.setText("N");
        jButton_factors_new.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_factors_newActionPerformed(evt);
            }
        });

        jButton_file_match.setText("Apply");
        jButton_file_match.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_file_matchActionPerformed(evt);
            }
        });

        jTable_factors.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "factor", "level", "file match"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.String.class, java.lang.String.class, java.lang.String.class
            };
            boolean[] canEdit = new boolean [] {
                true, true, false
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        jTable_factors.getTableHeader().setReorderingAllowed(false);
        jScrollPane12.setViewportView(jTable_factors);

        jScrollPane8.setViewportView(jList_file_match);

        jLabel_design.setText("DESIGN");

        jTable_design.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "Name", "factor 1", "pair1", "level 1", "factor 2", "pair 2", "level 2"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.String.class, java.lang.String.class, java.lang.Object.class, java.lang.String.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jTable_design.getTableHeader().setReorderingAllowed(false);
        jScrollPane9.setViewportView(jTable_design);

        jScrollPane11.setViewportView(jList_factor2_levels);

        jScrollPane13.setViewportView(jList_factor1_levels);

        jLabel_factor1_levels.setText(" Levels 1");

        jLabel_factor2_levels.setText("Levels 2");

        jButton_design_new.setText("N");
        jButton_design_new.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_design_newActionPerformed(evt);
            }
        });

        jButton_design_remove.setText("R");
        jButton_design_remove.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_design_removeActionPerformed(evt);
            }
        });

        jButton_factor1_levels_update.setText("Update");
        jButton_factor1_levels_update.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_factor1_levels_updateActionPerformed(evt);
            }
        });

        jLabel_file_match.setText("File match");

        jCheckBox_precompute_recompute.setText("recompute");

        jCheckBox_precompute_do_ersp.setText("do ersp");

        jCheckBox_precompute_do_erp.setText("do erp");

        jCheckBox_precompute_do_spec.setText("do spec");
        jCheckBox_precompute_do_spec.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jCheckBox_precompute_do_specStateChanged(evt);
            }
        });

        jCheckBox_precompute_do_erpim.setText("do erpim");
        jCheckBox_precompute_do_erpim.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jCheckBox_precompute_do_erpimStateChanged(evt);
            }
        });

        jLabel_filename.setText("Study filename");

        jButton_factors_apply.setText("A");
        jButton_factors_apply.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_factors_applyActionPerformed(evt);
            }
        });

        jLabel_study.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel_study.setText("Study Design");

        jLabel_precompute_erpimparams.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_precompute_erpimparams.setText("Erpim params");

        jCheckBox_precompute_erpimparams_interp.setText("interp");

        jCheckBox_precompute_erpimparams_allcomps.setText("allcomps");

        jCheckBox_precompute_erpimparams_recompute.setText("recompute");

        jCheckBox_precompute_erpimparams_erpim.setText("erpim");
        jCheckBox_precompute_erpimparams_erpim.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jCheckBox_precompute_erpimparams_erpimStateChanged(evt);
            }
        });

        jLabel_precompute_erpimparams_erpim_nlines.setText("nlines");

        jLabel_precompute_erpimparams_erpim_smoothing.setText("smoothing");

        jLabel_precompute_specparams.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_precompute_specparams.setText("Spec params");

        jCheckBox_precompute_specparams_interp.setText("interp");

        jCheckBox_precompute_specparams_allcomps.setText("allcomps");

        jCheckBox_precompute_specparams_recompute.setText("recompute");

        jCheckBox_precompute_specparams_spec.setText("spec");
        jCheckBox_precompute_specparams_spec.setActionCommand("spec");
        jCheckBox_precompute_specparams_spec.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jCheckBox_precompute_specparams_specStateChanged(evt);
            }
        });

        jLabel_precompute_specparams_spec_mode.setText("mode");

        jLabel_precompute_specparams_spec_freqs.setText("freqs");

        jLabel_precompute_specparams_spec_freqs_low.setText("low");

        jLabel_precompute_specparams_spec_freqs_high.setText("high");

        jButton_factor1_levels_apply.setText("Apply");
        jButton_factor1_levels_apply.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_factor1_levels_applyActionPerformed(evt);
            }
        });

        jButton_factor2_levels_update.setText("Update");
        jButton_factor2_levels_update.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_factor2_levels_updateActionPerformed(evt);
            }
        });

        jButton_factor2_levels_apply.setText("Apply");
        jButton_factor2_levels_apply.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_factor2_levels_applyActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPstudy_designLayout = new javax.swing.GroupLayout(jPstudy_design);
        jPstudy_design.setLayout(jPstudy_designLayout);
        jPstudy_designLayout.setHorizontalGroup(
            jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPstudy_designLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                        .addComponent(jLabel_design, javax.swing.GroupLayout.PREFERRED_SIZE, 87, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jScrollPane12)
                            .addGroup(jPstudy_designLayout.createSequentialGroup()
                                .addComponent(jButton_design_new)
                                .addGap(3, 3, 3)
                                .addComponent(jButton_design_remove)
                                .addGap(0, 0, Short.MAX_VALUE))
                            .addComponent(jScrollPane9))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jLabel_factor1_levels, javax.swing.GroupLayout.PREFERRED_SIZE, 59, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPstudy_designLayout.createSequentialGroup()
                                .addComponent(jLabel_file_match, javax.swing.GroupLayout.PREFERRED_SIZE, 64, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jButton_file_match))
                            .addGroup(jPstudy_designLayout.createSequentialGroup()
                                .addComponent(jButton_factor1_levels_update, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButton_factor1_levels_apply, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jScrollPane13, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                            .addComponent(jScrollPane8, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                        .addGap(15, 15, 15)
                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jLabel_factor2_levels, javax.swing.GroupLayout.PREFERRED_SIZE, 57, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPstudy_designLayout.createSequentialGroup()
                                .addComponent(jButton_factor2_levels_update, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButton_factor2_levels_apply, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jScrollPane11, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                        .addGap(111, 111, 111))
                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel_factors, javax.swing.GroupLayout.PREFERRED_SIZE, 87, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_filename))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPstudy_designLayout.createSequentialGroup()
                                .addComponent(jButton_factors_new)
                                .addGap(3, 3, 3)
                                .addComponent(jButton_factors_remove)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButton_factors_apply))
                            .addGroup(jPstudy_designLayout.createSequentialGroup()
                                .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                                        .addComponent(jCheckBox_precompute_recompute)
                                        .addGap(18, 18, 18)
                                        .addComponent(jCheckBox_precompute_do_erp)
                                        .addGap(18, 18, 18)
                                        .addComponent(jCheckBox_precompute_do_ersp)
                                        .addGap(18, 18, 18)
                                        .addComponent(jCheckBox_precompute_do_erpim)
                                        .addGap(18, 18, 18)
                                        .addComponent(jCheckBox_precompute_do_spec))
                                    .addComponent(jTextField_filename, javax.swing.GroupLayout.PREFERRED_SIZE, 356, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGap(60, 60, 60)
                                .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPstudy_designLayout.createSequentialGroup()
                                                .addComponent(jLabel_precompute_specparams)
                                                .addGap(297, 297, 297))
                                            .addGroup(jPstudy_designLayout.createSequentialGroup()
                                                .addGap(62, 62, 62)
                                                .addComponent(jCheckBox_precompute_specparams_interp)
                                                .addGap(18, 18, 18)
                                                .addComponent(jCheckBox_precompute_specparams_allcomps)
                                                .addGap(18, 18, 18)
                                                .addComponent(jCheckBox_precompute_specparams_recompute)
                                                .addGap(18, 18, 18)
                                                .addComponent(jCheckBox_precompute_specparams_spec)
                                                .addGap(30, 30, 30)))
                                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addGroup(jPstudy_designLayout.createSequentialGroup()
                                                .addComponent(jLabel_precompute_specparams_spec_mode)
                                                .addGap(17, 17, 17)
                                                .addComponent(jTextField_precompute_specparams_spec_mode, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE))
                                            .addGroup(jPstudy_designLayout.createSequentialGroup()
                                                .addComponent(jLabel_precompute_specparams_spec_freqs)
                                                .addGap(18, 18, 18)
                                                .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                                                        .addComponent(jLabel_precompute_specparams_spec_freqs_low)
                                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                                        .addComponent(jTextField_precompute_specparams_spec_freqs_low, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE))
                                                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                                                        .addComponent(jLabel_precompute_specparams_spec_freqs_high)
                                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                                        .addComponent(jTextField_precompute_specparams_spec_freqs_high, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE))))))
                                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addGroup(jPstudy_designLayout.createSequentialGroup()
                                                .addGap(62, 62, 62)
                                                .addComponent(jCheckBox_precompute_erpimparams_interp)
                                                .addGap(18, 18, 18)
                                                .addComponent(jCheckBox_precompute_erpimparams_allcomps)
                                                .addGap(18, 18, 18)
                                                .addComponent(jCheckBox_precompute_erpimparams_recompute)
                                                .addGap(18, 18, 18)
                                                .addComponent(jCheckBox_precompute_erpimparams_erpim))
                                            .addComponent(jLabel_precompute_erpimparams))
                                        .addGap(30, 30, 30)
                                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                            .addGroup(jPstudy_designLayout.createSequentialGroup()
                                                .addComponent(jLabel_precompute_erpimparams_erpim_nlines)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                                .addComponent(jTextField_precompute_erpimparams_erpim_nlines, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE))
                                            .addGroup(jPstudy_designLayout.createSequentialGroup()
                                                .addComponent(jLabel_precompute_erpimparams_erpim_smoothing)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                                .addComponent(jTextField_precompute_erpimparams_erpim_smoothing, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)))))))
                        .addGap(229, 229, 229))))
            .addGroup(jPstudy_designLayout.createSequentialGroup()
                .addComponent(jLabel_study)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPstudy_designLayout.setVerticalGroup(
            jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPstudy_designLayout.createSequentialGroup()
                .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                        .addComponent(jLabel_study)
                        .addGap(46, 46, 46)
                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_filename)
                            .addComponent(jTextField_filename, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel_precompute_erpimparams)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel_precompute_erpimparams_erpim_nlines)
                                .addComponent(jTextField_precompute_erpimparams_erpim_nlines, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jCheckBox_precompute_erpimparams_interp)
                            .addComponent(jCheckBox_precompute_erpimparams_allcomps)
                            .addComponent(jCheckBox_precompute_erpimparams_recompute)
                            .addComponent(jCheckBox_precompute_erpimparams_erpim)
                            .addComponent(jLabel_precompute_erpimparams_erpim_smoothing)
                            .addComponent(jTextField_precompute_erpimparams_erpim_smoothing, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 20, Short.MAX_VALUE)
                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jCheckBox_precompute_recompute)
                            .addComponent(jCheckBox_precompute_do_ersp)
                            .addComponent(jCheckBox_precompute_do_erp)
                            .addComponent(jCheckBox_precompute_do_spec)
                            .addComponent(jCheckBox_precompute_do_erpim))
                        .addGap(138, 138, 138))
                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                        .addGap(30, 30, 30)
                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPstudy_designLayout.createSequentialGroup()
                                .addComponent(jLabel_precompute_specparams)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jCheckBox_precompute_specparams_interp)
                                    .addComponent(jCheckBox_precompute_specparams_allcomps)
                                    .addComponent(jCheckBox_precompute_specparams_recompute)
                                    .addComponent(jCheckBox_precompute_specparams_spec)))
                            .addGroup(jPstudy_designLayout.createSequentialGroup()
                                .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel_precompute_specparams_spec_mode)
                                    .addComponent(jTextField_precompute_specparams_spec_mode, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGap(18, 18, 18)
                                .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel_precompute_specparams_spec_freqs)
                                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                            .addComponent(jLabel_precompute_specparams_spec_freqs_low)
                                            .addComponent(jTextField_precompute_specparams_spec_freqs_low, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                            .addComponent(jLabel_precompute_specparams_spec_freqs_high)
                                            .addComponent(jTextField_precompute_specparams_spec_freqs_high, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))))))
                .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButton_factors_remove)
                            .addComponent(jButton_factors_new)
                            .addComponent(jLabel_factors)
                            .addComponent(jButton_factors_apply))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane12, javax.swing.GroupLayout.PREFERRED_SIZE, 204, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                        .addGap(19, 19, 19)
                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_file_match)
                            .addComponent(jButton_file_match))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jScrollPane8)))
                .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButton_design_remove)
                            .addComponent(jButton_design_new)
                            .addComponent(jLabel_design))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane9, javax.swing.GroupLayout.PREFERRED_SIZE, 141, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPstudy_designLayout.createSequentialGroup()
                        .addGap(23, 23, 23)
                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_factor1_levels, javax.swing.GroupLayout.PREFERRED_SIZE, 13, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel_factor2_levels))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jScrollPane11, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                            .addComponent(jScrollPane13, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPstudy_designLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton_factor1_levels_update)
                    .addComponent(jButton_factor1_levels_apply)
                    .addComponent(jButton_factor2_levels_update)
                    .addComponent(jButton_factor2_levels_apply))
                .addGap(101, 101, 101))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPstudy_design, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(10, 10, 10))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPstudy_design, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    
    private void jButton_file_matchActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_file_matchActionPerformed
                
        Object[] obj_list_select = jList_file_match.getSelectedValues();
        String[] str_list_select = new String[obj_list_select.length];
        String test_chaine = new String();
        for (int i = 0; i < obj_list_select.length; i++) 
        {
            str_list_select[i] = obj_list_select[i].toString();
            if (i==0)
            {test_chaine = test_chaine+obj_list_select[i].toString();}
            else
            {test_chaine = test_chaine + ";" + obj_list_select[i].toString();} 
        }
        jTable_factors.setValueAt(test_chaine, jTable_factors.getSelectedRow(), 2);
    }//GEN-LAST:event_jButton_file_matchActionPerformed

    private void jButton_factors_newActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_factors_newActionPerformed
        Object[] obj=null;
        jTableDM_factors.addRow(obj);
        jTable_factors.setModel(jTableDM_factors);
    }//GEN-LAST:event_jButton_factors_newActionPerformed

    private void jButton_factors_removeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_factors_removeActionPerformed
        jTableDM_factors.removeRow(jTable_factors.getSelectedRow());
    }//GEN-LAST:event_jButton_factors_removeActionPerformed

    private void jButton_design_newActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_design_newActionPerformed
        Object[] obj=null;
        jTableDM_design.addRow(obj);
        jTable_design.setModel(jTableDM_design);
    }//GEN-LAST:event_jButton_design_newActionPerformed

    private void jButton_design_removeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_design_removeActionPerformed
        jTableDM_design.removeRow(jTable_design.getSelectedRow());
    }//GEN-LAST:event_jButton_design_removeActionPerformed

    private void jButton_factors_applyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_factors_applyActionPerformed
        Object[] cmbinitvalues = new Object[jTableDM_factors.getRowCount()];
        for (int i = 0; i < jTableDM_factors.getRowCount(); i++) 
        {cmbinitvalues[i] = jTable_factors.getValueAt(i, 0);}

        JComboBox comboBox = new JComboBox(cmbinitvalues);
        TableCellEditor editor = new DefaultCellEditor(comboBox);        
        jTable_design.getColumnModel().getColumn(1).setCellEditor(editor);        
        jTable_design.getColumnModel().getColumn(4).setCellEditor(editor);
    }//GEN-LAST:event_jButton_factors_applyActionPerformed

    private void jCheckBox_precompute_do_erpimStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jCheckBox_precompute_do_erpimStateChanged
        if (jCheckBox_precompute_do_erpim.isSelected())
        {
            jCheckBox_precompute_erpimparams_interp.setEnabled(true);
            jCheckBox_precompute_erpimparams_allcomps.setEnabled(true);
            jCheckBox_precompute_erpimparams_recompute.setEnabled(true);
            jCheckBox_precompute_erpimparams_erpim.setEnabled(true);
            
            jTextField_precompute_erpimparams_erpim_nlines.setEnabled(true);
            jTextField_precompute_erpimparams_erpim_smoothing.setEnabled(true);
        }
        else
        {
            jCheckBox_precompute_erpimparams_interp.setEnabled(false);
            jCheckBox_precompute_erpimparams_allcomps.setEnabled(false);
            jCheckBox_precompute_erpimparams_recompute.setEnabled(false);
            jCheckBox_precompute_erpimparams_erpim.setEnabled(false);
            
            jTextField_precompute_erpimparams_erpim_nlines.setEnabled(false);
            jTextField_precompute_erpimparams_erpim_smoothing.setEnabled(false);
        }
    }//GEN-LAST:event_jCheckBox_precompute_do_erpimStateChanged

    private void jCheckBox_precompute_do_specStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jCheckBox_precompute_do_specStateChanged
        if (jCheckBox_precompute_do_spec.isSelected())
        {
            jCheckBox_precompute_specparams_interp.setEnabled(true);
            jCheckBox_precompute_specparams_allcomps.setEnabled(true);
            jCheckBox_precompute_specparams_recompute.setEnabled(true);
            jCheckBox_precompute_specparams_spec.setEnabled(true);
            
            jTextField_precompute_specparams_spec_mode.setEnabled(true);
            jTextField_precompute_specparams_spec_freqs_low.setEnabled(true);
            jTextField_precompute_specparams_spec_freqs_high.setEnabled(true);
        }
        else
        {
            jCheckBox_precompute_specparams_interp.setEnabled(false);
            jCheckBox_precompute_specparams_allcomps.setEnabled(false);
            jCheckBox_precompute_specparams_recompute.setEnabled(false);
            jCheckBox_precompute_specparams_spec.setEnabled(false);
            
            jTextField_precompute_specparams_spec_mode.setEnabled(false);
            jTextField_precompute_specparams_spec_freqs_low.setEnabled(false);
            jTextField_precompute_specparams_spec_freqs_high.setEnabled(false);
        }
    }//GEN-LAST:event_jCheckBox_precompute_do_specStateChanged

    private void jCheckBox_precompute_erpimparams_erpimStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jCheckBox_precompute_erpimparams_erpimStateChanged
        if (jCheckBox_precompute_erpimparams_erpim.isSelected())
        {
            jTextField_precompute_erpimparams_erpim_nlines.setEnabled(true);
            jTextField_precompute_erpimparams_erpim_smoothing.setEnabled(true);
        }
        else
        {
            jTextField_precompute_erpimparams_erpim_nlines.setEnabled(false);
            jTextField_precompute_erpimparams_erpim_smoothing.setEnabled(false);
        }
    }//GEN-LAST:event_jCheckBox_precompute_erpimparams_erpimStateChanged

    private void jCheckBox_precompute_specparams_specStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jCheckBox_precompute_specparams_specStateChanged
        if (jCheckBox_precompute_specparams_spec.isSelected())
        {
            jTextField_precompute_specparams_spec_mode.setEnabled(true);
            jTextField_precompute_specparams_spec_freqs_low.setEnabled(true);
            jTextField_precompute_specparams_spec_freqs_high.setEnabled(true);
        }
        else
        {
            jTextField_precompute_specparams_spec_mode.setEnabled(false);
            jTextField_precompute_specparams_spec_freqs_low.setEnabled(false);
            jTextField_precompute_specparams_spec_freqs_high.setEnabled(false);
        }
    }//GEN-LAST:event_jCheckBox_precompute_specparams_specStateChanged

    private void jButton_factor1_levels_applyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_factor1_levels_applyActionPerformed
       
        if ((jList_factor1_levels.getSelectedValues().length != 0) && (jTable_design.getSelectedRow() != -1))
        {
        String factor1_value = (String) jTable_design.getValueAt(jTable_design.getSelectedRow(), 1);
        
        if (factor1_value==null)
            {}
        else if (factor1_value.equals(""))
            {}
        else
            {
        Object[] obj_list_select = jList_factor1_levels.getSelectedValues();
        
        if (jList_factor1_levels.getSelectedValues() == null){}
        else
            {
        String[] str_list_select = new String[obj_list_select.length];
        String test_chaine = new String();
            for (int i = 0; i < obj_list_select.length; i++) 
            {
            str_list_select[i] = obj_list_select[i].toString();
            if (i==0)
            {test_chaine = test_chaine+obj_list_select[i].toString();}
            else
            {test_chaine = test_chaine+";"+obj_list_select[i].toString();}
            }
        jTable_design.setValueAt(test_chaine, jTable_design.getSelectedRow(), 3);
        }
        }
    }
        
    }//GEN-LAST:event_jButton_factor1_levels_applyActionPerformed

    private void jButton_factor2_levels_applyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_factor2_levels_applyActionPerformed
        
        if ((jList_factor2_levels.getSelectedValues().length != 0) && (jTable_design.getSelectedRow() != -1))
        {
        String factor2_value = (String) jTable_design.getValueAt(jTable_design.getSelectedRow(), 4);
        
        if (factor2_value==null)
            {}
        else if (factor2_value.equals(""))
            {}
        else
            {
        Object[] obj_list_select = jList_factor2_levels.getSelectedValues();
        
        if (jList_factor2_levels.getSelectedValues() == null){}
        else
            {
        String[] str_list_select = new String[obj_list_select.length];
        String test_chaine = new String();
            for (int i = 0; i < obj_list_select.length; i++) 
            {
            str_list_select[i] = obj_list_select[i].toString();
            if (i==0)
            {test_chaine = test_chaine+obj_list_select[i].toString();}
            else
            {test_chaine = test_chaine+";"+obj_list_select[i].toString();}
            }
        jTable_design.setValueAt(test_chaine, jTable_design.getSelectedRow(), 6);
            }
            }
        }
        
    }//GEN-LAST:event_jButton_factor2_levels_applyActionPerformed

    private void jButton_factor1_levels_updateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_factor1_levels_updateActionPerformed

        if (jTable_design.getSelectedRow() != -1)
        {        
        String[] list_rows = new String[10];
        
        String[] groups     = project.subjects.group_names;
        String[] cond       = project.epoching.condition_names;
        String[] factors    = getFactors();
        
        int select_idx = jTable_design.getSelectedRow();
        
        if (jTable_design.getValueAt(select_idx, 1) !=null)
        {
            String value = (String) jTable_design.getValueAt(select_idx, 1);
            int size_finalString = 0;
        
            if (value.equals("group"))
                {
                    for (int i = 0; i < groups.length; i++)
                    {list_rows[i] = groups[i];}
                    size_finalString = groups.length;
                }
            else if (value.equals("condition"))
                {
                    for (int i = 0; i < cond.length; i++)
                    {list_rows[i] = cond[i];}
                    size_finalString = cond.length;
                }
            else
                for (int i = 0; i < factors.length; i++)
                {
                    if (value.equals(factors[i]))
                    {
                        list_rows = getLevels(value);
                        size_finalString = list_rows.length;
                    }
                }
            
            if (size_finalString>0)
            {
            String[] finalstring = Arrays.copyOfRange(list_rows,0,(size_finalString));
            setList_factor1_levels(finalstring);
            }
        }
        }
        
    }//GEN-LAST:event_jButton_factor1_levels_updateActionPerformed

    private void jButton_factor2_levels_updateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_factor2_levels_updateActionPerformed
   
        if (jTable_design.getSelectedRow() != -1)
        {        
        String[] list_rows = new String[10];
        
        String[] groups     = project.subjects.group_names;
        String[] cond       = project.epoching.condition_names;
        String[] factors    = getFactors();
        
        int select_idx = jTable_design.getSelectedRow();
        
        if (jTable_design.getValueAt(select_idx, 4) !=null)
        {
            String value = (String) jTable_design.getValueAt(select_idx, 4);
            int size_finalString = 0;
        
            if (value.equals("group"))
                {
                    for (int i = 0; i < groups.length; i++)
                    {list_rows[i] = groups[i];}
                    size_finalString = groups.length;
                }
            else if (value.equals("condition"))
                {
                    for (int i = 0; i < cond.length; i++)
                    {list_rows[i] = cond[i];}
                    size_finalString = cond.length;
                }
            else
                for (int i = 0; i < factors.length; i++)
                {
                    if (value.equals(factors[i]))
                    {
                        list_rows = getLevels(value);
                        size_finalString = list_rows.length;
                    }
                }
            if (size_finalString>0)
            {
            String[] finalstring = Arrays.copyOfRange(list_rows,0,(size_finalString));
            setList_factor2_levels(finalstring);
            }
        }
        }
            
    }//GEN-LAST:event_jButton_factor2_levels_updateActionPerformed

    

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton_design_new;
    private javax.swing.JButton jButton_design_remove;
    private javax.swing.JButton jButton_factor1_levels_apply;
    private javax.swing.JButton jButton_factor1_levels_update;
    private javax.swing.JButton jButton_factor2_levels_apply;
    private javax.swing.JButton jButton_factor2_levels_update;
    private javax.swing.JButton jButton_factors_apply;
    private javax.swing.JButton jButton_factors_new;
    private javax.swing.JButton jButton_factors_remove;
    private javax.swing.JButton jButton_file_match;
    private javax.swing.JCheckBox jCheckBox_precompute_do_erp;
    private javax.swing.JCheckBox jCheckBox_precompute_do_erpim;
    private javax.swing.JCheckBox jCheckBox_precompute_do_ersp;
    private javax.swing.JCheckBox jCheckBox_precompute_do_spec;
    private javax.swing.JCheckBox jCheckBox_precompute_erpimparams_allcomps;
    private javax.swing.JCheckBox jCheckBox_precompute_erpimparams_erpim;
    private javax.swing.JCheckBox jCheckBox_precompute_erpimparams_interp;
    private javax.swing.JCheckBox jCheckBox_precompute_erpimparams_recompute;
    private javax.swing.JCheckBox jCheckBox_precompute_recompute;
    private javax.swing.JCheckBox jCheckBox_precompute_specparams_allcomps;
    private javax.swing.JCheckBox jCheckBox_precompute_specparams_interp;
    private javax.swing.JCheckBox jCheckBox_precompute_specparams_recompute;
    private javax.swing.JCheckBox jCheckBox_precompute_specparams_spec;
    private javax.swing.JLabel jLabel_design;
    private javax.swing.JLabel jLabel_factor1_levels;
    private javax.swing.JLabel jLabel_factor2_levels;
    private javax.swing.JLabel jLabel_factors;
    private javax.swing.JLabel jLabel_file_match;
    private javax.swing.JLabel jLabel_filename;
    private javax.swing.JLabel jLabel_precompute_erpimparams;
    private javax.swing.JLabel jLabel_precompute_erpimparams_erpim_nlines;
    private javax.swing.JLabel jLabel_precompute_erpimparams_erpim_smoothing;
    private javax.swing.JLabel jLabel_precompute_specparams;
    private javax.swing.JLabel jLabel_precompute_specparams_spec_freqs;
    private javax.swing.JLabel jLabel_precompute_specparams_spec_freqs_high;
    private javax.swing.JLabel jLabel_precompute_specparams_spec_freqs_low;
    private javax.swing.JLabel jLabel_precompute_specparams_spec_mode;
    private javax.swing.JLabel jLabel_study;
    private javax.swing.JList jList_factor1_levels;
    private javax.swing.JList jList_factor2_levels;
    private javax.swing.JList jList_file_match;
    private javax.swing.JPanel jPstudy_design;
    private javax.swing.JScrollPane jScrollPane11;
    private javax.swing.JScrollPane jScrollPane12;
    private javax.swing.JScrollPane jScrollPane13;
    private javax.swing.JScrollPane jScrollPane8;
    private javax.swing.JScrollPane jScrollPane9;
    private javax.swing.JTable jTable_design;
    private javax.swing.JTable jTable_factors;
    private javax.swing.JTextField jTextField_filename;
    private javax.swing.JTextField jTextField_precompute_erpimparams_erpim_nlines;
    private javax.swing.JTextField jTextField_precompute_erpimparams_erpim_smoothing;
    private javax.swing.JTextField jTextField_precompute_specparams_spec_freqs_high;
    private javax.swing.JTextField jTextField_precompute_specparams_spec_freqs_low;
    private javax.swing.JTextField jTextField_precompute_specparams_spec_mode;
    // End of variables declaration//GEN-END:variables
}
