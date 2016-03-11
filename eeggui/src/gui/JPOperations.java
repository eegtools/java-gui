/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gui;

import java.awt.Component;
import javax.swing.DefaultCellEditor;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JTable;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellEditor;
import javax.swing.table.TableCellRenderer;
import structures.Epoching;
import structures.Erp;
import structures.Operations;
import structures.Project;

/**
 *
 * @author inuggi
 */
public class JPOperations extends javax.swing.JPanel {

    private JTPMain controller;
    public Project project;
    public Operations operations;
        
    ModelTable_operations jTableDM_operations;
    
    public JPOperations(JTPMain ctrl) {
        initComponents();
        controller = ctrl;
    }
    
    public void initGUI(Project proj)
    {
        initTable_operations(0);
        initGpeSubjectButtons();
    }
    
    public void setGUI(Project proj)
    {
        project = proj;
        operations = project.operations;
        
        setTable_operations();
        
        initGUI(project);
    }
    
    public Operations getGUI()
    {
        
        
        return operations;
    }
    
    
    // ---------------------------------------------------------------------------
    // INIT GUI
    
    private void initTable_operations(int nb_rows)
    {
        String[] columnNames = {"Analysis","Execute"};
        Object[][] data = new Object[nb_rows][columnNames.length];         
        jTableDM_operations = new ModelTable_operations(data,columnNames); 
        jTable_operations.setModel(jTableDM_operations);  
        
        JCheckBox checkBox = new JCheckBox();
        TableCellEditor editor = new DefaultCellEditor(checkBox);        
        jTable_operations.getColumnModel().getColumn(1).setCellEditor(editor);
        
        DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
        centerRenderer.setHorizontalAlignment(JLabel.CENTER);
        for (int i = 0; i < columnNames.length; i++)
        {jTable_operations.getColumnModel().getColumn(i).setCellRenderer(centerRenderer);}
        
        DefaultTableCellRenderer renderer = (DefaultTableCellRenderer) jTable_operations.getTableHeader().getDefaultRenderer();
        renderer.setHorizontalAlignment(JLabel.CENTER);
        
        CheckBoxRenderer checkBoxRenderer = new CheckBoxRenderer();
        jTable_operations.getColumnModel().getColumn(1).setCellRenderer(checkBoxRenderer);
    }
    
    class ModelTable_operations extends DefaultTableModel {
 
    public ModelTable_operations(Object rowData[][], Object columnNames[]) {
         super(rowData, columnNames);
      }
    
    @Override
      public Class getColumnClass(int col) {
          if (col == 1) 
          {return JCheckBox.class;}
          else {return String.class;}  
    }
 
    @Override
      public boolean isCellEditable(int row, int col) {
        if (col == 0) 
            return false;
        else return true;
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
    
    
    private void initGpeSubjectButtons()
    {
        buttonGroup1.add(jRadioButton_subject);
        buttonGroup1.add(jRadioButton_group);       
    }
    
    // ---------------------------------------------------------------------------
    // SET GUI
    
    private void setTable_operations()
    {
        String GroupOrSubj = new String();
        if (jRadioButton_group.isSelected())
            {GroupOrSubj = "group";}
        else if (jRadioButton_subject.isSelected())
            {GroupOrSubj = "subject";}
        
        if (GroupOrSubj.equals("subject"))
        {
            String[] Name_Analysis = {"analysis 1","analysis 2"};
            boolean[] bool_Analysis = {true, false};
            
            initTable_operations(Name_Analysis.length);
            
            for (int i = 0; i < Name_Analysis.length; i++) 
            {
                jTable_operations.setValueAt(Name_Analysis[i], i, 0);
                jTable_operations.setValueAt(bool_Analysis[i], i, 1);
            }
        }
        else if (GroupOrSubj.equals("group"))
        {
            String[] Name_Analysis = {"analysis 3","analysis 4","analysis 5"};
            boolean[] bool_Analysis = {false, true, true};
            
            initTable_operations(Name_Analysis.length);
            
            for (int i = 0; i < Name_Analysis.length; i++) 
            {
                jTable_operations.setValueAt(Name_Analysis[i], i, 0);
                jTable_operations.setValueAt(bool_Analysis[i], i, 1);
            }
        }
    }
    
    private void setTable_operations(String GroupOrSubj)
    {
        if (GroupOrSubj.equals("subject"))
        {
            String[] Name_Analysis = {"analysis 1","analysis 2"};
            boolean[] bool_Analysis = {true, false};
            
            initTable_operations(Name_Analysis.length);
            
            for (int i = 0; i < Name_Analysis.length; i++) 
            {
                jTable_operations.setValueAt(Name_Analysis[i], i, 0);
                jTable_operations.setValueAt(bool_Analysis[i], i, 1);
            }
        }
        else if (GroupOrSubj.equals("group"))
        {
            String[] Name_Analysis = {"analysis 3","analysis 4","analysis 5"};
            boolean[] bool_Analysis = {false, true, true};
            
            initTable_operations(Name_Analysis.length);
            
            for (int i = 0; i < Name_Analysis.length; i++) 
            {
                jTable_operations.setValueAt(Name_Analysis[i], i, 0);
                jTable_operations.setValueAt(bool_Analysis[i], i, 1);
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

        buttonGroup1 = new javax.swing.ButtonGroup();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable_operations = new javax.swing.JTable();
        jLabel_AnalysisName = new javax.swing.JLabel();
        jLabel_ConditionFolder = new javax.swing.JLabel();
        jRadioButton_subject = new javax.swing.JRadioButton();
        jRadioButton_group = new javax.swing.JRadioButton();
        jButton_operations_start = new javax.swing.JButton();
        jTextField_ConditionFolder = new javax.swing.JTextField();
        jTextField_AnalysisName = new javax.swing.JTextField();
        jLabel_Table_operations = new javax.swing.JLabel();
        jLabel_operations = new javax.swing.JLabel();

        jTable_operations.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null}
            },
            new String [] {
                "Analysis", "Execute"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.String.class, java.lang.Boolean.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jScrollPane1.setViewportView(jTable_operations);

        jLabel_AnalysisName.setText("Analysis name");

        jLabel_ConditionFolder.setText("Condition folder");

        jRadioButton_subject.setText("Subject");
        jRadioButton_subject.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jRadioButton_subjectStateChanged(evt);
            }
        });

