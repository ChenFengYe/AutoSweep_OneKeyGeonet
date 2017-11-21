ims_test = 'RCNN_7_11_test/';
ims_result = 'result/';
% ims_test = 'ValTest/';
% ims_result = 'ValResult/';

imsFolder = ['/home/icl/chenxin/onekeyGeonet/' ims_test 'img/*.jpg'];
ims_path = [ims_test 'img/'];
imsName_all = GetTestImsName(imsFolder);

FICS_commond = 'python ./fcis/demo.py --cfg resnet_v1_101_ObjectSnap_synthetic_pretrain_end2end_ohem_lr_0002.yaml';   % resnet_v1_101_ObjectSnap_fcis_end2end_ohem.yaml
SubGeonet_commond = 'python ./geonet/demo.py --cfg objectsnap_ob_resnet_101_geonet_maskrcnn.yaml';   % objectsnap_line_mask_resnet_101_geonet.yaml
%% FCIS
%%%%%%%%%%%%%%%%%%%%
% 6class-> 5class:
% (1) lib/dataset/Obje_0002ctSnap.py:line 44~45 #class6->#classs5; line 194 Commond--6class, uncommond--5class
% (2) xx.yaml: num_class 6->5subTest
% (3) (training use) pascal_vo_eval.py:line 317 Commond--6class, uncommond--5class
%%%%%%%%%%%%%%%%%%%%
% Config list:  
% 6class_old:                resnet_v1_101_ObjectSnap_fcis_end2end_ohem.yaml
% 6class:                    resnet_v1_101_ObjectSnap_synthetic_pretrain_6classes_end2end_ohem.yaml
% 5class_ss_pretrain_lr0005: resnet_v1_101_ObjectSnap_synthetic_pretrain_end2end_ohem.yaml
% 5class_ss_pretrain_lr0002: resnet_v1_101_ObjectSnap_synthetic_pretrain_end2end_ohem_lr_0002.yaml
% 5class_baseline:           resnet_v1_101_ObjectSnap_end2end_baseline.yaml
% 5class_ss_data:            resnet_v1_101_ObjectSnap_synthetic_all_fcis_end2end_ohem.yaml
% 3class_XiaoCube:           resnet_v1_101_ObjectSnap_XiaoCube_ob_pretrain_end2end_ohem_lr_0002.yaml
%%%%%%%%%%%%%%%%%%%%

%% DCN 
%%%%%%%%%%%%%%%%%%%%
% 6class-> 5class:
% (1) lib/dataset/ObjectSnap_segmentation.py:line 38 #class6->#classs5
% no_dcn-> dcn:
% (1) geonet/symbols/net_ellipse_geonet.py:line 42 "_dcn"
%%%%%%%%%%%%%%%%%%%%
% Config list:
% 6class_old_noDCN:          objectsnap_line_mask_resnet_101_geonet.yaml
% 6class_old_DCN:            objectsnap_ob_resnet_101_geonet_6class.yaml
% 6class_DCN:                deleted
% 5class_ss_data_DCN:        objectsnap_synthetic_resnet_101_geonet.yaml
% 5class_ss_pretrain_DCN:    objectsnap_ob_resnet_101_geonet.yaml
% 5class_baseline_DCN:       objectsnap_ob_noss_resnet_101_geonet.yaml
% 5class_XiaoCube_DCN:       XiaoCube_resnet_101_geonet.yaml
% 5class_MaskRCNN:           objectsnap_ob_resnet_101_geonet_maskrcnn.yaml
%%%%%%%%%%%%%%%%%%%%

% DataFolder
FCIS_test = '../FCIS/demo/onekeyGeonet/test/';
FCIS_mask = '../FCIS/demo/onekeyGeonet/result/';

Sub_path_mask = ['./' ims_test 'mask/'];
Sub_path_line = ['./' ims_test 'line/'];
Sub_path_gray = ['./' ims_test 'gray/'];
Sub_path_subTest = ['./' ims_test 'subTest/'];
Sub_path_subTest_png = ['./' ims_test 'subTest_png/'];
Sub_path_subResult = ['./' ims_test 'subResult/'];

Sub_test = '../Sub_Geonet/demo/onekeyGeonet/test/';
Sub_result = '../Sub_Geonet/demo/onekeyGeonet/result/';

ErrorList = {};
set_num = 500;

