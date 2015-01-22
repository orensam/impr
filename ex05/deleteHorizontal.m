function [outImage] = deleteHorizontal(image, lowFilt, highFilt, levels)
% Deletes horizontal lines from a page image.
    
    [h, w] = size(image);
    wd = DWT(image, lowFilt, highFilt, levels);
    
    top=1;
    bottom=h/2
    left=w/2
    right=w
    
    for i = 1:levels
        wd(top:bottom, left+1:right)=0;
        bottom=bottom/2
        left=left/2
        right=right/2
    end
    
    outImage = IDWT(wd, lowFilt, highFilt, levels);
        
end
