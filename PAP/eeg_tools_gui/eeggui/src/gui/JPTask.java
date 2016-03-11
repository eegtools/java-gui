/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gui;

import java.awt.Dimension;
import javax.swing.DefaultListCellRenderer;
import javax.swing.DefaultListModel;
import javax.swing.JLabel;
import javax.swing.table.*;
import structures.*;

/**
 *
 * @author inuggi
 */
public class JPTask extends javax.swing.JPanel {

    private JTPMain controller;
    public Task task;
    public Project project;
    ModelTable_trigger jTableDM_trigger;
    ModelTable_mrkcode jTableDM_mrkcode;
    
    public JPTask(JTPMain ctrl) {
        initComponents();
        controller = ctrl;
    }
    
    public void initGUI()
    {
        initTable_trigger();
        initTable_mrkcode();
    }
    
    public void setGUI(Project proj)
    {
        project = proj;
        task = project.task;
        
        initGUI();
        
        setTable_trigger();
        setTable_mrkcode();
        setList_import_marker();
    }
    
    public Task getGUI()
    {
        getTable_trigger();
        getTable_mrkcode();
        
        return task;
    }
    
    // ---------------------------------------------------------------------------
    // INIT GUI
    private void initTable_trigger()
    {
        String[] columnNames = {"name","value"}; 
        int l_line = 0;
        if (project.task.events.others_trigger_value!=null)
        {l_line = project.task.events.others_trigger_value.length;}     
        Object[][] data = new Object[8+l_line][columnNames.length];
        jTableDM_trigger = new ModelTable_trigger(data,columnNames);  
        jTable_trigger.setModel(jTableDM_trigger);  
        
        jTable_trigger.getColumnModel().getColumn(0).setPreferredWidth(100);
        jTable_trigger.getColumnModel().getColumn(1).setPreferredWidth(20);
    }
    
    class ModelTable_trigger extends DefaultTableModel {
 
    public ModelTable_trigger(Object rowData[][], Object columnNames[]) {
         super(rowData, columnNames);
        }
    
    @Override
      public Class getColumnClass(int col) {
        return String.class;  
        }
 
    @Override
      public boolean isCellEditable(int row, int col) {
        if (row < 8) 
            return false;
        else return true;
        }
    }
    
    private void initTable_mrkcode()
    {     
        int nb_lin =  project.task.events.mrkcode_cond.length;
        int nb_col =  project.task.events.mrkcode_cond[0].length;
        
        String[] columnNames = new String[nb_col]; 
        for  (int i = 0; i < nb_col; i++)
        {columnNames[i] = String.valueOf(i);}

        Object[][] data = new Object[nb_lin][nb_col];          
        
        jTableDM_mrkcode = new ModelTable_mrkcode(data,columnNames);  
        jTable_mrkcode.setModel(jTableDM_mrkcode);  
    }
    

    class ModelTable_mrkcode extends DefaultTableModel {

        public ModelTable_mrkcode(Object rowData[][], Object columnNames[]) {
         super(rowData, columnNames);
        }
        
