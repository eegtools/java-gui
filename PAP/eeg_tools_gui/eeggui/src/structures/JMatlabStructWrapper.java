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
    
    public String[][] getStringCellMatrix(MLStructure struct, String field)
    {
        MLCell a    = (MLCell) struct.getField(field);
        int[] dim   = a.getDimensions();
        int rows    = dim[0];      int cols = dim[1];
        
        
        MLCell b;
        int[] subdim = new int[2];
        for (int r = 0; r < rows; r++) 
           for (int c = 0; c < cols; c++)
           {
                b = (MLCell) a.get(r,c);
                subdim = b.getDimensions();
           }
        int second_dim_id;
        int second_dim;
        
        if (subdim[0] == 1 && subdim[1] > 1)
        {
            second_dim_id = 0;
            second_dim = subdim[1];
        }
        else if (subdim[1] == 1 && subdim[0] > 1)
        {
            second_dim_id = 1;
            second_dim = subdim[0];
        }
        else return null;
                
        String[][] cellarray  = new String[rows][second_dim];        
        
        for (int r = 0; r < rows; r++) 
           for (int c = 0; c < cols; c++)
           {
                b = (MLCell) a.get(r,c);
                if (second_dim == 0)
                    for (int rr = 0; rr < subdim[0]; rr++) 
                       for (int cc = 0; cc < subdim[1]; cc++)
                       {     
                           cellarray[r][rr] = ((MLChar) b.get(rr,cc)).getString(0);
                       }
                else
                    for (int rr = 0; rr < subdim[0]; rr++) 
                       for (int cc = 0; cc < subdim[1]; cc++)
                       {     
                           cellarray[r][cc] = ((MLChar) b.get(rr,cc)).getString(0);
                       }                    
           }    
        return cellarray;
    } 

    public String[] getStringCellArray(MLStructure struct, String field)
    {
        if ((struct.getField(field)).isEmpty())
        {
            return null;
        }
        else 
        {
            MLCell a            = (MLCell) struct.getField(field);
            int nitem           = (a.cells()).size();
            String[] cellarray  = new String[nitem];
            for (int m = 0; m < nitem; m++) 
            {
                cellarray[m] = ((MLChar) a.get(m)).getString(0);
            }    
            return cellarray;
        }
    }  
    
    public String[] getStringCellArray(Map map, String field)
    {
        MLCell a            = (MLCell) map.get(field);
        int nitem           = (a.cells()).size();
        String[] cellarray  = new String[nitem];
        for (int m = 0; m < nitem; m++) cellarray[m] = ((MLChar) a.get(m)).getString(0);    
        return cellarray;
    }  
    
    
    public String getString(MLStructure struct, String field)
    {    
        return ((MLChar) struct.getField(field)).getString(0);
    }

    public String getString(Map map, String field)
    {    
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
    
    public double[] getDoubleArray(MLStructure struct, String field)
    {
        if ((struct.getField(field)).isEmpty())
        {
            return null;
        }
        else return ((MLDouble) struct.getField(field)).getArray()[0];
    }          
    
    public double[] getDoubleArray(Map map, String field)
    {
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
    
    public MLCell setStringTripleColumnCell(String[][][] data)
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
                    MLChar mlchar = new MLChar("XXX",data[s][ss][sss]);
                    subsubsub_cell.set(mlchar,sss,0);
                }   
                
            subsub_cell.set(subsubsub_cell,ss,0);
            }
            
            sub_cell.set(subsub_cell,s,0);
        }
        
        return sub_cell;
    }
    
    public MLCell setStringColLineCell(String[][] data)
    {
        int dimsub = data.length;
        int dimsubsub = data[0].length;
        
        MLCell sub_cell = new MLCell("XXX",new int[]{dimsub,1});

        for (int s = 0; s < dimsub; s++) 
        {
            MLCell subsub_cell = new MLCell("XXX",new int[]{1,dimsubsub});
            
            for (int ss = 0; ss < dimsubsub; ss++) 
            {
                MLChar mlchar = new MLChar("XXX",data[s][ss]);
                subsub_cell.set(mlchar,0,ss);
            }   
            sub_cell.set(subsub_cell,s,0);
        }
        
        return sub_cell;
    }
    
    public MLCell setStringLineColCell(String[][] data)
    {
        int dimsub = data.length;
        int dimsubsub = data[0].length;
        
        MLCell sub_cell = new MLCell("XXX",new int[]{1,dimsub});

        for (int s = 0; s < dimsub; s++) 
        {
            MLCell subsub_cell = new MLCell("XXX",new int[]{dimsubsub,1});
            
            for (int ss = 0; ss < dimsubsub; ss++) 
            {
                MLChar mlchar = new MLChar("XXX",data[s][ss]);
                subsub_cell.set(mlchar,ss,0);
            }   
            sub_cell.set(subsub_cell,0,s);
        }
        
        return sub_cell;
    }
    
    
    public MLCell setStringColumnCell(String[][] data)
    {
        int dimsub = data.length;
        int dimsubsub = data[0].length;
        
        MLCell sub_cell = new MLCell("XXX",new int[]{dimsub,1});

        for (int s = 0; s < dimsub; s++) 
        {
            MLCell subsub_cell = new MLCell("XXX",new int[]{dimsubsub,1});
            
            for (int ss = 0; ss < dimsubsub; ss++) 
            {
                MLChar mlchar = new MLChar("XXX",data[s][ss]);
                subsub_cell.set(mlchar,ss,0);
            }   
            sub_cell.set(subsub_cell,s,0);
        }
        
        return sub_cell;
    }
    
    public MLCell setStringLineCell(String[][] data)
    {
        int dimsub = data.length;
        int dimsubsub = data[0].length;
        
        MLCell sub_cell = new MLCell("XXX",new int[]{1,dimsub});

        for (int s = 0; s < dimsub; s++) 
        {
            MLCell subsub_cell = new MLCell("XXX",new int[]{1,dimsubsub});
            
            for (int ss = 0; ss < dimsubsub; ss++) 
            {
                MLChar mlchar = new MLChar("XXX",data[s][ss]);
                subsub_cell.set(mlchar,0,ss);
            }   
            sub_cell.set(subsub_cell,0,s);
        }
        
        return sub_cell;
    }
    
    public MLCell setStringColumnArray(String[] data)
    {
        MLCell str_arr = new MLCell("XXX",new int[]{data.length,1});
                
        for (int m = 0; m < data.length; m++) 
        {
            MLChar mlchar = new MLChar("XXX",data[m]);
            str_arr.set(mlchar,m,0);
        }
        return str_arr;
    }
    
    public MLCell setStringLineArray(String[] data)
    {
        MLCell str_arr = new MLCell("XXX",new int[]{1,data.length});
                
        for (int m = 0; m < data.length; m++) 
        {
            MLChar mlchar = new MLChar("XXX",data[m]);
            str_arr.set(mlchar,0,m);
        }
        return str_arr;
    }
    
        
    public MLDouble setDoubleColumnArray(double[] data)
    {
        MLDouble mljustdouble = new MLDouble("XXX",data,data.length);
        return mljustdouble;
    } 

    
    public MLChar setString(String data)
    {    
        return new MLChar("XXX", data);
    }
    
    public MLDouble setInt(int data)
    {
        double[] justint = new double[]{data};
        MLDouble mlint = new MLDouble("XXX",justint,1);
        return mlint;
    } 
    
    public MLDouble setDouble(double data)
    {
        double[] justdouble = new double[]{data};
        MLDouble mljustdouble = new MLDouble("XXX",justdouble,1);
        return mljustdouble;
    } 

    
}
