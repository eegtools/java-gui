/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gui;

import java.util.Arrays;
import javax.swing.DefaultCellEditor;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellEditor;
import structures.Paths;
import structures.Project;
import structures.Subjects;
import structures.SubjectsData;

/**
 *
 * @author PHilt
 */
public class JPSubjects extends javax.swing.JPanel {

    private JTPMain controller;
    public Subjects subjects;
    public Project project;
    
    ModelTable_subjects jTableDM_subjects;
    ModelTable_groups jTableDM_groups;
    ModelTable_frequency_bands_list jTableDM_frequency_bands_list;
    
    
    public JPSubjects(JTPMain ctrl) {
        initComponents();
        controller = ctrl;
    }
    
    public void initGUI(Project proj)
    {
        initSubjectsTable(1);
        initGroupTable(1);
        initFreqBandTable(1);
    }
    
    public void setGUI(Project proj)
    {
        project = proj;
        subjects = project.subjects;

        setTable_groups();
        setTable_frequency_bands_list();
                
        setTable_subjects();
        setCombo_groupsInTable_subjects();
    }
    
    public Subjects getGUI()
    {
        subjects.numsubj[0]    = 0;
        subjects.numsubj[0]    = (double) jTable_subjects.getRowCount();
        
        getTable_subjects();

        subjects.group_names = new String[jTable_groups.getRowCount()];
        for (int i2 = 0; i2 < jTable_groups.getRowCount(); i2++) 
        {subjects.group_names[i2] = (String) jTable_groups.getValueAt(i2, 0);}

        return subjects;
    }
    
    
    // ---------------------------------------------------------------------------
    // INIT GUI
    
    private void initSubjectsTable(int nb_rows)
    {
        String[] columnNames = {"name","group","age","gender","handedness","bad_ch","freq bands"}; 
        Object[][] data = new Object[nb_rows][columnNames.length];        
        jTableDM_subjects = new ModelTable_subjects(data,columnNames);
        jTable_subjects.setModel(jTableDM_subjects); 
        
        jTable_subjects.getColumnModel().getColumn(0).setPreferredWidth(100);
        jTable_subjects.getColumnModel().getColumn(1).setPreferredWidth(40);
        jTable_subjects.getColumnModel().getColumn(2).setPreferredWidth(40);
        jTable_subjects.getColumnModel().getColumn(3).setPreferredWidth(40);
        jTable_subjects.getColumnModel().getColumn(4).setPreferredWidth(40);
        jTable_subjects.getColumnModel().getColumn(5).setPreferredWidth(100);
        jTable_subjects.getColumnModel().getColumn(6).setPreferredWidth(100);
        
        DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
        centerRenderer.setHorizontalAlignment(JLabel.CENTER);
        for (int i = 0; i < columnNames.length; i++)
        {jTable_subjects.getColumnModel().getColumn(i).setCellRenderer(centerRenderer);}
    }
    
    class ModelTable_subjects extends DefaultTableModel {
 
    public ModelTable_subjects(Object rowData[][], Object columnNames[]) {
         super(rowData, columnNames);
      }
    
    @Override
      public Class getColumnClass(int col) {
        if (col == 2)  
            return Double.class;
        else return String.class;  
    }
 
    @Override
      public boolean isCellEditable(int row, int col) {
        if (col == 6) 
            return false;
        else return true;
      }
    }
    
    private void initGroupTable(int nb_rows)
    {
        String[] columnNames = {"group"}; 
        Object[][] data = new Object[nb_rows][columnNames.length];        
        jTableDM_groups = new ModelTable_groups(data, columnNames);
        jTable_groups.setModel(jTableDM_groups);  
    }
    
    class ModelTable_groups extends DefaultTableModel {
 
    public ModelTable_groups(Object rowData[][], Object columnNames[]) {
         super(rowData, columnNames);
      }
    
    @Override
      public Class getColumnClass(int col) {
        return String.class;
    }
    }
    
