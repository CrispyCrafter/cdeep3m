function augment_package(raw_images, outsubdir,fmnumber,speed)
%
% Updates: 
% removed memory limiting steps
% All vectorized
% Optimized for reducing time of processing
%
%
%------------------------------------------------
%% augment_package for CDeep3M -- NCMIR/NBCR, UCSD
%------------------------------------------------

%% Define augmentation variations here
allowed_speed = [1,2,4,10];
if ~ismember(speed,allowed_speed)
[~,I] = min(abs(allowed_speed-speed));
speed = allowed_speed(I)
end

if speed == 10
        switch(fmnumber)
            case 1
            do_var = [1];
            case 3
            do_var = [11];
            case 5
            do_var = [4];
         endswitch
         
elseif speed == 2 
        switch(fmnumber)
            case 1
            do_var = [1, 6, 11, 15];
            case 3
            do_var = [1:4, 13:16];
            case 5
            do_var = [5:12];
         endswitch
         
elseif speed == 1 
        switch(fmnumber)
            case 1
            do_var = [1:8];
            case 3
            do_var = [1:16];
            case 5
            do_var = [1:16];
         endswitch
         
elseif speed == 4 
        switch(fmnumber)
            case 1
            do_var = [1:8];
            case 3
            do_var = [];
            case 5
            do_var = [1, 6, 11, 15];
         endswitch
end
    



idx=0;
%% V1-8:
create8Variation(raw_images,idx,outsubdir);

%% V9-16: sweep Z dimension
disp('Sweep Z dimension')
raw_images = flip(raw_images,3);

idx=8;
create8Variation(raw_images,idx,outsubdir);
end

function [D]=create8Variation(original,idx,outsubdir)  % without any label, just data
for j = 1:8
    variation=j+idx;
    fprintf('Create Hd5 file Variation %s\n',num2str(variation));     
        switch(j)
            case 1
                stack = original;
            case 2
                stack = flipdim(original,1);
                
            case 3
                stack = flipdim(original,2);
                
            case 4
                stack = rot90(original);
                
            case 5
                stack = rot90(original, -1);
                
            case 6
                stack = rot90(flipdim(original, 1));
                
            case 7
                stack = rot90(flipdim(original,2));
                
            case 8
                stack = rot90(original, 2);                
        end 
        
        stack=permute(stack,[3 1 2]); %from tiff to h5 /xyz to z*x*y
        d_details = '/data';
        filename = fullfile(outsubdir, sprintf('test_data_full_stacks_v%s.h5', num2str(variation)));
        %fprintf('Saving: %s\n',filename)
        %h5create(filename,d_details,size(i_stack)); %nescessary for Matlab not for Octave
        h5write(filename,d_details,stack);
        clear -v stack
    
end
end
