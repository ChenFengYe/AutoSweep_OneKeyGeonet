function MergeInstance(mask_path, result_path)

%mask_path = '/home/icl/chenxin/onekeyGeonet/test/liyuwei';
%result_path = '/home/icl/chenxin/onekeyGeonet/test/liyuwei';
masklist = dir(mask_path);

%% change color
for i = 3:length(masklist)
    i;
    name = masklist(i).name;
    name = name(1:strfind(name,'.png')-1);
    currimg = fullfile(mask_path, masklist(i).name);
    img = imread(currimg);
    marker = strfind(name,'_');
    cr = str2num(name(marker(end-3)+1:marker(end-2)-1));
    cg = str2num(name(marker(end-2)+1:marker(end-1)-1));
    cb = str2num(name(marker(end-1)+1:marker(end)-1));
    l = classify(cr,cg,cb);
    masklist(i).label = l;
    for r = 1:size(img,1)
        for w = 1:size(img,2)
            if img(r,w,1) ~= 0 || img(r,w,2)~=0 || img(r,w,3)~=0
                img(r,w,1) = cr;
                img(r,w,2) = cg;
                img(r,w,3) = cb;
            end
        end
    end
    imwrite(img,currimg);
end

%% get original name
for i = 3:length(masklist)
    masklist(i).visited = 0;
    name = masklist(i).name;
    marker = strfind(name,'_');
    masklist(i).oriname = name(1:marker(end-3)-1);
end

%% get merged mask all white for filling gap
for i = 3:length(masklist)
    if(masklist(i).visited ~= 1)
        imgPath = fullfile(mask_path, masklist(i).name);
        img = imread(imgPath);
        
        % find all with same oriname
        for j = 3:length(masklist)
            if(masklist(j).visited~=1 && i~=j)
                if(~strcmp(masklist(j).label,'handle'))
                    if(strcmp(masklist(i).oriname,masklist(j).oriname))
                        masklist(j).visited = 1;
                        imgPath2 = fullfile(mask_path, masklist(j).name);
                        img2 = imread(imgPath2);
                        for r = 1:size(img2,1)
                            for w = 1:size(img2,2)
                                if img2(r,w,1) ~= 0 || img2(r,w,2)~=0 || img2(r,w,3)~=0
                                    img(r,w,:) = img2(r,w,:);
                                end
                            end
                        end
                    end
                end
            end
        end
        
        
        % fill gap
        new_body = fillgap(img);
        new_body_3 = zeros(size(img));
        new_body_3 = uint8(new_body_3);
        new_body_3(:,:,1) = new_body;
        new_body_3(:,:,2) = new_body;
        new_body_3(:,:,3) = new_body;
        
        % combine with img
        for r = 1:size(new_body,1)
            for w = 1:size(new_body,2)
                if img(r,w,1) ~= 0 || img(r,w,2)~=0 || img(r,w,3)~=0
                    new_body_3(r,w,1) = img(r,w,1);
                    new_body_3(r,w,2) = img(r,w,2);
                    new_body_3(r,w,3) = img(r,w,3);
                end
            end
        end
        img = new_body_3;
        
        % add handles
        for j = 3:length(masklist)
            if(masklist(j).visited~=1 && i~=j)
                if(strcmp(masklist(j).label,'handle'))
                    if(strcmp(masklist(i).oriname,masklist(j).oriname))
                        masklist(j).visited = 1;
                        imgPath2 = fullfile(mask_path, masklist(j).name);
                        img2 = imread(imgPath2);
                        for r = 1:size(img2,1)
                            for w = 1:size(img2,2)
                                if img2(r,w,1) ~= 0 || img2(r,w,2)~=0 || img2(r,w,3)~=0
                                    img(r,w,:) = img2(r,w,:);
                                end
                            end
                        end
                    end
                end
            end
        end
        %imwrite(img,[result_path masklist(i).oriname '_mask1.png']);
        
        % vectorize
        for r = 1:size(img,1)
            for w = 1:size(img,2)
                if img(r,w,1) == 255 && img(r,w,2)==255 && img(r,w,3)==255
                    [nr ng nb] = ChangeColor(img,r,w);
                    img(r,w,1) = nr;
                    img(r,w,2) = ng;
                    img(r,w,3) = nb;
                end
            end
        end
        ['save in: ' result_path masklist(i).oriname '_mask.png']
        imwrite(img,[result_path masklist(i).oriname '_mask.png']);
        masklist(i).visited = 1;
    end