    private void initFreqBandTable(int nb_rows)
    {
        String[] columnNames = {"start F","end F"}; 
        Object[][] data = new Object[nb_rows][columnNames.length];        
        jTableDM_frequency_bands_list = new ModelTable_frequency_bands_list(data,columnNames);
        jTable_frequency_bands_list.setModel(jTableDM_frequency_bands_list); 
        
        DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
        centerRenderer.setHorizontalAlignment(JLabel.CENTER);
        for (int j = 0; j < jTable_frequency_bands_list.getColumnCount(); j++) 
        {jTable_frequency_bands_list.getColumnModel().getColumn(j).setCellRenderer(centerRenderer);}
        
        DefaultTableCellRenderer renderer = (DefaultTableCellRenderer) jTable_frequency_bands_list.getTableHeader().getDefaultRenderer();
        renderer.setHorizontalAlignment(JLabel.CENTER);
    }
    
    class ModelTable_frequency_bands_list extends DefaultTableModel {
 
    public ModelTable_frequency_bands_list(Object rowData[][], Object columnNames[]) {
         super(rowData, columnNames);
      }
    
    @Override
      public Class getColumnClass(int col) {
        return String.class;
    }
    }
    
    
    // ---------------------------------------------------------------------------
    // SET GUI
    
    private void setTable_subjects()
    {
        int l_subjects = project.subjects.data.length;
        initSubjectsTable(l_subjects);
        
        for (int i = 0; i < l_subjects; i++)
        {
            jTableDM_subjects.setValueAt(project.subjects.data[i].name, i, 0);
            jTableDM_subjects.setValueAt(project.subjects.data[i].group, i, 1);
            jTableDM_subjects.setValueAt(project.subjects.data[i].age[0], i, 2);
            jTableDM_subjects.setValueAt(project.subjects.data[i].gender, i, 3);
            jTableDM_subjects.setValueAt(project.subjects.data[i].handedness, i, 4);
            
            
            String str_chaine = "";
            if (project.subjects.data[i].bad_ch!=null)
            {
            int l_bad_ch = project.subjects.data[i].bad_ch.length;
            for (int j = 0; j < l_bad_ch ; j++)
            {
                if (j==0)
                {str_chaine = str_chaine + project.subjects.data[i].bad_ch[j];}
                else
                {str_chaine = str_chaine + "," + project.subjects.data[i].bad_ch[j];}
            }
            }
            jTable_subjects.setValueAt(str_chaine, i, 5);
            
            
            String str_chaine2 = "";
            if (project.subjects.data[i].frequency_bands_list!=null)
            {
            int l_frequency_bands_list = project.subjects.data[i].frequency_bands_list.length;
            for (int j = 0; j < l_frequency_bands_list ; j++)
            {
                String freqband = project.subjects.data[i].frequency_bands_list[j];
                if (j==0)
                {str_chaine2 = str_chaine2 + freqband;}
                else
                {str_chaine2 = str_chaine2 + ";" + freqband;}
            }
            }
            jTable_subjects.setValueAt(str_chaine2, i, 6);
        }
    }
    
    private void setTable_groups()
    {
        int l_groups = project.subjects.group_names.length;
        initGroupTable(l_groups);
        
        for (int j = 0; j < l_groups ; j++)
            {
                jTable_groups.setValueAt(project.subjects.group_names[j], j, 0);
            }
    }
    
    private void setTable_frequency_bands_list()
    {
        int l_data = project.subjects.data.length;
        int l_max = 0;
        for (int i = 0; i < l_data ; i++)
        {if (project.subjects.data[i].frequency_bands_list!=null)
            {l_max = l_max + project.subjects.data[i].frequency_bands_list.length;}}
        
        int compt = 0;
        String[] new_frequency_bands_list = new String[l_max];
        for (int i = 0; i < l_data ; i++)
        {
            if (project.subjects.data[i].frequency_bands_list!=null)
            {
            String[] frequency_bands_list = project.subjects.data[i].frequency_bands_list;
            for (int j = 0; j < frequency_bands_list.length ; j++)
            {
                if (i==0 && j==0)
                {
                    new_frequency_bands_list[compt] = frequency_bands_list[j];
                    compt++;
                }
                else
                {
                    boolean bool_compare = false;
                    for (int i2 = 0; i2 < new_frequency_bands_list.length ; i2++)
                    {
                        if (frequency_bands_list[j].equals(new_frequency_bands_list[i2]))
                        {bool_compare = true;}
                    }
                    if (!bool_compare)
                    {
                        new_frequency_bands_list[compt] = frequency_bands_list[j];
                        compt++;
                    }
                }
            }
            }
        }
        
        initFreqBandTable(compt);
        
        for (int i = 0; i < new_frequency_bands_list.length ; i++)
        {
            if (new_frequency_bands_list[i]!=null)
            {
            String debF = new_frequency_bands_list[i].substring(new_frequency_bands_list[i].indexOf("[")+1, new_frequency_bands_list[i].indexOf(","));
            String endF = new_frequency_bands_list[i].substring(new_frequency_bands_list[i].indexOf(",")+1, new_frequency_bands_list[i].indexOf("]"));
            jTable_frequency_bands_list.setValueAt(debF, i, 0);
            jTable_frequency_bands_list.setValueAt(endF, i, 1);
            }
        }
    }
    
