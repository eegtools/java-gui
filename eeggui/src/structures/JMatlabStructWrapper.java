/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package structures;

import com.jmatio.types.*;
import java.util.Map;

/**
 *
 * @author PHilt
 */
public class JMatlabStructWrapper 
{
    public String[][][] getStringCellMatrix3D(MLStructure struct, String field)
    {
        
        MLCell a        = (MLCell) struct.getField(field);
        int[] dim1      = a.getDimensions();
        int rows1       = dim1[0];      
        int cols1       = dim1[1];
        int length1     = (rows1 > cols1 ? rows1 : cols1);
        
        MLCell aa; 
        aa              = (MLCell) a.get(rows1-1,cols1-1);
        int[] dim2      = aa.getDimensions();
        int rows2       = dim2[0];      
        int cols2       = dim2[1];
        int length2     = (rows2 > cols2 ? rows2 : cols2);
        
        MLCell aaa; 
        aaa             = (MLCell) aa.get(rows2-1,cols2-1);
        int[] dim3      = aaa.getDimensions();
        int rows3       = dim3[0];      
        int cols3       = dim3[1];
        int length3     = (rows3 > cols3 ? rows3 : cols3);
        

        MLCell b; 
        String[][][] cellarray = new String[length1][length2][length3];
        
        if (cols1==1)
        {
            for (int r = 0; r < rows1; r++) 
            {
                b = (MLCell) a.get(r,cols1-1);
                
                MLCell c; String test;
                if (cols2==1)
                {
                    for (int r2 = 0; r2 < rows2; r2++) 
                    {
                        c = (MLCell) b.get(r2,cols2-1);
                        
                        if (cols3==1)
                        {
                            for (int r3 = 0; r3 < rows3; r3++) 
                            {
                                //test = ((MLChar) c.get(r3,cols3-1)).getString(0);
                                cellarray[r][r2][r3] = ((MLChar) c.get(r3,cols3-1)).getString(0);
                                int rhdjrh = 1;
                            }
                        }
                        
                    }
                }
  
            }
        }
        return cellarray;
    }     
    
        public String[][][] getStringCellMatrix3D(Map map, String field)
    {
        
        MLCell a        = (MLCell) map.get(field);
        int[] dim1      = a.getDimensions();
        int rows1       = dim1[0];      
        int cols1       = dim1[1];
        int length1     = (rows1 > cols1 ? rows1 : cols1);
        
        MLCell aa; 
        aa              = (MLCell) a.get(rows1-1,cols1-1);
        int[] dim2      = aa.getDimensions();
        int rows2       = dim2[0];      
        int cols2       = dim2[1];
        int length2     = (rows2 > cols2 ? rows2 : cols2);
        
        MLCell aaa; 
        aaa             = (MLCell) aa.get(rows2-1,cols2-1);
        int[] dim3      = aaa.getDimensions();
        int rows3       = dim3[0];      
        int cols3       = dim3[1];
        int length3     = (rows3 > cols3 ? rows3 : cols3);
        

        MLCell b; 
        String[][][] cellarray = new String[length1][length2][length3];
        
        if (cols1==1)
        {
            for (int r = 0; r < rows1; r++) 
            {
                b = (MLCell) a.get(r,cols1-1);
                
                MLCell c; String test;
                if (cols2==1)
                {
                    for (int r2 = 0; r2 < rows2; r2++) 
                    {
                        c = (MLCell) b.get(r2,cols2-1);
                        
                        if (cols3==1)
                        {
                            for (int r3 = 0; r3 < rows3; r3++) 
                            {
                                //test = ((MLChar) c.get(r3,cols3-1)).getString(0);
                                cellarray[r][r2][r3] = ((MLChar) c.get(r3,cols3-1)).getString(0);
                            }
                        }
                        
                    }
                }
  
            }
        }
        return cellarray;
    }  
     
        
        