end
end


%%
function l = classify(r,g,b)
l = '';
switch (b)
    case 255
        if (g == 0 && mod(r,10) == 0 && r ~= 0)
            l= 'cubebody';
        elseif (mod(r,10) == 0 && g == r && r ~= 0)
            l= 'cubeface';
        end
    case 200
        if (g == 0 && mod(r,10) == 0 && r ~= 0)
            l= 'cylinderbody';
        elseif (mod(r,10) == 0 && g == r && r ~= 0)
            l= 'cylinderface';
        end
    case 150
        if (g == 0 && mod(r,10) == 0 && r ~= 0)
            l= 'handle';
        end
end
end
%%
function x = ValidColor(r,g,b)
x = false;
if(b==255 || b==200)
    if(g==0 && mod(r,10)==0 && r ~= 0)
        x = true;
    else
        if(g==r && mod(r,10)==0 && r~=0)
            x = true;
        end
    end
else
    if(b==150)
        if(g==0 && mod(r,10)==0 && r~=0)
            x = true;
        end
    else
        if(b==0 && r ==0 && g == 0)
            x = true;
        end
    end
end
end
%%
function img = fillgap(ori_img)
[w,h, ~] = size(ori_img);
img = rgb2gray(ori_img);
img(img~=0)=255;
doubleimg = im2double(img);
padding = 40;
b=zeros(w+padding*2,h+padding*2);
b(padding+1:w+padding,padding+1:h+padding)=doubleimg;
se = strel('disk',10);
b = imclose(b,se);
img = b(padding+1:w+padding,padding+1:h+padding);
img(img~=0)=255;
img = uint8(img);
end
%% interpolation
function [nr ng nb] = ChangeColor(img,i,j)
% 1����
for ii = 1:10
    try
        c = img(i-ii,j,:);
        r = c(:,:,1);
        g = c(:,:,2);
        b = c(:,:,3);
        if(ValidColor(r,g,b))
            nr = r;ng = g;nb = b;
            return;
        end
    end
    
    try
        c = img(i+ii,j,:);
        r = c(:,:,1);
        g = c(:,:,2);
        b = c(:,:,3);
        if(ValidColor(r,g,b))
            nr = r;ng = g;nb = b;
            return;
        end
    end
    
    try
        c = img(i,j-ii,:);
        r = c(:,:,1);
        g = c(:,:,2);
        b = c(:,:,3);
        if(ValidColor(r,g,b))
            nr = r;ng = g;nb = b;
            return;
        end
    end
    
    try
        c = img(i,j+ii,:);
        r = c(:,:,1);
        g = c(:,:,2);
        b = c(:,:,3);
        if(ValidColor(r,g,b))
            nr = r;ng = g;nb = b;
            return;
        end
    end
    
    try
        c = img(i-ii,j-ii,:);
        r = c(:,:,1);
        g = c(:,:,2);
        b = c(:,:,3);
        if(ValidColor(r,g,b))
            nr = r;ng = g;nb = b;
            return;
        end
    end
    
    try
        c = img(i-ii,j+ii,:);
        r = c(:,:,1);
        g = c(:,:,2);
        b = c(:,:,3);
        if(ValidColor(r,g,b))
            nr = r;ng = g;nb = b;
            return;
        end
    end
    
    try
        c = img(i+ii,j-ii,:);
        r = c(:,:,1);
        g = c(:,:,2);
        b = c(:,:,3);
        if(ValidColor(r,g,b))
            nr = r;ng = g;nb = b;
            return;
        end
    end
    
    try
        c = img(i+ii,j+ii,:);
        r = c(:,:,1);
        g = c(:,:,2);
        b = c(:,:,3);
        if(ValidColor(r,g,b))
            nr = r;ng = g;nb = b;
            return;
        end
    end
end
end