    private void setCombo_groupsInTable_subjects()
    {
        int l_groups = jTable_groups.getRowCount();
        Object[] cmbinitvalues = new Object[l_groups];
        
        for (int i = 0; i < l_groups; i++)
        {
            cmbinitvalues[i] = jTable_groups.getValueAt(i, 0);
        }
        
        JComboBox comboBox = new JComboBox(cmbinitvalues);
        TableCellEditor editor = new DefaultCellEditor(comboBox);        
        jTable_subjects.getColumnModel().getColumn(1).setCellEditor(editor);
    }
    
        
    
    // ---------------------------------------------------------------------------
    // GET GUI
    
    private void getTable_subjects()
    {                 
        int[] c             = new int[jTable_groups.getRowCount()];
        Arrays.fill(c,0);
        int num_subj        = jTable_subjects.getRowCount();
        subjects.list       = new String[num_subj];
        subjects.data       = new SubjectsData[num_subj];
        for (int i1 = 0; i1 < num_subj; i1++) 
        {
            subjects.data[i1] = new SubjectsData();
        }
        for (int i1 = 0; i1 < num_subj; i1++) 
        {
            subjects.list[i1]                       = (String) jTable_subjects.getValueAt(i1, 0);
            
            subjects.data[i1].name                  = (String) jTable_subjects.getValueAt(i1, 0);
            subjects.data[i1].group                 = (String) jTable_subjects.getValueAt(i1, 1);
            subjects.data[i1].age[0]                = (Double) jTable_subjects.getValueAt(i1, 2);
            subjects.data[i1].gender                = (String) jTable_subjects.getValueAt(i1, 3);
            subjects.data[i1].handedness            = (String) jTable_subjects.getValueAt(i1, 4);
            
            if (jTable_subjects.getValueAt(i1, 5)!=null)
            {
            String str_bad_ch                       = (String) jTable_subjects.getValueAt(i1, 5);
            subjects.data[i1].bad_ch                = new String[str_bad_ch.length()];
            subjects.data[i1].bad_ch                = str_bad_ch.split(";");
            }
            
            if (jTable_subjects.getValueAt(i1, 6)!=null)
            {
            String str_freq_bands                   = (String) jTable_subjects.getValueAt(i1, 6);
            subjects.data[i1].frequency_bands_list  = new String[str_freq_bands.length()];
            subjects.data[i1].frequency_bands_list  = str_freq_bands.split(";");
            }

            
            String str_grpe = (String) jTable_subjects.getValueAt(i1, 1);
            for (int j1 = 0; j1 < jTable_groups.getRowCount(); j1++) 
            {
                String str2test = (String) jTable_groups.getValueAt(j1, 0);
                if (str_grpe.equals(str2test))
                {
                    //subjects.groups[j1][c[j1]] = subjects.data[i1].name;
                    c[j1]++;
                }
            }
        }
        
        int max_l_c = 0;
        for (int i = 0; i < c.length; i++) 
        {if (c[i] > max_l_c)
             {max_l_c = c[i];}}
        
        int[] compt = new int[jTable_groups.getRowCount()];
        Arrays.fill(compt,0);
        subjects.groups = new String[jTable_groups.getRowCount()][max_l_c];
        for (int i = 0; i < num_subj; i++) 
        {
        String str_grpe = (String) jTable_subjects.getValueAt(i, 1);
            for (int j = 0; j < jTable_groups.getRowCount(); j++) 
            {
                String str2test = (String) jTable_groups.getValueAt(j, 0);
                if (str_grpe.equals(str2test))
                {
                    subjects.groups[j][compt[j]] = subjects.data[i].name;
                    compt[j]++;
                }
            }
        }
    }
    

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jScrollPane1 = new javax.swing.JScrollPane();
        jTable_subjects = new javax.swing.JTable();
        jButton_groups_new = new javax.swing.JButton();
        jButton__groups_apply = new javax.swing.JButton();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTable_frequency_bands_list = new javax.swing.JTable();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTable_groups = new javax.swing.JTable();
        jButton_frequency_bands_list_new = new javax.swing.JButton();
        jButton_frequency_bands_list_remove = new javax.swing.JButton();
        jButton_subjects_remove = new javax.swing.JButton();
        jButton_subjects_new = new javax.swing.JButton();
        jButton_subjects_clear = new javax.swing.JButton();
        jButton_groups_remove = new javax.swing.JButton();
        jButton_frequency_bands_list_apply = new javax.swing.JButton();
        jLabel_subjects = new javax.swing.JLabel();