    public String[][][] getStringCellMatrix3D_DiffSizes(MLStructure struct, String field)
    {
        if ((struct.getField(field)).isEmpty()) return null;
        else 
        {
        
        MLCell a        = (MLCell) struct.getField(field);
        int[] dim1      = a.getDimensions();
        int rows1       = dim1[0];      
        int cols1       = dim1[1];
        int length1     = (rows1 > cols1 ? rows1 : cols1);
        
        MLCell aa; 
        aa              = (MLCell) a.get(rows1-1,cols1-1);
        int[] dim2      = aa.getDimensions();
        int rows2       = dim2[0];      
        int cols2       = dim2[1];
        int length2     = (rows2 > cols2 ? rows2 : cols2);
        
        int max_dim = 0;
        if (cols1==1)
        {
            for (int compt = 0; compt < rows1; compt++) 
            {
            MLCell vec1 = (MLCell) a.get(compt,0);
            int[] dim_vec1 = vec1.getDimensions();
                
                if  (dim_vec1[1]==1)
                {
                    for (int compt2 = 0; compt2 < dim_vec1[1]; compt2++) 
                    {
                    MLCell vec2 = (MLCell) vec1.get(compt2,0);
                    int[] dim_test2 = vec2.getDimensions();
                    int tmp_dim = (dim_test2[0] > dim_test2[1] ? dim_test2[0] : dim_test2[1]);
                    max_dim = (tmp_dim > max_dim ? tmp_dim : max_dim); 
                    }
                }
                else if (dim_vec1[0]==1)
                {
                    for (int compt2 = 0; compt2 < dim_vec1[0]; compt2++) 
                    {
                    MLCell vec2 = (MLCell) vec1.get(0,compt2);
                    int[] dim_test2 = vec2.getDimensions();
                    int tmp_dim = (dim_test2[0] > dim_test2[1] ? dim_test2[0] : dim_test2[1]);
                    max_dim = (tmp_dim > max_dim ? tmp_dim : max_dim); 
                    }
                }
            }
        }
        else if (rows1==1)
        {
            for (int compt = 0; compt < cols1; compt++) 
            {
            MLCell vec1 = (MLCell) a.get(0,compt);
            int[] dim_vec1 = vec1.getDimensions();
                
                if  (dim_vec1[1]==1)
                {
                    for (int compt2 = 0; compt2 < dim_vec1[1]; compt2++) 
                    {
                    MLCell vec2 = (MLCell) vec1.get(compt2,0);
                    int[] dim_test2 = vec2.getDimensions();
                    int tmp_dim = (dim_test2[0] > dim_test2[1] ? dim_test2[0] : dim_test2[1]);
                    max_dim = (tmp_dim > max_dim ? tmp_dim : max_dim); 
                    }
                }
                else if (dim_vec1[0]==1)
                {
                    for (int compt2 = 0; compt2 < dim_vec1[0]; compt2++) 
                    {
                    MLCell vec2 = (MLCell) vec1.get(0,compt2);
                    int[] dim_test2 = vec2.getDimensions();
                    int tmp_dim = (dim_test2[0] > dim_test2[1] ? dim_test2[0] : dim_test2[1]);
                    max_dim = (tmp_dim > max_dim ? tmp_dim : max_dim); 
                    }
                }
            }
        }
        
        String[][][] cellarray = new String[length1][length2][max_dim];

        if (cols1==1)
        {
            for (int compt1 = 0; compt1 < rows1; compt1++) 
            {
                MLCell b1 = (MLCell) a.get(compt1,0);
                int[] dim_each1 = b1.getDimensions();
                
                if  (dim_each1[1]==1)
                {
                    for (int compt2 = 0; compt2 < dim_each1[0]; compt2++) 
                    {
                        MLCell b2 = (MLCell) b1.get(compt2,0);
                        int[] dim_each2 = b2.getDimensions();
                        
                        if  (dim_each2[1]==1)
                        {
                            for (int compt3 = 0; compt3 < dim_each2[0]; compt3++) 
                            {
                            if ((b2.get(compt3,0)).isEmpty()) {cellarray[compt1][compt2][compt3] = null;} 
                            else {cellarray[compt1][compt2][compt3] = ((MLChar) b2.get(compt3,0)).getString(0);}
                            }
                        }
                        else if  (dim_each2[0]==1)
                        {
                            for (int compt3 = 0; compt3 < dim_each2[1]; compt3++) 
                            {
                            if ((b2.get(0,compt3)).isEmpty()) {cellarray[compt1][compt2][compt3] = null;} 
                            else {cellarray[compt1][compt2][compt3] = ((MLChar) b2.get(0,compt3)).getString(0);}
                            }       
                        }
                    } 
                }
                else if  (dim_each1[0]==1)
                {
                    for (int compt2 = 0; compt2 < dim_each1[1]; compt2++) 
                    {
                        MLCell b2 = (MLCell) b1.get(0,compt2);
                        int[] dim_each2 = b2.getDimensions();
                        
                        if  (dim_each2[1]==1)
                        {
                            for (int compt3 = 0; compt3 < dim_each2[0]; compt3++) 
                            {
                            if ((b2.get(compt3,0)).isEmpty()) {cellarray[compt1][compt2][compt3] = null;} 
                            else {cellarray[compt1][compt2][compt3] = ((MLChar) b2.get(compt3,0)).getString(0);}
                            }
                        }
                        else if  (dim_each2[0]==1)
                        {
                            for (int compt3 = 0; compt3 < dim_each2[1]; compt3++) 
                            {
                            if ((b2.get(0,compt3)).isEmpty()) {cellarray[compt1][compt2][compt3] = null;} 
                            else {cellarray[compt1][compt2][compt3] = ((MLChar) b2.get(0,compt3)).getString(0);}
                            }       
                        }
                    } 
                }
            }
        }
        else if (rows1==1)
        {
            for (int compt1 = 0; compt1 < cols1; compt1++) 
            {
                MLCell b1 = (MLCell) a.get(0,compt1);
                int[] dim_each1 = b1.getDimensions();
                
                if  (dim_each1[1]==1)
                {
                    for (int compt2 = 0; compt2 < dim_each1[0]; compt2++) 
                    {
                        MLCell b2 = (MLCell) b1.get(compt2,0);
                        int[] dim_each2 = b2.getDimensions();
                        
                        if  (dim_each2[1]==1)
                        {
                            for (int compt3 = 0; compt3 < dim_each2[0]; compt3++) 
                            {
                            if ((b2.get(compt3,0)).isEmpty()) {cellarray[compt1][compt2][compt3] = null;} 
                            else {cellarray[compt1][compt2][compt3] = ((MLChar) b2.get(compt3,0)).getString(0);}
                            }
                        }
                        else if  (dim_each2[0]==1)
                        {
                            for (int compt3 = 0; compt3 < dim_each2[1]; compt3++) 
                            {
                            if ((b2.get(0,compt3)).isEmpty()) {cellarray[compt1][compt2][compt3] = null;} 
                            else {cellarray[compt1][compt2][compt3] = ((MLChar) b2.get(0,compt3)).getString(0);}
                            }       
                        }
                    } 
                }
                else if  (dim_each1[0]==1)
                {
                    for (int compt2 = 0; compt2 < dim_each1[1]; compt2++) 
                    {
                        MLCell b2 = (MLCell) b1.get(0,compt2);
                        int[] dim_each2 = b2.getDimensions();
                        
                        if  (dim_each2[1]==1)
                        {
                            for (int compt3 = 0; compt3 < dim_each2[0]; compt3++) 
                            {   
                            if ((b2.get(compt3,0)).isEmpty()) {cellarray[compt1][compt2][compt3] = null;} 
                            else {cellarray[compt1][compt2][compt3] = ((MLChar) b2.get(compt3,0)).getString(0);}
                            }
                        }
                        else if  (dim_each2[0]==1)
                        {
                            for (int compt3 = 0; compt3 < dim_each2[1]; compt3++) 
                            {
                            if ((b2.get(0,compt3)).isEmpty()) {cellarray[compt1][compt2][compt3] = null;} 
                            else {cellarray[compt1][compt2][compt3] = ((MLChar) b2.get(0,compt3)).getString(0);}
                            }       
                        }
                    } 
                }
            }
        }  
        return cellarray;
        }
    } 
    
        

