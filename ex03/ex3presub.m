function ex3presub
display(' ');
display('Started ex3 pre-submission script.');
display(' ');
display('Disclaimer');
display('----------');
display('The purpose of this script is to make sure that your code is compliant');
display('with the exercise''s technical definitions (i.e. variable sizes, dimensions, etc.).');
display('It does not test the quality of your results. Passing this script helps to ensure that ');
display('you won''t insult the grader with runtime errors, unsolicited figures and exceptions.');
display(' ');
display('- Closing all open figures (hope you don''t mind)...');
close all;

display(' ');
% Create dummy image
img = zeros(400,400);

display('Section 3.1');
display('-----------');
try 
  display('- Trying to create gaussian pyramid...')
  % Build a gaussian pyramid
  [gpyr,filter] = GaussianPyramid(img,3,3);
catch 
  display('- Failed (caught an exception, looks like runtime error).');
  return;
end
  display('- Passed.');
try
  display('- Checking gaussian pyramid type and structure...');    
  w = whos('gpyr');    
  % Make sure its a cell array
  if ~strcmp('cell',w.class)
    display('- Failed. gpyr type is wrong. Expecting cell array.');
    return
  end

  % Make sure it has the right dimensions
  if ~(ndims(gpyr)==2)
    display('- Failed. gpyr has ndims!=2. Expecting cell ndims(gpyr)==2.');
    return
  end
    
  % Test cell array size
  if ~(all([3 1]==w.size))
    display('- Failed. pyramid cell size is wrong. Expecting size 3x1.');
    return;
  end
    
  % Make sure the gaussian blur filter has the right dimensions
  if ~(ndims(filter)==2)
    display('- Failed. The filter has ndims!=2. Expecting ndims(filter)==2.');
    return
  end
    
  % Make sure its a double array
  if ~strcmp('double',class(filter))
    display('- Failed. filter type is wrong. Expecting double.');
    return
  end
    
  % Test gaussian blur filter size
  if ~(all([1 3] == size(filter)))
    display('- Failed. Wrong blur filter size. Expecting size 3x1.');
    return;
  end 
    
  % Check image dimensions
  if (any([ndims(gpyr{1})~=2 ndims(gpyr{2})~=2 ndims(gpyr{3})~=2]))
    display('- Failed. Images in gpyr should have 2 dimensions.');
    return;
  end
catch  
  display('- Failed (caught an exception, looks like runtime error).');
  return;
end
display('- Passed.');

try 
  display('- Trying to create laplacian pyramid...')
  % Build a laplacian pyramid
  [lpyr,filter] = LaplacianPyramid(img,3,3);
catch 
  display('- Failed (caught an exception, looks like runtime error).');
  return;
end
  display('- Passed.');
try
  display('- Checking laplacian pyramid type and structure...');    
  w = whos('lpyr');    
  % Make sure its a cell array
  if ~strcmp('cell',w.class)
    display('- Failed. lpyr type is wrong. Expecting cell array.');
    return
  end

  % Make sure it has the right dimensions
  if ~(ndims(lpyr)==2)
    display('- Failed. lpyr has ndims!=2. Expecting cell ndims(lpyr)==2.');
    return
  end
    
  % Test cell array size
  if ~(all([3 1]==w.size))
    display('- Failed. pyramid cell size is wrong. Expecting size 3x1.');
    return;
  end
    
  % Make sure the laplacian blur filter has the right dimensions
  if ~(ndims(filter)==2)
    display('- Failed. The filter has ndims!=2. Expecting ndims(filter)==2.');
    return
  end
    
  % Make sure its a double array
  if ~strcmp('double',class(filter))
    display('- Failed. filter type is wrong. Expecting double.');
    return
  end
    
  % Test laplacian blur filter size
  if ~(all([1 3] == size(filter)))
    display('- Failed. Wrong blur filter size. Expecting size 3x1.');
    return;
  end 
    
  % Check image dimensions
  if (any([ndims(lpyr{1})~=2 ndims(lpyr{2})~=2 ndims(lpyr{3})~=2]))
    display('- Failed. Images in lpyr should have 2 dimensions.');
    return;
  end
catch  
  display('- Failed (caught an exception, looks like runtime error).');
  return;
end
display('- Passed.');
display(' ');


display('Section 3.2');
display('-----------');
try 
  display('- Trying to reconstruct gaussian pyramid from laplacian pyramid... (quality not checked)')
  % Reconstruct the gaussian pyramid from the laplacian pyramid
  im = LaplacianToImage(lpyr, filter, ones(1,size(lpyr,1)));
catch 
  display('- Failed (caught an exception, looks like runtime error).');
  return;
end
display('- Passed.');
    
try
  display('- Checking reconstructed pyramid type and structure...');    
  w = whos('im');
  % Make sure its a cell array
  if ~strcmp('double',w.class)
    display('- Failed. gpyr type is wrong. Expecting cell array.');
    return
  end

  w = whos('im');
  % Make sure its a double's matrix
  if ~strcmp('double',w.class)
    display('- Failed. reconImg type is wrong. Expecting double.');
    return
  end
    
  if ndims(im)~=2
    display('- Failed. reconImg should have 2 dimensions.');
    return
  end
    
  if ~(all(size(im) == size(img)))
    display('*** Warning: Reconstructed image size is different that original image size!');
  end