        @Override
        public Class getColumnClass(int col) {
        return Integer.class;
        }
    }
    
    
    // ---------------------------------------------------------------------------
    // SET GUI
    public void setTable_trigger()
    {
        jTable_trigger.setValueAt("start experiment", 0, 0);
        jTable_trigger.setValueAt("pause experiment", 1, 0);
        jTable_trigger.setValueAt("resume experiment", 2, 0);
        jTable_trigger.setValueAt("end experiment", 3, 0);
        jTable_trigger.setValueAt("start baseline", 4, 0);
        jTable_trigger.setValueAt("end baseline", 5, 0);
        jTable_trigger.setValueAt("start trial", 6, 0);
        jTable_trigger.setValueAt("end trial", 7, 0);
        
        jTable_trigger.setValueAt(project.task.events.start_experiment_trigger_value, 0, 1);
        jTable_trigger.setValueAt(project.task.events.pause_trigger_value, 1, 1);
        jTable_trigger.setValueAt(project.task.events.resume_trigger_value, 2, 1);
        jTable_trigger.setValueAt(project.task.events.end_experiment_trigger_value, 3, 1);
        jTable_trigger.setValueAt(project.task.events.baseline_start_trigger_value, 4, 1);
        jTable_trigger.setValueAt(project.task.events.baseline_end_trigger_value, 5, 1);
        jTable_trigger.setValueAt(project.task.events.trial_start_trigger_value, 6, 1);
        jTable_trigger.setValueAt(project.task.events.trial_end_trigger_value, 7, 1);

        if (project.task.events.others_trigger_value!=null)
        {
            int compt = 0;
            {for (int i = 0; i < project.task.events.others_trigger_value.length/2; i++)
                {
                jTable_trigger.setValueAt(project.task.events.others_trigger_value[compt], 8+i, 0);
                jTable_trigger.setValueAt(project.task.events.others_trigger_value[compt+1], 8+i, 1);
                compt = compt+2;
                }
            }
        }
        
        DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
        centerRenderer.setHorizontalAlignment(JLabel.CENTER);
        jTable_trigger.getColumnModel().getColumn(1).setCellRenderer(centerRenderer);
        
        DefaultTableCellRenderer renderer = (DefaultTableCellRenderer) jTable_trigger.getTableHeader().getDefaultRenderer();
        renderer.setHorizontalAlignment(JLabel.CENTER);
    }
    
    public void setTable_mrkcode()
    {
        int nb_lin =  project.task.events.mrkcode_cond.length;
        int nb_col =  project.task.events.mrkcode_cond[0].length;

        for (int i = 0; i < nb_lin; i++) 
        {for (int j = 0; j < nb_col; j++) 
            {jTable_mrkcode.setValueAt(project.task.events.mrkcode_cond[i][j], i, j);}}

        DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
        centerRenderer.setHorizontalAlignment(JLabel.CENTER);
        for  (int i = 0; i < jTable_mrkcode.getColumnCount(); i++)
        {jTable_mrkcode.getColumnModel().getColumn(i).setCellRenderer(centerRenderer);}
        
        DefaultTableCellRenderer renderer = (DefaultTableCellRenderer) jTable_mrkcode.getTableHeader().getDefaultRenderer();
        renderer.setHorizontalAlignment(JLabel.CENTER);
    }
    
    public void setList_import_marker()
    {
        DefaultListModel ListMD_import_marker = new DefaultListModel();
        for (int i1 = 0; i1 < jTable_trigger.getRowCount(); i1++) 
        {
            ListMD_import_marker.addElement(jTable_trigger.getModel().getValueAt(i1,1));
        }
        for (int i2 = 0; i2 < jTable_mrkcode.getRowCount(); i2++) 
        {
            for (int j2 = 0; j2 < jTable_mrkcode.getColumnCount(); j2++) 
            {
            ListMD_import_marker.addElement(jTable_mrkcode.getModel().getValueAt(i2,j2));
            }
        }
        jList_import_marker.setModel(ListMD_import_marker); 
        //jList_import_marker.enable(false);
        
        DefaultListCellRenderer renderer =  (DefaultListCellRenderer)jList_import_marker.getCellRenderer();  
        renderer.setHorizontalAlignment(JLabel.CENTER); 
    }
    
    
    // ---------------------------------------------------------------------------
    // GET GUI
    public void getTable_trigger()
    {
        task.events.trial_start_trigger_value = (String) jTable_trigger.getModel().getValueAt(0,1);
        task.events.trial_start_trigger_value = (String) jTable_trigger.getModel().getValueAt(1,1);
        task.events.trial_start_trigger_value = (String) jTable_trigger.getModel().getValueAt(2,1);
        task.events.trial_start_trigger_value = (String) jTable_trigger.getModel().getValueAt(3,1);
        task.events.trial_start_trigger_value = (String) jTable_trigger.getModel().getValueAt(4,1);
        task.events.trial_start_trigger_value = (String) jTable_trigger.getModel().getValueAt(5,1);
        task.events.trial_start_trigger_value = (String) jTable_trigger.getModel().getValueAt(6,1);
        task.events.trial_start_trigger_value = (String) jTable_trigger.getModel().getValueAt(7,1);
                
        task.events.import_marker[0] = (String) jTable_trigger.getModel().getValueAt(0,1);
        task.events.import_marker[1] = (String) jTable_trigger.getModel().getValueAt(1,1);
        task.events.import_marker[2] = (String) jTable_trigger.getModel().getValueAt(2,1);
        task.events.import_marker[3] = (String) jTable_trigger.getModel().getValueAt(3,1);
        task.events.import_marker[4] = (String) jTable_trigger.getModel().getValueAt(4,1);
        task.events.import_marker[5] = (String) jTable_trigger.getModel().getValueAt(5,1);
        task.events.import_marker[6] = (String) jTable_trigger.getModel().getValueAt(6,1);
        task.events.import_marker[7] = (String) jTable_trigger.getModel().getValueAt(7,1);

        int l_triggers = jTable_trigger.getRowCount();
        int nb_mrkcode = jTable_mrkcode.getRowCount()*jTable_mrkcode.getColumnCount();
        task.events.import_marker = new String[l_triggers+nb_mrkcode];
        for (int i = 0; i < l_triggers; i++)
            {
                task.events.import_marker[i] = (String) jTable_trigger.getValueAt(i,1);
            }
        
        if (l_triggers>8)
        {
            int line_supp = l_triggers-8;
            task.events.others_trigger_value = new String[line_supp*2];
            int compt = 0;
            {for (int i = 0; i < line_supp; i++)
                {
                    task.events.others_trigger_value[compt] = (String) jTable_trigger.getValueAt(8+i,0);
                    task.events.others_trigger_value[compt+1] = (String) jTable_trigger.getValueAt(8+i,1);
                    compt = compt+2;
                }
            }
        }
        
    }
    