    public String[][] getStringCellMatrix_DiffSizes(MLStructure struct, String field)
    {
        if ((struct.getField(field)).isEmpty()) return null;
        else 
        {
        
        MLCell a        = (MLCell) struct.getField(field);
        int[] dim1      = a.getDimensions();
        int rows1       = dim1[0];      
        int cols1       = dim1[1];
        int length1     = (rows1 > cols1 ? rows1 : cols1);
        
        int max_dim = 0;
        if (cols1==1)
        {
            for (int compt = 0; compt < rows1; compt++) 
            {
                MLCell vec = (MLCell) a.get(compt,0);
                int[] dim_test = vec.getDimensions();
                int tmp_dim = (dim_test[0] > dim_test[1] ? dim_test[0] : dim_test[1]);
                if (tmp_dim>max_dim)
                {
                    max_dim = tmp_dim;
                }
            }
        }
        else
        {
            for (int compt = 0; compt < cols1; compt++) 
            {
                MLCell vec = (MLCell) a.get(0,compt);
                int[] dim_test = vec.getDimensions();
                int tmp_dim = (dim_test[0] > dim_test[1] ? dim_test[0] : dim_test[1]);
                if (tmp_dim>max_dim)
                {
                    max_dim = tmp_dim;
                }
            }
        }
        String[][] cellarray = new String[length1][max_dim];

        if (cols1==1)
        {
            for (int r = 0; r < rows1; r++) 
            {
                MLCell b = (MLCell) a.get(r,0);
                int[] dim_each = b.getDimensions();
                int rows_each       = dim_each[0];      
                int cols_each       = dim_each[1];

                if (cols_each==1)
                {
                    for (int r2 = 0; r2 < rows_each; r2++) 
                    {
                        if ((b.get(r2,0)).isEmpty()) 
                        {cellarray[r][r2] = null;}
                        else {cellarray[r][r2] = ((MLChar) b.get(r2,0)).getString(0);}
                    }
                }
                else if (rows_each==1)
                {
                    for (int c2 = 0; c2 < cols_each; c2++) 
                    {
                        if ((b.get(0,c2)).isEmpty()) 
                        {cellarray[r][c2] = null;}
                        else {cellarray[r][c2] = ((MLChar) b.get(0,c2)).getString(0);}
                    }
                }
            }
        }
        else if (rows1==1)
        {
            for (int c = 0; c < cols1; c++) 
            {
                MLCell b = (MLCell) a.get(0,c);
                int[] dim_each = b.getDimensions();
                int rows_each       = dim_each[0];      
                int cols_each       = dim_each[1];

                if (cols_each==1)
                {
                    for (int r2 = 0; r2 < rows_each; r2++) 
                    {
                        if ((b.get(r2,0)).isEmpty()) 
                        {cellarray[c][r2] = null;}
                        else {cellarray[c][r2] = ((MLChar) b.get(r2,0)).getString(0);}
                    }
                }
                else if (rows_each==1)
                {
                    for (int c2 = 0; c2 < cols_each; c2++) 
                    {
                        if ((b.get(0,c2)).isEmpty()) 
                        {cellarray[c][c2] = null;}
                        else {cellarray[c][c2] = ((MLChar) b.get(0,c2)).getString(0);}
                    }
                }
            }
        }  
        return cellarray;
        }
    } 
    
