/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
 * MainFrame.java
 *
 * Created on Sep 5, 2010, 1:05:48 PM
 */
package stripmaker.gui;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Graphics;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.swing.ButtonGroup;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import org.yaml.snakeyaml.Yaml;
import stripmaker.Bundle;
import stripmaker.InfoManager;
import stripmaker.RectFinder;
import stripmaker.gatherer.Gatherer;
import stripmaker.gatherer.IterationItem;
import stripmaker.modes.Mode;
import stripmaker.modes.Tiles;
import stripmaker.modes.Units;
import stripmaker.processor.Processor;

/**
 *
 * @author arturas
 */
public class MainFrame extends javax.swing.JFrame {

  ButtonGroup modeGroup = new ButtonGroup();

  /** Creates new form MainFrame */
  public MainFrame() {
    try {
      UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
    } catch (ClassNotFoundException ex) {
      Logger.getLogger(MainFrame.class.getName()).log(Level.SEVERE, null, ex);
    } catch (InstantiationException ex) {
      Logger.getLogger(MainFrame.class.getName()).log(Level.SEVERE, null, ex);
    } catch (IllegalAccessException ex) {
      Logger.getLogger(MainFrame.class.getName()).log(Level.SEVERE, null, ex);
    } catch (UnsupportedLookAndFeelException ex) {
      Logger.getLogger(MainFrame.class.getName()).log(Level.SEVERE, null, ex);
    }
    
    initComponents();
    setSize(1000, 700);

    modeGroup.add(battlefieldMode);
    modeGroup.add(buildingsMode);

    frameHeight.setInputVerifier(new NumberInputVerifier());
    buildingWidth.setInputVerifier(new NumberInputVerifier());
    buildingHeight.setInputVerifier(new NumberInputVerifier());
    
  }