        jTable_subjects.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "name", "group", "age", "gender", "handedness", "bad_ch", "freq bands"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.String.class, java.lang.String.class, java.lang.Integer.class, java.lang.String.class, java.lang.String.class, java.lang.String.class, java.lang.String.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jScrollPane1.setViewportView(jTable_subjects);

        jButton_groups_new.setText("N");
        jButton_groups_new.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_groups_newActionPerformed(evt);
            }
        });

        jButton__groups_apply.setText("A");
        jButton__groups_apply.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton__groups_applyActionPerformed(evt);
            }
        });

        jTable_frequency_bands_list.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null},
                {null, null},
                {null, null},
                {null, null}
            },
            new String [] {
                "start F", "end F"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.Double.class, java.lang.Double.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jScrollPane2.setViewportView(jTable_frequency_bands_list);

        jTable_groups.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null},
                {null},
                {null},
                {null}
            },
            new String [] {
                "Group"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.String.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jScrollPane3.setViewportView(jTable_groups);

        jButton_frequency_bands_list_new.setText("N");
        jButton_frequency_bands_list_new.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_frequency_bands_list_newActionPerformed(evt);
            }
        });

        jButton_frequency_bands_list_remove.setText("R");
        jButton_frequency_bands_list_remove.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_frequency_bands_list_removeActionPerformed(evt);
            }
        });

        jButton_subjects_remove.setText("Remove Subject");
        jButton_subjects_remove.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_subjects_removeActionPerformed(evt);
            }
        });

        jButton_subjects_new.setText("New Subject");
        jButton_subjects_new.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_subjects_newActionPerformed(evt);
            }
        });

        jButton_subjects_clear.setText("Clear Tab");
        jButton_subjects_clear.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_subjects_clearActionPerformed(evt);
            }
        });

        jButton_groups_remove.setText("R");
        jButton_groups_remove.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_groups_removeActionPerformed(evt);
            }
        });

        jButton_frequency_bands_list_apply.setText("A");
        jButton_frequency_bands_list_apply.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_frequency_bands_list_applyActionPerformed(evt);
            }
        });

        jLabel_subjects.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel_subjects.setText("Subjects");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGap(25, 25, 25)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 937, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jButton_subjects_new, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(18, 18, 18)
                                .addComponent(jButton_subjects_remove)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jButton_subjects_clear, javax.swing.GroupLayout.PREFERRED_SIZE, 110, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(18, 18, 18)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jButton_groups_new)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButton_groups_remove, javax.swing.GroupLayout.PREFERRED_SIZE, 39, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jButton__groups_apply, javax.swing.GroupLayout.PREFERRED_SIZE, 39, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jButton_frequency_bands_list_new)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButton_frequency_bands_list_remove, javax.swing.GroupLayout.PREFERRED_SIZE, 39, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButton_frequency_bands_list_apply, javax.swing.GroupLayout.PREFERRED_SIZE, 39, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                            .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jLabel_subjects)))
                .addContainerGap(41, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGap(10, 10, 10)
                .addComponent(jLabel_subjects)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 31, Short.MAX_VALUE)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton_groups_new)
                    .addComponent(jButton__groups_apply)
                    .addComponent(jButton_subjects_remove)
                    .addComponent(jButton_subjects_new)
                    .addComponent(jButton_subjects_clear)
                    .addComponent(jButton_groups_remove))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 129, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(31, 31, 31)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButton_frequency_bands_list_new)
                            .addComponent(jButton_frequency_bands_list_remove)
                            .addComponent(jButton_frequency_bands_list_apply))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 570, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(118, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButton_subjects_newActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_subjects_newActionPerformed
        Object[] obj=null;
        jTableDM_subjects.addRow(obj);
        jTable_subjects.setModel(jTableDM_subjects);
    }//GEN-LAST:event_jButton_subjects_newActionPerformed

    private void jButton_subjects_clearActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_subjects_clearActionPerformed
        initSubjectsTable(1);
    }//GEN-LAST:event_jButton_subjects_clearActionPerformed

    private void jButton_groups_newActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_groups_newActionPerformed
        Object[] obj=null;
        jTableDM_groups.addRow(obj);
        jTable_groups.setModel(jTableDM_groups);
    }//GEN-LAST:event_jButton_groups_newActionPerformed

    private void jButton_frequency_bands_list_newActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_frequency_bands_list_newActionPerformed
        Object[] obj=null;
        jTableDM_frequency_bands_list.addRow(obj);
        jTable_frequency_bands_list.setModel(jTableDM_frequency_bands_list);
    }//GEN-LAST:event_jButton_frequency_bands_list_newActionPerformed

    private void jButton_subjects_removeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_subjects_removeActionPerformed
        jTableDM_subjects.removeRow(jTable_subjects.getSelectedRow());
    }//GEN-LAST:event_jButton_subjects_removeActionPerformed

    private void jButton_frequency_bands_list_removeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_frequency_bands_list_removeActionPerformed
        jTableDM_frequency_bands_list.removeRow(jTable_frequency_bands_list.getSelectedRow());
    }//GEN-LAST:event_jButton_frequency_bands_list_removeActionPerformed

    private void jButton_groups_removeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_groups_removeActionPerformed
        jTableDM_groups.removeRow(jTable_groups.getSelectedRow());
    }//GEN-LAST:event_jButton_groups_removeActionPerformed

    private void jButton_frequency_bands_list_applyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_frequency_bands_list_applyActionPerformed
        int[] idx_select = jTable_frequency_bands_list.getSelectedRows();
        String test_chaine = new String();
        for (int i = 0; i < idx_select.length; i++) 
        {
            String debF = (String) jTable_frequency_bands_list.getValueAt(idx_select[i], 0);
            String endF = (String) jTable_frequency_bands_list.getValueAt(idx_select[i], 1);
            
            if (i==0)
            {test_chaine = test_chaine + "[" + debF + "," + endF + "]";}
            else
            {test_chaine = test_chaine + ";[" + debF + "," + endF + "]";}
        }
        jTableDM_subjects.setValueAt(test_chaine, jTable_subjects.getSelectedRow(), 6);
    }//GEN-LAST:event_jButton_frequency_bands_list_applyActionPerformed

    private void jButton__groups_applyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton__groups_applyActionPerformed
        setCombo_groupsInTable_subjects();
        /*
        int idx_select = jTable_groups.getSelectedRow();
        String str_grp = (String) jTable_groups.getValueAt(idx_select, 0);
        jTableDM_Subjects.setValueAt(str_grp, jTable_subjects.getSelectedRow(), 1);
        */
    }//GEN-LAST:event_jButton__groups_applyActionPerformed

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton__groups_apply;
    private javax.swing.JButton jButton_frequency_bands_list_apply;
    private javax.swing.JButton jButton_frequency_bands_list_new;
    private javax.swing.JButton jButton_frequency_bands_list_remove;
    private javax.swing.JButton jButton_groups_new;
    private javax.swing.JButton jButton_groups_remove;
    private javax.swing.JButton jButton_subjects_clear;
    private javax.swing.JButton jButton_subjects_new;
    private javax.swing.JButton jButton_subjects_remove;
    private javax.swing.JLabel jLabel_subjects;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JTable jTable_frequency_bands_list;
    private javax.swing.JTable jTable_groups;
    private javax.swing.JTable jTable_subjects;
    // End of variables declaration//GEN-END:variables
}