    public String[][][] getStringCellMatrix_nxm(MLStructure struct, String field)
    {
        if ((struct.getField(field)).isEmpty()) return null;
        else 
        {
        
        MLCell a        = (MLCell) struct.getField(field);
        int[] dim1      = a.getDimensions();
        int rows1       = dim1[0];      
        int cols1       = dim1[1];
        int length1     = (rows1 > cols1 ? rows1 : cols1);
        
        MLCell aa; 
        aa              = (MLCell) a.get(rows1-1,cols1-1);
        int[] dim2      = aa.getDimensions();
        int rows2       = dim2[0];      
        int cols2       = dim2[1];

        MLCell b; 
        String[][][] cellarray = new String[length1][rows2][cols2];
        
        if (cols1==1)
        {
            for (int r = 0; r < rows1; r++) 
            {
                b = (MLCell) a.get(r,cols1-1);
                
                for (int r2 = 0; r2 < rows2; r2++) 
                {
                    for (int c2 = 0; c2 < cols2; c2++) 
                    {
                        if ((b.get(r2,c2)).isEmpty()) 
                        {cellarray[r][r2] = null;}
                        else {cellarray[r][r2][c2] = ((MLChar) b.get(r2,c2)).getString(0);}
                    }
                }
            }
        }
        else if (rows1==1)
        {
            for (int c = 0; c < cols1; c++) 
            {
                b = (MLCell) a.get(rows1-1,c);
                
                for (int r2 = 0; r2 < rows2; r2++) 
                {
                    for (int c2 = 0; c2 < cols2; c2++) 
                    {
                        if ((b.get(r2,c2)).isEmpty()) 
                        {cellarray[c][r2] = null;}
                        else {cellarray[c][r2][c2] = ((MLChar) b.get(r2,c2)).getString(0);}
                    }
                }
            }
        }  
        return cellarray;
        }
    } 
    
        
   public String[][] getStringCellMatrix(MLStructure struct, String field)
    {
        if ((struct.getField(field)).isEmpty()) return null;
        else 
        {
        
        MLCell a        = (MLCell) struct.getField(field);
        int[] dim1      = a.getDimensions();
        int rows1       = dim1[0];      
        int cols1       = dim1[1];
        int length1     = (rows1 > cols1 ? rows1 : cols1);
        
        MLCell aa; 
        aa              = (MLCell) a.get(rows1-1,cols1-1);
        int[] dim2      = aa.getDimensions();
        int rows2       = dim2[0];      
        int cols2       = dim2[1];
        int length2     = (rows2 > cols2 ? rows2 : cols2);

        MLCell b; 
        String[][] cellarray = new String[length1][length2];
        
        if (cols1==1)
        {
            for (int r = 0; r < rows1; r++) 
            {
                b = (MLCell) a.get(r,cols1-1);

                if (cols2==1)
                {
                    for (int r2 = 0; r2 < rows2; r2++) 
                    {
                        if ((b.get(r2,cols2-1)).isEmpty()) 
                        {cellarray[r][r2] = null;}
                        else {cellarray[r][r2] = ((MLChar) b.get(r2,cols2-1)).getString(0);}
                    }
                }
                else
                {
                    for (int c2 = 0; c2 < cols2; c2++) 
                    {
                        if ((b.get(rows2-1,c2)).isEmpty()) 
                        {cellarray[r][c2] = null;}
                        else {cellarray[r][c2] = ((MLChar) b.get(rows2-1,c2)).getString(0);}
                    }
                }
            }
        }
        else
        {
            for (int c = 0; c < cols1; c++) 
            {
                b = (MLCell) a.get(rows1-1,c);

                if (cols2==1)
                {
                    for (int r2 = 0; r2 < rows2; r2++) 
                    {
                        if ((b.get(r2,cols2-1)).isEmpty()) 
                        {cellarray[c][r2] = null;}
                        else {cellarray[c][r2] = ((MLChar) b.get(r2,cols2-1)).getString(0);}
                    }
                }
                else
                {
                    for (int c2 = 0; c2 < cols2; c2++) 
                    {
                        if ((b.get(rows2-1,c2)).isEmpty()) 
                        {cellarray[c][c2] = null;}
                        else {cellarray[c][c2] = ((MLChar) b.get(rows2-1,c2)).getString(0);}
                    }
                }
            }
        }  
        return cellarray;
        }
    } 
    