  /** This method is called from within the constructor to
   * initialize the form.
   * WARNING: Do NOT modify this code. The content of this method is
   * always regenerated by the Form Editor.
   */
  @SuppressWarnings("unchecked")
  // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
  private void initComponents() {

    navigation = new javax.swing.JTabbedPane();
    jPanel3 = new javax.swing.JPanel();
    battlefieldMode = new javax.swing.JRadioButton();
    jLabel4 = new javax.swing.JLabel();
    frameHeight = new javax.swing.JTextField();
    buildingsMode = new javax.swing.JRadioButton();
    jLabel1 = new javax.swing.JLabel();
    buildingWidth = new javax.swing.JTextField();
    jLabel2 = new javax.swing.JLabel();
    buildingHeight = new javax.swing.JTextField();
    jLabel3 = new javax.swing.JLabel();
    jPanel2 = new javax.swing.JPanel();
    jLabel5 = new javax.swing.JLabel();
    jLabel6 = new javax.swing.JLabel();
    sharpenSelector = new javax.swing.JComboBox();
    dataDirectory = new javax.swing.JTextField();
    chooseDataDirButton = new javax.swing.JButton();
    dataProgress = new javax.swing.JProgressBar();
    statusLabel = new javax.swing.JLabel();
    loadDataButton = new javax.swing.JButton();
    jPanel4 = new javax.swing.JPanel();
    boxCutter = new javax.swing.JPanel();
    jLabel8 = new javax.swing.JLabel();
    boxLabel = new javax.swing.JLabel();
    currentPosition = new javax.swing.JLabel();
    setBoxButton = new javax.swing.JButton();
    setTargetPointButton = new javax.swing.JButton();
    gunSpinner = new javax.swing.JSpinner();
    setGunPointsButton = new javax.swing.JButton();
    jPanel1 = new javax.swing.JPanel();
    jLabel7 = new javax.swing.JLabel();
    jScrollPane1 = new javax.swing.JScrollPane();
    metadataEdit = new javax.swing.JTextArea();
    reloadMetadata = new javax.swing.JButton();
    saveButton = new javax.swing.JButton();
    rewriteActions = new javax.swing.JButton();

    setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
    setTitle("StripMaker");

    battlefieldMode.setFont(new java.awt.Font("DejaVu Sans", 1, 17));
    battlefieldMode.setSelected(true);
    battlefieldMode.setText("Battlefield");

    jLabel4.setText("Frame height:");

    frameHeight.setText("200");

    buildingsMode.setFont(new java.awt.Font("DejaVu Sans", 1, 17));
    buildingsMode.setText("Planet buildings");

    jLabel1.setText("Width:");

    buildingWidth.setText("2");

    jLabel2.setText("Height:");

    buildingHeight.setText("2");

    jLabel3.setText("Width and height are in logical tiles.");

    javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
    jPanel3.setLayout(jPanel3Layout);
    jPanel3Layout.setHorizontalGroup(
      jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
      .addGroup(jPanel3Layout.createSequentialGroup()
        .addContainerGap()
        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
          .addGroup(jPanel3Layout.createSequentialGroup()
            .addGap(12, 12, 12)
            .addComponent(jLabel4)
            .addGap(18, 18, 18)
            .addComponent(frameHeight, javax.swing.GroupLayout.PREFERRED_SIZE, 112, javax.swing.GroupLayout.PREFERRED_SIZE)
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 58, javax.swing.GroupLayout.PREFERRED_SIZE))
          .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(buildingsMode)
            .addComponent(battlefieldMode)
            .addGroup(jPanel3Layout.createSequentialGroup()
              .addGap(12, 12, 12)
              .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel3Layout.createSequentialGroup()
                  .addComponent(jLabel1)
                  .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                  .addComponent(buildingWidth, javax.swing.GroupLayout.PREFERRED_SIZE, 61, javax.swing.GroupLayout.PREFERRED_SIZE)
                  .addGap(41, 41, 41)
                  .addComponent(jLabel2)
                  .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                  .addComponent(buildingHeight, javax.swing.GroupLayout.DEFAULT_SIZE, 62, Short.MAX_VALUE))
                .addGroup(jPanel3Layout.createSequentialGroup()
                  .addComponent(jLabel3)
                  .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 5, javax.swing.GroupLayout.PREFERRED_SIZE))))))
        .addGap(376, 376, 376))
    );
    jPanel3Layout.setVerticalGroup(
      jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
      .addGroup(jPanel3Layout.createSequentialGroup()
        .addContainerGap()
        .addComponent(battlefieldMode)
        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
          .addComponent(jLabel4)
          .addComponent(frameHeight, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
        .addComponent(buildingsMode)
        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
          .addComponent(jLabel1)
          .addComponent(buildingWidth, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
          .addComponent(buildingHeight, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
          .addComponent(jLabel2))
        .addGap(18, 18, 18)
        .addComponent(jLabel3)
        .addContainerGap(197, Short.MAX_VALUE))
    );

    navigation.addTab("Select mode", jPanel3);

    jLabel5.setText("Data directory:");

    jLabel6.setText("Sharpen:");

    sharpenSelector.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "None", "Soft", "Normal", "Very Sharp", "Oversharpened" }));
    sharpenSelector.setSelectedIndex(1);

    chooseDataDirButton.setText("Choose");
    chooseDataDirButton.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(java.awt.event.ActionEvent evt) {
        chooseDataDirButtonActionPerformed(evt);
      }
    });

    statusLabel.setText("Please select data directory.");

    loadDataButton.setText("Load");
    loadDataButton.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(java.awt.event.ActionEvent evt) {
        loadDataButtonActionPerformed(evt);
      }
    });

    javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
    jPanel2.setLayout(jPanel2Layout);
    jPanel2Layout.setHorizontalGroup(
      jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
      .addGroup(jPanel2Layout.createSequentialGroup()
        .addContainerGap()
        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
          .addGroup(jPanel2Layout.createSequentialGroup()
            .addComponent(jLabel6)
            .addGap(61, 61, 61)
            .addComponent(sharpenSelector, 0, 546, Short.MAX_VALUE))
          .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
            .addComponent(jLabel5)
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
            .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
              .addComponent(statusLabel, javax.swing.GroupLayout.Alignment.LEADING)
              .addGroup(jPanel2Layout.createSequentialGroup()
                .addComponent(dataDirectory, javax.swing.GroupLayout.DEFAULT_SIZE, 410, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(chooseDataDirButton)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(loadDataButton))
              .addComponent(dataProgress, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 546, Short.MAX_VALUE))))
        .addContainerGap())
    );
    jPanel2Layout.setVerticalGroup(
      jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
      .addGroup(jPanel2Layout.createSequentialGroup()
        .addContainerGap()
        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
          .addComponent(sharpenSelector, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
          .addComponent(jLabel6))
        .addGap(18, 18, 18)
        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
          .addComponent(jLabel5)
          .addComponent(dataDirectory, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
          .addComponent(loadDataButton)
          .addComponent(chooseDataDirButton))
        .addGap(7, 7, 7)
        .addComponent(statusLabel)
        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
        .addComponent(dataProgress, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        .addContainerGap(230, Short.MAX_VALUE))
    );

    navigation.addTab("Provide data", jPanel2);

    boxCutter.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
    boxCutter.addMouseListener(new java.awt.event.MouseAdapter() {
      public void mouseClicked(java.awt.event.MouseEvent evt) {
        boxCutterMouseClicked(evt);
      }
      public void mouseEntered(java.awt.event.MouseEvent evt) {
        boxCutterMouseEntered(evt);
      }
      public void mouseExited(java.awt.event.MouseEvent evt) {
        boxCutterMouseExited(evt);
      }
    });
    boxCutter.addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
      public void mouseMoved(java.awt.event.MouseEvent evt) {
        boxCutterMouseMoved(evt);
      }
    });

    javax.swing.GroupLayout boxCutterLayout = new javax.swing.GroupLayout(boxCutter);
    boxCutter.setLayout(boxCutterLayout);
    boxCutterLayout.setHorizontalGroup(
      boxCutterLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
      .addGap(0, 681, Short.MAX_VALUE)
    );
    boxCutterLayout.setVerticalGroup(
      boxCutterLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
      .addGap(0, 283, Short.MAX_VALUE)
    );

    jLabel8.setText("Box:");

    boxLabel.setText("unknown");

    currentPosition.setText("(-, -)");

    setBoxButton.setForeground(new java.awt.Color(20, 125, 26));
    setBoxButton.setText("Set box");
    setBoxButton.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(java.awt.event.ActionEvent evt) {
        setBoxButtonActionPerformed(evt);
      }
    });

    setTargetPointButton.setForeground(new java.awt.Color(171, 175, 2));
    setTargetPointButton.setText("Set target point");
    setTargetPointButton.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(java.awt.event.ActionEvent evt) {
        setTargetPointButtonActionPerformed(evt);
      }
    });

    gunSpinner.setModel(new javax.swing.SpinnerNumberModel(Integer.valueOf(1), Integer.valueOf(1), null, Integer.valueOf(1)));
    gunSpinner.setEditor(new javax.swing.JSpinner.NumberEditor(gunSpinner, ""));

    setGunPointsButton.setForeground(new java.awt.Color(151, 2, 6));
    setGunPointsButton.setText("Set gun points");
    setGunPointsButton.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(java.awt.event.ActionEvent evt) {
        setGunPointsButtonActionPerformed(evt);
      }
    });

    javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
    jPanel4.setLayout(jPanel4Layout);
    jPanel4Layout.setHorizontalGroup(
      jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
      .addGroup(jPanel4Layout.createSequentialGroup()
        .addContainerGap()
        .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
          .addComponent(boxCutter, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
          .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel4Layout.createSequentialGroup()
            .addComponent(jLabel8)
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
            .addComponent(boxLabel)
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 524, Short.MAX_VALUE)
            .addComponent(currentPosition))
          .addGroup(jPanel4Layout.createSequentialGroup()
            .addComponent(setBoxButton)
            .addGap(18, 18, 18)
            .addComponent(setTargetPointButton)
            .addGap(18, 18, 18)
            .addComponent(gunSpinner, javax.swing.GroupLayout.PREFERRED_SIZE, 54, javax.swing.GroupLayout.PREFERRED_SIZE)
            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
            .addComponent(setGunPointsButton)))
        .addContainerGap())
    );
    jPanel4Layout.setVerticalGroup(
      jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
      .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel4Layout.createSequentialGroup()
        .addContainerGap()
        .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
          .addComponent(setBoxButton)
          .addComponent(setTargetPointButton)
          .addComponent(gunSpinner, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
          .addComponent(setGunPointsButton))
        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
        .addComponent(boxCutter, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
        .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
          .addComponent(jLabel8)
          .addComponent(boxLabel)
          .addComponent(currentPosition))
        .addContainerGap())
    );

    navigation.addTab("Select points", jPanel4);

    jLabel7.setFont(new java.awt.Font("DejaVu Sans", 1, 17));
    jLabel7.setText("Metadata");

    metadataEdit.setColumns(20);
    metadataEdit.setRows(5);
    jScrollPane1.setViewportView(metadataEdit);

    reloadMetadata.setText("Reload metadata");
    reloadMetadata.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(java.awt.event.ActionEvent evt) {
        reloadMetadataActionPerformed(evt);
      }
    });

    saveButton.setFont(new java.awt.Font("DejaVu Sans", 1, 17));
    saveButton.setText("Save ZIP & Exit");
    saveButton.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(java.awt.event.ActionEvent evt) {
        saveButtonActionPerformed(evt);
      }
    });

    rewriteActions.setText("Rewrite actions");
    rewriteActions.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(java.awt.event.ActionEvent evt) {
        rewriteActionsActionPerformed(evt);
      }
    });

    javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
    jPanel1.setLayout(jPanel1Layout);
    jPanel1Layout.setHorizontalGroup(
      jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
      .addGroup(jPanel1Layout.createSequentialGroup()
        .addContainerGap()
        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
          .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 683, Short.MAX_VALUE)
          .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel1Layout.createSequentialGroup()
            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
              .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jLabel7)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 437, Short.MAX_VALUE))
              .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(reloadMetadata)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(rewriteActions)
                .addGap(6, 6, 6)))
            .addComponent(saveButton)))
        .addContainerGap())
    );
    jPanel1Layout.setVerticalGroup(
      jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
      .addGroup(jPanel1Layout.createSequentialGroup()
        .addContainerGap()
        .addComponent(jLabel7)
        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
        .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 285, Short.MAX_VALUE)
        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
          .addComponent(saveButton)
          .addComponent(rewriteActions)
          .addComponent(reloadMetadata))
        .addContainerGap())
    );

    navigation.addTab("Edit metadata", jPanel1);

    javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
    getContentPane().setLayout(layout);
    layout.setHorizontalGroup(
      layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
      .addComponent(navigation, javax.swing.GroupLayout.DEFAULT_SIZE, 711, Short.MAX_VALUE)
    );
    layout.setVerticalGroup(
      layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
      .addComponent(navigation, javax.swing.GroupLayout.DEFAULT_SIZE, 407, Short.MAX_VALUE)
    );

    pack();
  }// </editor-fold>//GEN-END:initComponents

    private void chooseDataDirButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_chooseDataDirButtonActionPerformed
      JFileChooser chooser = new JFileChooser();
      chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
      chooser.setFileFilter(new DirectoryFilter());
      chooser.setCurrentDirectory(new File("."));
      int result = chooser.showOpenDialog(this);
      if (result == JFileChooser.APPROVE_OPTION) {
        File selected = chooser.getSelectedFile();
        String path = selected.getPath();
        dataDirectory.setText(path);
        loadData(path);
      }
    }//GEN-LAST:event_chooseDataDirButtonActionPerformed

    private void boxCutterMouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_boxCutterMouseEntered
      setCursor(new Cursor(Cursor.CROSSHAIR_CURSOR));
    }//GEN-LAST:event_boxCutterMouseEntered

    private void boxCutterMouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_boxCutterMouseExited
      setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
    }//GEN-LAST:event_boxCutterMouseExited

    private final static int STATE_NONE = 0;
    private final static int STATE_BOX_START = 1;
    private final static int STATE_BOX_CLICKED = 2;
    private final static int STATE_TARGET = 3;
    private final static int STATE_GUNS = 4;
    private int state = STATE_NONE;
    private Rectangle box = null;
    private Point target = null;
    private ArrayList<Point> guns = null;
    private void boxCutterMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_boxCutterMouseClicked
      if (state != STATE_NONE) {
        if (evt.getX() >= boxImage.getWidth() ||
            evt.getY() >= boxImage.getHeight()) {
          return;
        }

        // Box handling.
        if (state == STATE_BOX_START) {
          box = new Rectangle();
          box.x = evt.getX();
          box.y = evt.getY();
          state = STATE_BOX_CLICKED;
          updateBoxLabel();
        }
        else if (state == STATE_BOX_CLICKED) {
          box.width = evt.getX() - box.x;
          if (box.width < 0) {
            box.x += box.width;
            box.width *= -1;
          }
          box.height = evt.getY() - box.y;
          if (box.height < 0) {
            box.y += box.height;
            box.height *= -1;
          }
          replaceKey("box", InfoManager.getBoxProperties(box));
          state = STATE_NONE;
          updateBoxLabel();
        }
        else if (state == STATE_TARGET) {
          target = new Point(evt.getX(), evt.getY());
          replaceKey("target_point",
            InfoManager.getTargetPoint(target));
          state = STATE_NONE;
        }
        else if (state == STATE_GUNS) {
          int gunCount = (Integer) gunSpinner.getValue();
          
          guns.add(new Point(evt.getX(), evt.getY()));
          if (guns.size() == gunCount) {
            replaceKey("gun_points",
              InfoManager.getGunPoints(guns));
            gunSpinner.setEnabled(true);
            state = STATE_NONE;
          }
        }
        drawCurrentMarkers();
      }
    }//GEN-LAST:event_boxCutterMouseClicked

    private void boxCutterMouseMoved(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_boxCutterMouseMoved
      drawCurrentMarkers();
      if (evt.getX() >= boxImage.getWidth() ||
          evt.getY() >= boxImage.getHeight()) {
        return;
      }
      
      drawCross(evt.getX(), evt.getY(), Color.ORANGE);
      currentPosition.setText(
        String.format("(%d, %d)", evt.getX(), evt.getY()));
    }//GEN-LAST:event_boxCutterMouseMoved

    private void loadDataButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_loadDataButtonActionPerformed
      loadData(dataDirectory.getText());
    }//GEN-LAST:event_loadDataButtonActionPerformed

    private void rewriteActionsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_rewriteActionsActionPerformed
      replaceKey("actions", InfoManager.getActions(gatherer));
    }//GEN-LAST:event_rewriteActionsActionPerformed

    private void saveButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_saveButtonActionPerformed
      try {
        String metadata = metadataEdit.getText();
        bundle.writeMetadata(metadata);
        InfoManager.save(gatherer, metadata);
        bundle.close();
        System.exit(0);
      } catch (IOException ex) {
        error("Error writing ZIP!", ex.getMessage());
      }
    }//GEN-LAST:event_saveButtonActionPerformed

    private void setBoxButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_setBoxButtonActionPerformed
      state = STATE_BOX_START;
      drawCurrentMarkers();
    }//GEN-LAST:event_setBoxButtonActionPerformed

    private void setTargetPointButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_setTargetPointButtonActionPerformed
      state = STATE_TARGET;
      drawCurrentMarkers();
    }//GEN-LAST:event_setTargetPointButtonActionPerformed

    private void setGunPointsButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_setGunPointsButtonActionPerformed
      state = STATE_GUNS;
      gunSpinner.setEnabled(false);
      guns = new ArrayList<Point>((Integer) gunSpinner.getValue());
      drawCurrentMarkers();
    }//GEN-LAST:event_setGunPointsButtonActionPerformed

    private void reloadMetadataActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_reloadMetadataActionPerformed
      loadMetadata();
    }//GEN-LAST:event_reloadMetadataActionPerformed

  private final static int MARKER_SIZE = 10;
  private void drawMarker(int x, int y, Color color) {
    Graphics graphics = boxCutter.getGraphics();
    graphics.setColor(color);
    graphics.drawLine(x - MARKER_SIZE, y, x + MARKER_SIZE, y);
    graphics.drawLine(x, y - MARKER_SIZE, x, y + MARKER_SIZE);
  }

  private void drawCross(int x, int y, Color color) {
    Graphics graphics = boxCutter.getGraphics();
    graphics.setColor(color);
    graphics.drawLine(0, y, getWidth(), y);
    graphics.drawLine(x, 0, x, getHeight());
  }

  BufferedImage boxImage = null;
  private void clearCanvas() {
    BufferedImage boxCutterBack = new BufferedImage(
      boxCutter.getWidth(), boxCutter.getHeight(), BufferedImage.TYPE_INT_ARGB
    );
    Graphics backGraphics = boxCutterBack.getGraphics();
    backGraphics.setColor(Color.WHITE);
    backGraphics.fillRect(0, 0, boxCutterBack.getWidth(),
      boxCutterBack.getHeight());

    if (boxImage != null) {
      backGraphics.drawImage(boxImage, 0, 0, null);
    }

    Graphics graphics = boxCutter.getGraphics();
    graphics.drawImage(boxCutterBack, 0, 0, null);
  }

  private void drawCurrentMarkers() {
    clearCanvas();
    // Draw box if needed
    if (box != null) {
      drawCross(box.x, box.y, Color.GREEN);

      if (box.width != 0 || box.height != 0) {
        drawCross(box.x + box.width, box.y + box.height, Color.GREEN);
      }
    }
    
    // Draw target
    if (target != null) {
      drawMarker(target.x, target.y, Color.YELLOW);
    }

    // Draw gun points
    if (guns != null) {
      for (Point gun: guns) {
        drawMarker(gun.x, gun.y, Color.RED);
      }
    }
  }

  private Gatherer gatherer;
  private Processor processor;
  private Bundle bundle;

  private void setCurrentDP() {
    dataProgress.setString(String.format("%d / %d",
        dataProgress.getValue(),
        dataProgress.getMaximum()
        ));
  }
  
  private void updateBoxLabel() {
    String boxLabelText = String.format("(%d, %d)",
      box.x, box.y);
    if (box.width != 0 || box.height != 0) {
      boxLabelText += String.format(" -> (%d, %d)",
        box.x + box.width, box.y + box.height);
    }
    boxLabel.setText(boxLabelText);
  }

  private void loadData(final String dataPath) {
    Thread thread = new Thread(new Runnable() {
      public void run() {
        try {
          gatherer = new Gatherer(dataPath);

          Mode mode;
          if (battlefieldMode.isSelected()) {
            mode = new Units(Integer.parseInt(frameHeight.getText()));
          }
          else {
            mode = new Tiles(
              Integer.parseInt(buildingWidth.getText()),
              Integer.parseInt(buildingHeight.getText())
            );
          }
          mode.setUnsharpenMaskIndex(sharpenSelector.getSelectedIndex());

          statusLabel.setText("Finding common rectangle...");
          dataProgress.setIndeterminate(true);
          Rectangle commonRect = RectFinder.find(gatherer, mode);
          dataProgress.setIndeterminate(false);

          processor = new Processor(gatherer, commonRect, mode);

          File dataDir = new File(gatherer.getDataDirectory(), "..");
          String basename = gatherer.getDataDirectory().getName();
          bundle = new Bundle(new File(dataDir, basename + ".zip"));

          statusLabel.setText("Processing items...");
          dataProgress.setMinimum(0);
          dataProgress.setMaximum(gatherer.getFrameCount());
          dataProgress.setValue(0);
          setCurrentDP();

          for (IterationItem item : processor) {
            bundle.addFrame(item);
            dataProgress.setValue(dataProgress.getValue() + 1);
            setCurrentDP();
          }

          boxImage = processor.process(gatherer.getBoxFrame());
          box = processor.getBox();
          loadMetadata();
          updateBoxLabel();

          statusLabel.setText("Data loaded.");
          navigation.setSelectedIndex(2);
          clearCanvas();
        }
        catch (Exception e) {
          error("Error while loading data!", e.getMessage());
        }
      }
    });
    thread.start();
  }

  private void loadMetadata() {
    String metadata = gatherer.getMetadata();
    if (metadata == null) {
      metadata = InfoManager.getMetadata(gatherer,
        processor.getTargetSize(), box);
    }
    metadataEdit.setText(metadata);

    Yaml yaml = new Yaml();
    Map metaMap = (Map) yaml.load(metadata);

    if (metaMap.containsKey("box")) {
      Map boxMap = (Map) metaMap.get("box");
      List topLeft = (List) boxMap.get("top_left");
      int x = (Integer) topLeft.get(0);
      int y = (Integer) topLeft.get(1);
      List bottomRight = (List) boxMap.get("bottom_right");
      int width = (Integer) bottomRight.get(0) - x;
      int height = (Integer) bottomRight.get(1) - y;
      box = new Rectangle(x, y, width, height);
    }

    if (metaMap.containsKey("target_point")) {
      List point = (List) metaMap.get("target_point");
      target = new Point((Integer) point.get(0), (Integer) point.get(1));
    }

    if (metaMap.containsKey("gun_points")) {
      List gunPoints = (List) metaMap.get("gun_points");
      guns = new ArrayList<Point>(gunPoints.size());
      gunSpinner.setValue(gunPoints.size());
      for (Object gunObject: gunPoints) {
        List gunPoint = (List) gunObject;
        guns.add(
          new Point((Integer) gunPoint.get(0),(Integer) gunPoint.get(1))
        );
      }
    }

    drawCurrentMarkers();
  }

  private void error(String title, String message) {
    JOptionPane.showMessageDialog(this,
        new JLabel(message),
        title,
        JOptionPane.ERROR_MESSAGE);
  }

  private void replaceKey(String key, String value) {
    String metadata = metadataEdit.getText();
    Pattern regexp = Pattern.compile("^" + key + ":.+?(^\\S|\\Z)",
      Pattern.DOTALL | Pattern.MULTILINE);
    Matcher matcher = regexp.matcher(metadata);
    if (matcher.find()) {
      String lastChar = matcher.group(1);
      metadata = matcher.replaceFirst(value + lastChar);
    }
    else {
      metadata += "\n" + value;
    }
    metadataEdit.setText(metadata);
  }

  /**
   * @param args the command line arguments
   */
  public static void main(String args[]) {
    java.awt.EventQueue.invokeLater(new Runnable() {

      public void run() {
        new MainFrame().setVisible(true);
      }
    });
  }
  // Variables declaration - do not modify//GEN-BEGIN:variables
  private javax.swing.JRadioButton battlefieldMode;
  private javax.swing.JPanel boxCutter;
  private javax.swing.JLabel boxLabel;
  private javax.swing.JTextField buildingHeight;
  private javax.swing.JTextField buildingWidth;
  private javax.swing.JRadioButton buildingsMode;
  private javax.swing.JButton chooseDataDirButton;
  private javax.swing.JLabel currentPosition;
  private javax.swing.JTextField dataDirectory;
  private javax.swing.JProgressBar dataProgress;
  private javax.swing.JTextField frameHeight;
  private javax.swing.JSpinner gunSpinner;
  private javax.swing.JLabel jLabel1;
  private javax.swing.JLabel jLabel2;
  private javax.swing.JLabel jLabel3;
  private javax.swing.JLabel jLabel4;
  private javax.swing.JLabel jLabel5;
  private javax.swing.JLabel jLabel6;
  private javax.swing.JLabel jLabel7;
  private javax.swing.JLabel jLabel8;
  private javax.swing.JPanel jPanel1;
  private javax.swing.JPanel jPanel2;
  private javax.swing.JPanel jPanel3;
  private javax.swing.JPanel jPanel4;
  private javax.swing.JScrollPane jScrollPane1;
  private javax.swing.JButton loadDataButton;
  private javax.swing.JTextArea metadataEdit;
  private javax.swing.JTabbedPane navigation;
  private javax.swing.JButton reloadMetadata;
  private javax.swing.JButton rewriteActions;
  private javax.swing.JButton saveButton;
  private javax.swing.JButton setBoxButton;
  private javax.swing.JButton setGunPointsButton;
  private javax.swing.JButton setTargetPointButton;
  private javax.swing.JComboBox sharpenSelector;
  private javax.swing.JLabel statusLabel;
  // End of variables declaration//GEN-END:variables

}