%% Step 1: FCIS
% Init all
% InitData(FCIS_test, FCIS_mask, Sub_test, Sub_result, Sub_path_mask, Sub_path_subTest,Sub_path_subTest_png, Sub_path_subResult);
% CreatFolder(Sub_path_mask, Sub_path_subTest,Sub_path_subTest_png, Sub_path_subResult);
% for index = 1:ceil(length(imsName_all)/set_num)
%     imsName = imsName_all((index-1)*set_num+1:min(index*set_num,length(imsName_all)));
%     ClearFCISData(FCIS_test, FCIS_mask);
%     ims = {};
%     for i =1:length(imsName)
%         % visualization
%         % ims{i} = imread([ims_path, imsName{i}]);
%         copyfile([ims_path, imsName{i}], [FCIS_test, imsName{i}]);
%     end
%     cd('../FCIS')
%     system(FICS_commond);
%     for i =1:length(imsName)
%         if(exist([FCIS_mask, imsName{i}(1:end-4) '.png'], 'file'))
%             copyfile([FCIS_mask, imsName{i}(1:end-4) '.png'], ['../onekeyGeonet/' ims_test '/mask/', imsName{i}(1:end-4) '.png']);
%         else
%             ErrorList{length(ErrorList) + 1,1} = [FCIS_mask, imsName{i}(1:end-4) '.png'];
%         end
%         
%     end
%     cd('../onekeyGeonet');
% end
% 
% % %% Step 2: Separate
% GenerateSubGeonetData(Sub_path_mask, Sub_path_line, Sub_path_gray, Sub_path_subTest, Sub_path_subTest_png);

% Step 3: SubGeonet
ClearSubData(Sub_test, Sub_result);
imsName_sub_all = dir([Sub_path_subTest '*.jpg']);
for index_sub = 1:ceil(length(imsName_sub_all)/set_num)
    imsName_sub = imsName_sub_all((index_sub-1)*set_num+1:min(index_sub*set_num,length(imsName_sub_all)));
    for i = 1:length(imsName_sub)
        copyfile([Sub_path_subTest, imsName_sub(i).name], [Sub_test, imsName_sub(i).name]);
    end
    cd('../Sub_Geonet')
    system(SubGeonet_commond);
    for i =1:length(imsName_sub)
        if(exist([Sub_result, imsName_sub(i).name(1:end-4) '_seg.png'], 'file'))
            copyfile([Sub_result, imsName_sub(i).name(1:end-4) '_seg.png'], ['../onekeyGeonet/' Sub_path_subResult, imsName_sub(i).name(1:end-4) '_seg.png']);
        else
            ErrorList{length(ErrorList) + 1,1} = [Sub_result, imsName_sub(i).name(1:end-4) '_seg.png'];
        end
    end
    cd('../onekeyGeonet');
    ClearSubData(Sub_test, Sub_result);
end

%% Step 4: Fusion
% MergeInstance(Sub_path_subResult, ims_result);

ErrorList



function CreatFolder(Sub_path_mask, Sub_path_subTest, Sub_path_subTest_png, Sub_path_subResult)
mkdir(Sub_path_mask);
mkdir(Sub_path_subTest);
mkdir(Sub_path_subTest_png);
mkdir(Sub_path_subResult);
end


%%
function  InitData(FCIS_test, FCIS_mask, Sub_test, Sub_result, Sub_path_mask, Sub_path_subTest, Sub_path_subTest_png, Sub_path_subResult)
system(['rm ' FCIS_test '*.jpg']);
system(['rm ' FCIS_mask '*.png']);

system(['rm ' Sub_test '*.jpg']);
system(['rm ' Sub_result '*.png']);

mkdir(Sub_path_mask);
mkdir(Sub_path_subTest);
mkdir(Sub_path_subTest_png);
mkdir(Sub_path_subResult);

system(['rm ' Sub_path_mask '*.png']);
system(['rm ' Sub_path_subTest '*.jpg']);
system(['rm ' Sub_path_subTest_png '*.jpg']);
system(['rm ' Sub_path_subResult '*.png']);
end

function ClearFCISData(FCIS_test, FCIS_result)
system(['rm ' FCIS_test '*.jpg']);
system(['rm ' FCIS_result '*.png']);
end


function ClearSubData(Sub_test, Sub_result)
system(['rm ' Sub_test '*.jpg']);
system(['rm ' Sub_result '*.png']);
end

function imsName = GetTestImsName(path)
imageDir = dir(path);
imsName = {};
for i = 1:length(imageDir)
    imsName{i} = imageDir(i).name;
end
end