    public String[][] getStringCellMatrix(Map map, String field)
    {
        if (((MLArray)(map.get(field))).isEmpty()) return  null;
        else
        {
        
        MLCell a        = (MLCell) map.get(field);
        int[] dim1      = a.getDimensions();
        int rows1       = dim1[0];      
        int cols1       = dim1[1];
        int length1     = (rows1 > cols1 ? rows1 : cols1);
        
        MLCell aa; 
        aa              = (MLCell) a.get(rows1-1,cols1-1);
        int[] dim2      = aa.getDimensions();
        int rows2       = dim2[0];      
        int cols2       = dim2[1];
        int length2     = (rows2 > cols2 ? rows2 : cols2);

        MLCell b; 
        String[][] cellarray = new String[length1][length2];
        
        if (cols1==1)
        {
            for (int r = 0; r < rows1; r++) 
            {
                b = (MLCell) a.get(r,cols1-1);

                if (cols2==1)
                {
                    for (int r2 = 0; r2 < rows2; r2++) 
                    {
                        if ((b.get(r2,cols2-1)).isEmpty()) 
                        {cellarray[r][r2] = null;}
                        else {cellarray[r][r2] = ((MLChar) b.get(r2,cols2-1)).getString(0);}
                    }
                }
                else
                {
                    for (int c2 = 0; c2 < cols2; c2++) 
                    {
                        if ((b.get(rows2-1,c2)).isEmpty()) 
                        {cellarray[r][c2] = null;}
                        else {cellarray[r][c2] = ((MLChar) b.get(rows2-1,c2)).getString(0);}
                    }
                }
            }
        }
        else
        {
            for (int c = 0; c < cols1; c++) 
            {
                b = (MLCell) a.get(rows1-1,c);

                if (cols2==1)
                {
                    for (int r2 = 0; r2 < rows2; r2++) 
                    {
                        if ((b.get(r2,cols2-1)).isEmpty()) 
                        {cellarray[c][r2] = null;}
                        else {cellarray[c][r2] = ((MLChar) b.get(r2,cols2-1)).getString(0);}
                    }
                }
                else
                {
                    for (int c2 = 0; c2 < cols2; c2++) 
                    {
                        if ((b.get(rows2-1,c2)).isEmpty()) 
                        {cellarray[c][c2] = null;}
                        else {cellarray[c][c2] = ((MLChar) b.get(rows2-1,c2)).getString(0);}
                    }
                }
            }
        }  
        return cellarray;
        }
    } 
 

    public String[] getStringCellArray(MLStructure struct, String field)
    {
        if (struct.getField(field)==null) return null;
        else 
        {
            MLCell a            = (MLCell) struct.getField(field);
            int nitem           = (a.cells()).size();
            String[] cellarray  = new String[nitem];
            for (int m = 0; m < nitem; m++) 
            {
                if (a.get(m).isEmpty()) cellarray[m] = null;
                else
                {
                cellarray[m] = ((MLChar) a.get(m)).getString(0);
                }
            }    
            return cellarray;
        }
    }  
    
    public String[] getStringCellArray(Map map, String field)
    {
        if ((map.get(field))==null) return  null;
        else if (((MLArray)(map.get(field))).isEmpty()) return  null;
        //if (((MLArray)(map.get(field))).isEmpty()) return  null;
        //if ((map.get(field))==null) return  null;
        else
        {
        MLCell a            = (MLCell) map.get(field);
        int nitem           = (a.cells()).size();
        String[] cellarray  = new String[nitem];
        for (int m = 0; m < nitem; m++) 
        {
            //if (((MLArray) a.get(m)).isEmpty())  cellarray[m] = null;
            //else
            //{
            cellarray[m] = ((MLChar) a.get(m)).getString(0);
            //}
        }
        return cellarray;
        }
    }  
    
    
    public String getString(MLStructure struct, String field)
    {    if ((struct.getField(field)).isEmpty()) return null;
        else 
        {
        return ((MLChar) struct.getField(field)).getString(0);
        }
    }