catch
  display('- Failed (caught an exception, looks like runtime error).');
  return;
end
display('- Passed.');

try
  display('- Trying to run im = renderPyramid(gpyr)...')
  im = renderPyramid(gpyr,2);
catch 
  display('- Failed (caught an exception, looks like runtime error).');
  return;
end
display('- Passed.');
    
try    
  display('- Checking im type and structure...')
  w = whos('im');
  % Make sure its a double's array
  if ~strcmp('double',w.class)
    display('- Failed. im type is wrong. Expecting double.');
    return
  end
    
  if ndims(im)~=2
    display('- Failed. im should have 2 dimensions.');
    return
  end
    
  if ~(all([400 600]==w.size))
    display('*** Warning: im size is wrong. Expecting size 400x700.');
  end    
catch 
  display('- Failed (caught an exception, looks like runtime error).');
  return;
end
display('- Passed.');

display('- Checking for unsolicited figures..');
% Count the number of open figures. Should be zero.
% including those with handlevisibility:off
fh=findall(0,'type','figure');
% excluding those ...
fh=findobj(0,'type','figure');
% ... and
nfh=length(fh);

if (nfh>0)
  display('- Failed: Your code displays figures when it shouldn''t!'); 
  uiwait(msgbox('Failed: Your code displays figures when it shouldn''t!'));    
  return;
end
display('- Passed.');
display(' ');

display('Section 2.3');
display('-----------');
try    
  display('- Checking displayPyramid opens exactly 1 figure...')
  displayPyramid(gpyr,2);
     
  % Count the number of open figures. Should be one.
  % including those with handlevisibility:off
  fh=findall(0,'type','figure');
  % excluding those ...
  fh=findobj(0,'type','figure');
  % ... and
  nfh=length(fh);
    
  if (nfh~=1)
    display('- Failed: displayPyramid should display exactly 1 figure!'); 
    uiwait(msgbox('Failed: displayPyramid should display exactly 1 figure!'));
    return;
  end
  
catch
  display('- Failed (caught an exception, looks like runtime error).');
  return;
end
display('- Passed.');
close all;
display(' ');


display('Section 3.3');
display('---------');
try    
  display('- Checking pyramidBlending...')
    
  % dummy run
  resBlend = pyramidBlending(img,img,img,3,3,5);

catch
  display('- Failed (caught an exception, looks like runtime error).');
  return;
end
display('- Passed.'); 
    
try    
  display('- Checking blended image result type and size...')

  % Count the number of open figures. Should be none.
  % including those with handlevisibility:off
  fh=findall(0,'type','figure');
  % excluding those ...
  fh=findobj(0,'type','figure');
  % ... and
  nfh=length(fh);

  if (nfh~=0)
    display('- Failed: pyramidBlending should not display any figure!'); 
    uiwait(msgbox('Failed: pyramidBlending should not display any figure!'));    
    return;
  end

  % Make sure its a double's matrix
  w = whos('resBlend');
  if ~strcmp('double',w.class)
    display('- Failed. resBlend type is wrong. Expecting double.');
    return
  end

  if ndims(resBlend)~=2
    display('- Failed. resBlend should have 2 dimensions.');
    return
  end

  if ~(all(size(resBlend) == size(img)))
    display('*** Warning: Blended image size differs from original image1/image2/mask size!');
  end
    
catch
  display('- Failed (caught an exception, looks like runtime error).');
  return;
end
display('- Passed.'); 

close all;
display(' ');

display('Section 4')
display('---------');  
try    
  display('- Checking blendingExample1 opens exactly 4 figures...')
  blendingExample1();

  % Count the number of open figures. Should be 4.
  % including those with handlevisibility:off
  fh=findall(0,'type','figure');
  % excluding those ...
  fh=findobj(0,'type','figure');
  % ... and
  nfh=length(fh);
  if (nfh~=4)
    display('- Failed: blendingExample1 should display exactly 4 figures!'); 
    uiwait(msgbox('Failed: blendingExample1 should display exactly 4 figures'));    
    return;
  end    
catch
  display('- Failed (caught an exception, looks like runtime error).');
  return;
end
display('- Passed.');
close all;

try    
  display('- Checking blendingExample2 opens exactly 4 figures...')
  blendingExample2();

  % Count the number of open figures. Should be 4.
  % including those with handlevisibility:off
  fh=findall(0,'type','figure');
  % excluding those ...
  fh=findobj(0,'type','figure');
  % ... and
  nfh=length(fh);
  if (nfh~=4)
    display('- Failed: blendingExample2 should display exactly 4 figures!'); 
    uiwait(msgbox('Failed: blendingExample2 should display exactly 4 figures'));    
    return;
  end    
catch
  display('- Failed (caught an exception, looks like runtime error).');
  return;
end
display('- Passed.');
close all;

close all;
display(' ');
display('- Pre-submission script done.');
display(' ');

display('Please go over the output and verify that there are no failures/warnings.');
display('Remember that this script tested only some basic technical aspects of your implementation');
display('It is your responsibility to make sure your results are actually correct and not only')
display('technically valid.');