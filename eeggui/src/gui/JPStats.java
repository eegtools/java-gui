/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gui;

/**
 *
 * @author PHilt
 */
public class JPStats extends javax.swing.JPanel {

    /**
     * Creates new form JPStats
     */
    public JPStats(JTPMain ctrl) {
        initComponents();
        controller = ctrl;
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel_ReactionTimes1 = new javax.swing.JLabel();

        jLabel_ReactionTimes1.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel_ReactionTimes1.setText("Statistiques");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel_ReactionTimes1, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(782, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel_ReactionTimes1)
                .addContainerGap(544, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents


    private JTPMain controller;
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel_ReactionTimes1;
    // End of variables declaration//GEN-END:variables
}