    public String getString(Map map, String field)
    {   
        if (((MLArray)(map.get(field))).isEmpty()) return  null;
        return ((MLChar) map.get(field)).getString(0);
    }
    
    
    public int getInt(MLStructure struct, String field)
    {
         return (int) ((MLDouble) struct.getField(field)).getArray()[0][0];
    }   


    public int getInt(Map map, String field)
    {
         return (int) ((MLDouble) map.get(field)).getArray()[0][0];
    } 

    
    public double getDouble(MLStructure struct, String field)
    {
        return (double) ((MLDouble) struct.getField(field)).getArray()[0][0];
    }   
    
    public double[][] getDoubleCell(MLStructure struct, String field)
    {
        MLCell a = (MLCell) struct.getField(field);
        int dima = a.getSize();
        MLArray aa = a.get(0);
        int dimaa = aa.getSize();
        double[][] c = new double[dima][dimaa];

        for (int i = 0; i < dima; i++) 
        {
            for (int j = 0; j < dimaa; j++) 
            {
                MLArray sub = a.get(i);
                double[] b = ((MLDouble) sub).getArray()[0];
                c[i][j] = b[j];
            }
        }
        return c;
    }
    
    public double[] getDoubleArray(MLStructure struct, String field)
    {
        if (((MLDouble)struct.getField(field)).isEmpty()) return null;
        else return ((MLDouble) struct.getField(field)).getArray()[0];
    }          
    
    public double[] getDoubleArray(Map map, String field)
    {
        if (((MLDouble)(map.get(field))).isEmpty()) return  null;
        return ((MLDouble) map.get(field)).getArray()[0];
    }    

    //====================================================================================================================
    
    
    /*
    public MLCell setStringCellMatrix(String[][] data)
    {
        int row = data.length;
        int col = data[0].length;
        MLCell str_dblearr = new MLCell("XXX",new int[]{row,col});
        
        for (int r = 0; r < row; r++) 
        {
            for (int c = 0; c < col; c++) 
            {
                MLChar mlchar = new MLChar("XXX",data[r][c]);
                str_dblearr.set(mlchar,r,c);
            }
        }
        return str_dblearr;
    }
    */
    
    public MLCell setStringColDbleLineCell(String[][][] data)
    {
        if (data==null)
        {
        int[] dim = {0,0};
        return new MLCell("XXX",dim);
        }
        else
        {
        int dimsub = data.length;
        int dimsubsub = data[0].length;
        int dimsubsubsub = data[0][0].length;
        
        MLCell sub_cell = new MLCell("XXX",new int[]{dimsub,1});
        
        for (int s = 0; s < dimsub; s++) 
        {
            MLCell subsub_cell = new MLCell("XXX",new int[]{1,dimsubsub});

            for (int ss = 0; ss < dimsubsub; ss++) 
            {
                MLCell subsubsub_cell = new MLCell("XXX",new int[]{1,dimsubsubsub});
            
                for (int sss = 0; sss < dimsubsubsub; sss++) 
                {
                    if (data[s][ss][sss]==null)
                    {
                        MLChar mlchar = new MLChar("XXX","");
                        subsubsub_cell.set(mlchar,0,sss);
                    }
                    else
                    {
                        MLChar mlchar = new MLChar("XXX",data[s][ss][sss]);
                        subsubsub_cell.set(mlchar,0,sss);
                    }
                }   
                
            subsub_cell.set(subsubsub_cell,0,ss);
            }
            
            sub_cell.set(subsub_cell,s,0);
        }
        return sub_cell;
        }
    }
    
    
    public MLCell setStringTripleColumnCell(String[][][] data)
    {
        if (data==null)
        {
        int[] dim = {0,0};
        return new MLCell("XXX",dim);
        }
        else
        {
        int dimsub = data.length;
        int dimsubsub = data[0].length;
        int dimsubsubsub = data[0][0].length;
        
        MLCell sub_cell = new MLCell("XXX",new int[]{dimsub,1});
        
        for (int s = 0; s < dimsub; s++) 
        {
            MLCell subsub_cell = new MLCell("XXX",new int[]{dimsubsub,1});

            for (int ss = 0; ss < dimsubsub; ss++) 
            {
                MLCell subsubsub_cell = new MLCell("XXX",new int[]{dimsubsubsub,1});
            
                for (int sss = 0; sss < dimsubsubsub; sss++) 
                {
                    if (data[s][ss][sss]==null)
                    {
                        MLChar mlchar = new MLChar("XXX","");
                        subsubsub_cell.set(mlchar,sss,0);
                    }
                    else
                    {
                        MLChar mlchar = new MLChar("XXX",data[s][ss][sss]);
                        subsubsub_cell.set(mlchar,sss,0);
                    }
                }   
                
            subsub_cell.set(subsubsub_cell,ss,0);
            }
            
            sub_cell.set(subsub_cell,s,0);
        }
        return sub_cell;
        }
    }
    