        jRadioButton_group.setText("Group");
        jRadioButton_group.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jRadioButton_subjectStateChanged(evt);
            }
        });

        jButton_operations_start.setText("Start");
        jButton_operations_start.setName("$Start"); // NOI18N

        jLabel_Table_operations.setText("Analysis");

        jLabel_operations.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel_operations.setText("Operations");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGap(39, 39, 39)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 922, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addGroup(layout.createSequentialGroup()
                                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addGroup(layout.createSequentialGroup()
                                                .addComponent(jLabel_AnalysisName, javax.swing.GroupLayout.PREFERRED_SIZE, 118, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(jTextField_AnalysisName, javax.swing.GroupLayout.PREFERRED_SIZE, 312, javax.swing.GroupLayout.PREFERRED_SIZE))
                                            .addGroup(layout.createSequentialGroup()
                                                .addComponent(jLabel_ConditionFolder, javax.swing.GroupLayout.PREFERRED_SIZE, 118, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(jTextField_ConditionFolder, javax.swing.GroupLayout.PREFERRED_SIZE, 312, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                        .addGap(66, 66, 66)
                                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jRadioButton_subject)
                                            .addComponent(jRadioButton_group)))
                                    .addComponent(jLabel_Table_operations, javax.swing.GroupLayout.Alignment.LEADING))
                                .addGap(224, 224, 224)
                                .addComponent(jButton_operations_start, javax.swing.GroupLayout.PREFERRED_SIZE, 123, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jLabel_operations)))
                .addContainerGap(189, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGap(6, 6, 6)
                .addComponent(jLabel_operations)
                .addGap(30, 30, 30)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_ConditionFolder)
                            .addComponent(jTextField_ConditionFolder, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(8, 8, 8)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel_AnalysisName)
                            .addComponent(jTextField_AnalysisName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 21, Short.MAX_VALUE)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButton_operations_start)
                            .addComponent(jLabel_Table_operations))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 540, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(54, 54, 54))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jRadioButton_subject)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jRadioButton_group)
                        .addGap(18, 18, 18))))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jRadioButton_subjectStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jRadioButton_subjectStateChanged
        if (jRadioButton_subject.isSelected())
        {
            setTable_operations("subject");
        }
        else if (jRadioButton_group.isSelected())
        {
            setTable_operations("group");
        }
    }//GEN-LAST:event_jRadioButton_subjectStateChanged



    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.JButton jButton_operations_start;
    private javax.swing.JLabel jLabel_AnalysisName;
    private javax.swing.JLabel jLabel_ConditionFolder;
    private javax.swing.JLabel jLabel_Table_operations;
    private javax.swing.JLabel jLabel_operations;
    private javax.swing.JRadioButton jRadioButton_group;
    private javax.swing.JRadioButton jRadioButton_subject;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTable jTable_operations;
    private javax.swing.JTextField jTextField_AnalysisName;
    private javax.swing.JTextField jTextField_ConditionFolder;
    // End of variables declaration//GEN-END:variables
}
