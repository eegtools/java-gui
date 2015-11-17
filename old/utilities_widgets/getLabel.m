function [label] = getLabel(string, font_name, font_size)
    % The function adds a label to the panel with the font and style specified
    % by the input variable.
    
    if (nargin < 1), string = '';    end
    if (nargin < 2), font_name = 'Arial'; end
    if (nargin < 3), font_size = 12;  end

    label = javax.swing.JLabel(string);
    font_type = java.awt.Font.ROMAN_BASELINE;
    font = java.awt.Font(font_name, font_type, font_size);
    label.setFont(font);
end