    public MLCell setStringColLineCell(String[][] data)
    {
        if (data==null)
        {
        int[] dim = {0,0};
        return new MLCell("XXX",dim);
        }
        
        else
        {
        int dimsub = data.length;
        //int dimsubsub = data[0].length;
        
        MLCell sub_cell = new MLCell("XXX",new int[]{dimsub,1});
        
        int dim_max = 0;
        for (int ct = 0; ct < dimsub; ct++) 
        {
            int dim_turn = data[ct].length;
            if (dim_turn>dim_max)
            {
                dim_max = dim_turn;
            }
        }

        for (int s = 0; s < dimsub; s++) 
        {
            MLCell subsub_cell = new MLCell("XXX",new int[]{1,dim_max});
            int dim_each = data[s].length;
            
            for (int ss = 0; ss < dim_each; ss++) 
            {
                if (data[s][ss]==null)
                {
                MLChar mlchar = new MLChar("XXX","");
                subsub_cell.set(mlchar,0,ss);    
                }
                else
                {
                MLChar mlchar = new MLChar("XXX",data[s][ss]);
                subsub_cell.set(mlchar,0,ss);
                }     
            }   
            sub_cell.set(subsub_cell,s,0);
        }
        return sub_cell;
        }
    }
    
    public MLCell setStringLineColCell(String[][] data)
    {
        if (data==null)
        {
        int[] dim = {0,0};
        return new MLCell("XXX",dim);
        }
        else
        {
        int dimsub = data.length;
        int dimsubsub = data[0].length;
        
        MLCell sub_cell = new MLCell("XXX",new int[]{1,dimsub});

        for (int s = 0; s < dimsub; s++) 
        {
            MLCell subsub_cell = new MLCell("XXX",new int[]{dimsubsub,1});
            
            for (int ss = 0; ss < dimsubsub; ss++) 
            {
                if (data[s][ss]==null)
                {
                MLChar mlchar = new MLChar("XXX","");
                subsub_cell.set(mlchar,0,ss);    
                }
                else
                {
                MLChar mlchar = new MLChar("XXX",data[s][ss]);
                subsub_cell.set(mlchar,ss,0);
                }
            }   
            sub_cell.set(subsub_cell,0,s);
        }
        return sub_cell;
        }
    }
    
    
    public MLCell setStringColumnCell(String[][] data)
    {
        if (data==null)
        {
        int[] dim = {0,0};
        return new MLCell("XXX",dim);
        }
        else
        {
        int dimsub = data.length;
        int dimsubsub = data[0].length;
        
        MLCell sub_cell = new MLCell("XXX",new int[]{dimsub,1});

        for (int s = 0; s < dimsub; s++) 
        {
            MLCell subsub_cell = new MLCell("XXX",new int[]{dimsubsub,1});
            
            for (int ss = 0; ss < dimsubsub; ss++) 
            {
                if (data[s][ss]==null)
                {
                MLChar mlchar = new MLChar("XXX","");
                subsub_cell.set(mlchar,0,ss);    
                }
                else
                {
                MLChar mlchar = new MLChar("XXX",data[s][ss]);
                subsub_cell.set(mlchar,ss,0);
                }
            }   
            sub_cell.set(subsub_cell,s,0);
        }
        return sub_cell;
        }
    }
    
    public MLCell setStringCellMatrix_nxm(String[][][] data)
    {
        if (data==null)
        {
        int[] dim = {0,0};
        return new MLCell("XXX",dim);
        }
        else
        {
        int dimsub = data.length;
        int dimsubsub = data[0].length;
        int dimsubsubsub = data[0][0].length;
        
        MLCell sub_cell = new MLCell("XXX",new int[]{1,dimsub});

        for (int s = 0; s < dimsub; s++) 
        {
            MLCell subsub_cell = new MLCell("XXX",new int[]{dimsubsub,dimsubsubsub});
            
            for (int ss = 0; ss < dimsubsub; ss++) 
            {
                for (int sss = 0; sss < dimsubsubsub; sss++) 
                {
                    if (data[s][ss][sss]==null)
                    {
                    MLChar mlchar = new MLChar("XXX","");
                    subsub_cell.set(mlchar,ss,sss);    
                    }
                    else
                    {
                    MLChar mlchar = new MLChar("XXX",data[s][ss][sss]);
                    subsub_cell.set(mlchar,ss,sss);
                    }
                }
            }   
            sub_cell.set(subsub_cell,0,s);
        }
        return sub_cell;
        }
    }
    