    public void getTable_mrkcode()
    {
        int l_triggers = jTable_trigger.getRowCount();
        int nb_lin = jTable_mrkcode.getRowCount();
        int nb_col = jTable_mrkcode.getColumnCount();
        task.events.mrkcode_cond = new String[nb_lin][nb_col];
        task.events.valid_marker = new String[nb_lin*nb_col];
        int compt = 0;
        for (int i = 0; i < nb_lin; i++) 
        {
            for (int j = 0; j < nb_col; j++) 
            {
                task.events.mrkcode_cond[i][j] = (String) jTable_mrkcode.getModel().getValueAt(i,j);
                task.events.valid_marker[compt] = (String) jTable_mrkcode.getModel().getValueAt(i,j);
                task.events.import_marker[compt+l_triggers] = (String) jTable_mrkcode.getModel().getValueAt(i,j);
                compt++;
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
        jTable_trigger = new javax.swing.JTable();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTable_mrkcode = new javax.swing.JTable();
        jLabel_mrkcode = new javax.swing.JLabel();
        jButton_trigger_new = new javax.swing.JButton();
        jButton_trigger_remove = new javax.swing.JButton();
        jButton_mrkcode_addRow = new javax.swing.JButton();
        jButton_mrkcode_removeRow = new javax.swing.JButton();
        jLabel_mrkcode_row = new javax.swing.JLabel();
        jButton_mrkcode_addCol = new javax.swing.JButton();
        jButton_mrkcode_removeCol = new javax.swing.JButton();
        jLabel_mrkcode_col = new javax.swing.JLabel();
        jLabel_import_marker = new javax.swing.JLabel();
        jScrollPane3 = new javax.swing.JScrollPane();
        jList_import_marker = new javax.swing.JList();
        jButton_import_marker_remove = new javax.swing.JButton();
        jLabel_trigger = new javax.swing.JLabel();
        jButton_import_marker_update = new javax.swing.JButton();
        jButton_mrkcode_clear = new javax.swing.JButton();
        jButton_trigger_clear = new javax.swing.JButton();
        jLabel_task = new javax.swing.JLabel();

        jTable_trigger.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {

            }
        ));
        jTable_trigger.setName("JTab_Triggers"); // NOI18N
        jScrollPane1.setViewportView(jTable_trigger);

        jTable_mrkcode.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {

            }
        ));
        jScrollPane2.setViewportView(jTable_mrkcode);

        jLabel_mrkcode.setText("Condition markers");

        jButton_trigger_new.setText("New");
        jButton_trigger_new.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_trigger_newActionPerformed(evt);
            }
        });

        jButton_trigger_remove.setText("Remove");
        jButton_trigger_remove.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_trigger_removeActionPerformed(evt);
            }
        });

        jButton_mrkcode_addRow.setText("Add");
        jButton_mrkcode_addRow.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_mrkcode_addRowActionPerformed(evt);
            }
        });

        jButton_mrkcode_removeRow.setText("Remove (selected)");
        jButton_mrkcode_removeRow.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_mrkcode_removeRowActionPerformed(evt);
            }
        });

        jLabel_mrkcode_row.setText("Rows");

        jButton_mrkcode_addCol.setText("Add");
        jButton_mrkcode_addCol.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_mrkcode_addColActionPerformed(evt);
            }
        });

        jButton_mrkcode_removeCol.setText("Remove (last)");
        jButton_mrkcode_removeCol.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_mrkcode_removeColActionPerformed(evt);
            }
        });

        jLabel_mrkcode_col.setText("Columns");

        jLabel_import_marker.setText("Import markers");

        jScrollPane3.setViewportView(jList_import_marker);

        jButton_import_marker_remove.setText("Remove");
        jButton_import_marker_remove.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_import_marker_removeActionPerformed(evt);
            }
        });

        jLabel_trigger.setText("Triggers");

        jButton_import_marker_update.setText("Update");
        jButton_import_marker_update.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_import_marker_updateActionPerformed(evt);
            }
        });

        jButton_mrkcode_clear.setText("Clear");
        jButton_mrkcode_clear.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_mrkcode_clearActionPerformed(evt);
            }
        });

        jButton_trigger_clear.setText("Clear");
        jButton_trigger_clear.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton_trigger_clearActionPerformed(evt);
            }
        });

        jLabel_task.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel_task.setText("Task");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addGroup(layout.createSequentialGroup()
                                .addGap(29, 29, 29)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 590, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel_mrkcode_col, javax.swing.GroupLayout.PREFERRED_SIZE, 57, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jButton_mrkcode_addCol)
                                        .addGap(18, 18, 18)
                                        .addComponent(jButton_mrkcode_removeCol)
                                        .addGap(27, 27, 27)
                                        .addComponent(jLabel_mrkcode_row, javax.swing.GroupLayout.PREFERRED_SIZE, 39, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                        .addComponent(jButton_mrkcode_addRow)
                                        .addGap(18, 18, 18)
                                        .addComponent(jButton_mrkcode_removeRow, javax.swing.GroupLayout.PREFERRED_SIZE, 123, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, layout.createSequentialGroup()
                                            .addComponent(jButton_trigger_new)
                                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                            .addComponent(jButton_trigger_remove)
                                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                            .addComponent(jButton_trigger_clear))
                                        .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 338, javax.swing.GroupLayout.PREFERRED_SIZE))))
                            .addGroup(layout.createSequentialGroup()
                                .addContainerGap()
                                .addComponent(jLabel_trigger))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                                .addContainerGap()
                                .addComponent(jLabel_mrkcode, javax.swing.GroupLayout.PREFERRED_SIZE, 229, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jButton_mrkcode_clear)))
                        .addGap(40, 40, 40)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel_import_marker, javax.swing.GroupLayout.PREFERRED_SIZE, 123, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jButton_import_marker_update)
                                    .addComponent(jButton_import_marker_remove)))))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jLabel_task)))
                .addContainerGap(302, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(10, 10, 10)
                .addComponent(jLabel_task)
                .addGap(20, 20, 20)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel_import_marker)
                    .addComponent(jLabel_trigger))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 177, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jButton_trigger_new)
                                    .addComponent(jButton_trigger_remove)
                                    .addComponent(jButton_trigger_clear))
                                .addGap(22, 22, 22)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel_mrkcode)
                                    .addComponent(jButton_mrkcode_clear))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 259, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jScrollPane3))
                        .addGap(2, 2, 2)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_mrkcode_col)
                            .addComponent(jButton_mrkcode_addCol)
                            .addComponent(jButton_mrkcode_removeCol)
                            .addComponent(jLabel_mrkcode_row)
                            .addComponent(jButton_mrkcode_addRow)
                            .addComponent(jButton_mrkcode_removeRow)))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jButton_import_marker_update)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jButton_import_marker_remove)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButton_mrkcode_removeRowActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_mrkcode_removeRowActionPerformed
        jTableDM_mrkcode.removeRow(jTable_mrkcode.getSelectedRow());
    }//GEN-LAST:event_jButton_mrkcode_removeRowActionPerformed

    private void jButton_trigger_newActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_trigger_newActionPerformed
        Object[] obj=null;
        jTableDM_trigger.addRow(obj);
        jTable_trigger.setModel(jTableDM_trigger);
    }//GEN-LAST:event_jButton_trigger_newActionPerformed

    private void jButton_trigger_removeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_trigger_removeActionPerformed
        jTableDM_trigger.removeRow(jTable_trigger.getSelectedRow());
    }//GEN-LAST:event_jButton_trigger_removeActionPerformed

    private void jButton_mrkcode_addRowActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_mrkcode_addRowActionPerformed
        Object[] obj=null;
        jTableDM_mrkcode.addRow(obj);
    }//GEN-LAST:event_jButton_mrkcode_addRowActionPerformed

    private void jButton_mrkcode_addColActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_mrkcode_addColActionPerformed
        Object[] obj=null;
        jTableDM_mrkcode.addColumn(obj);
    }//GEN-LAST:event_jButton_mrkcode_addColActionPerformed

    private void jButton_mrkcode_removeColActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_mrkcode_removeColActionPerformed
        int nb_col = jTableDM_mrkcode.getColumnCount();
        jTableDM_mrkcode.setColumnCount(nb_col-1);
    }//GEN-LAST:event_jButton_mrkcode_removeColActionPerformed

    private void jButton_import_marker_removeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_import_marker_removeActionPerformed
        DefaultListModel ListMD_import_marker = new DefaultListModel();
        ListMD_import_marker = (DefaultListModel) jList_import_marker.getModel();
        int index = jList_import_marker.getSelectedIndex();
        ListMD_import_marker.remove(index);
        jList_import_marker.setModel(ListMD_import_marker);
    }//GEN-LAST:event_jButton_import_marker_removeActionPerformed

    private void jButton_import_marker_updateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_import_marker_updateActionPerformed
        setList_import_marker();
    }//GEN-LAST:event_jButton_import_marker_updateActionPerformed

    private void jButton_trigger_clearActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_trigger_clearActionPerformed
        initTable_trigger();
        setTable_trigger();
    }//GEN-LAST:event_jButton_trigger_clearActionPerformed

    private void jButton_mrkcode_clearActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton_mrkcode_clearActionPerformed
        initTable_mrkcode();
    }//GEN-LAST:event_jButton_mrkcode_clearActionPerformed

    
    //DefaultListModel ListMD_import_marker;
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton_import_marker_remove;
    private javax.swing.JButton jButton_import_marker_update;
    private javax.swing.JButton jButton_mrkcode_addCol;
    private javax.swing.JButton jButton_mrkcode_addRow;
    private javax.swing.JButton jButton_mrkcode_clear;
    private javax.swing.JButton jButton_mrkcode_removeCol;
    private javax.swing.JButton jButton_mrkcode_removeRow;
    private javax.swing.JButton jButton_trigger_clear;
    private javax.swing.JButton jButton_trigger_new;
    private javax.swing.JButton jButton_trigger_remove;
    private javax.swing.JLabel jLabel_import_marker;
    private javax.swing.JLabel jLabel_mrkcode;
    private javax.swing.JLabel jLabel_mrkcode_col;
    private javax.swing.JLabel jLabel_mrkcode_row;
    private javax.swing.JLabel jLabel_task;
    private javax.swing.JLabel jLabel_trigger;
    private javax.swing.JList jList_import_marker;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JTable jTable_mrkcode;
    private javax.swing.JTable jTable_trigger;
    // End of variables declaration//GEN-END:variables
}