    public MLCell setStringLineCell(String[][] data)
    {
        if (data==null)
        {
        int[] dim = {0,0};
        return new MLCell("XXX",dim);
        }
        else
        {
        int dimsub = data.length;
        int dimsubsub = data[0].length;
        
        MLCell sub_cell = new MLCell("XXX",new int[]{1,dimsub});

        for (int s = 0; s < dimsub; s++) 
        {
            MLCell subsub_cell = new MLCell("XXX",new int[]{1,dimsubsub});
            
            for (int ss = 0; ss < dimsubsub; ss++) 
            {
                if (data[s][ss]==null)
                {
                MLChar mlchar = new MLChar("XXX","");
                subsub_cell.set(mlchar,0,ss);    
                }
                else
                {
                MLChar mlchar = new MLChar("XXX",data[s][ss]);
                subsub_cell.set(mlchar,0,ss);
                }
            }   
            sub_cell.set(subsub_cell,0,s);
        }
        return sub_cell;
        }
    }
    
    public MLArray setStringColumnArray(String[] data)
    {
        if (data==null)
        {
        int[] dim = {0,0};
        return new MLCell("XXX",dim);
        }
        else
        {
        MLCell str_arr = new MLCell("XXX",new int[]{data.length,1});
                
        for (int m = 0; m < data.length; m++) 
        {
            if (data[m]==null)
            {
            MLChar mlchar = new MLChar("XXX","");
            str_arr.set(mlchar,m,0); 
            }
            else
            {
            MLChar mlchar = new MLChar("XXX",data[m]);
            str_arr.set(mlchar,m,0);
            }
        }
        return str_arr;
        }
    }
    
    public MLArray setStringLineArray(String[] data)
    {
        if (data==null)
        {
        return new MLChar("XXX", ""); 
        }
        else
        {
        MLCell str_arr = new MLCell("XXX",new int[]{1,data.length});
                
        for (int m = 0; m < data.length; m++) 
        {
            if (data[m]==null)
            {
            MLChar mlchar = new MLChar("XXX","");
            str_arr.set(mlchar,m,0); 
            }
            else
            {
            MLChar mlchar = new MLChar("XXX",data[m]);
            str_arr.set(mlchar,0,m);
            }
        }
        return str_arr;
        }
    }
    
    public MLArray setDoubleColLineArray(double[][] data)
    {
        if (data==null)
        {
        int dim[] = {0,0};
        return new MLDouble("XXX",dim); 
        }
        else
        {
        int dim = data.length;
        int dimsub = data[0].length;
        MLCell mldouble_first = new MLCell("XXX",new int[]{1,dim});
        for (int s = 0; s < dim; s++) 
        {
            MLDouble mldouble = new MLDouble("XXX",new int[]{dimsub,1});
            
            for (int ss = 0; ss < dimsub; ss++) 
            {
                mldouble.set(data[s][ss],ss,0);
            }   
            mldouble_first.set(mldouble,0,s);  
        }
        return (MLArray) mldouble_first;
        }
    }
    
    public MLArray setDoubleLineArray(double[] data)
    {
        if (data==null)
        {
        int dim[] = {0,0};
        return new MLDouble("XXX",dim); 
        }
        else
        {
        int dim[] = {1,data.length};
        MLDouble mljustdouble = new MLDouble("XXX",dim);//data,data.length);
        for (int m = 0; m < data.length; m++) 
        {
            mljustdouble.set(data[m],0,m);
        }
        return mljustdouble;
        }
    } 
        
    public MLArray setDoubleColumnArray(double[] data)
    {
        if (data==null)
        {
            int dim[] = {0,0};
            return new MLDouble("XXX",dim); 
        }
        else
        {
        MLDouble mljustdouble = new MLDouble("XXX",data,data.length);
        return mljustdouble;
        }
    } 

    
    public MLArray setString(String data)
    {    
        if (data==null)
        {
        return new MLChar("XXX", ""); 
        }
        else
        {
        return new MLChar("XXX", data);
        }
    }
    
    /*
    public MLDouble setInt(int data)
    {
        double[] justint = new double[]{data};
        MLDouble mlint = new MLDouble("XXX",justint,1);
        return mlint;
    } 
    */
    
    public MLDouble setDouble(double data)
    {
        double[] justdouble = new double[]{data};
        MLDouble mljustdouble = new MLDouble("XXX",justdouble,1);
        return mljustdouble;
    } 
    
}
