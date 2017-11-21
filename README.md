# AutoSweep-OneKeyGeonet
This is a script for auto-test Geonet

### FCIS
***6class-> 5class:***
1. lib/dataset/Obje_0002ctSnap.py:line 44~45 #class6->#classs5; line 194 Commond--6class, uncommond--5class
2. xx.yaml: num_class 6->5subTest
3. (training use) pascal_vo_eval.py:line 317 Commond--6class, uncommond--5class

***Config list:*** 
  * 6class_old:                resnet_v1_101_ObjectSnap_fcis_end2end_ohem.yaml
  * 6class:                    resnet_v1_101_ObjectSnap_synthetic_pretrain_6classes_end2end_ohem.yaml
  * 5class_ss_pretrain_lr0005: resnet_v1_101_ObjectSnap_synthetic_pretrain_end2end_ohem.yaml
  * 5class_ss_pretrain_lr0002: resnet_v1_101_ObjectSnap_synthetic_pretrain_end2end_ohem_lr_0002.yaml
  * 5class_baseline:           resnet_v1_101_ObjectSnap_end2end_baseline.yaml
  * 5class_ss_data:            resnet_v1_101_ObjectSnap_synthetic_all_fcis_end2end_ohem.yaml
  * 3class_XiaoCube:           resnet_v1_101_ObjectSnap_XiaoCube_ob_pretrain_end2end_ohem_lr_0002.yaml

### DCN 
***6class-> 5class:***
1. lib/dataset/ObjectSnap_segmentation.py:line 38 #class6->#classs5
2. no_dcn-> dcn:
3. geonet/symbols/net_ellipse_geonet.py:line 42 "_dcn"

***Config list:***
  * 6class_old_noDCN:          objectsnap_line_mask_resnet_101_geonet.yaml
  * 6class_old_DCN:            objectsnap_ob_resnet_101_geonet_6class.yaml
  * 6class_DCN:                deleted
  * 5class_ss_data_DCN:        objectsnap_synthetic_resnet_101_geonet.yaml
  * 5class_ss_pretrain_DCN:    objectsnap_ob_resnet_101_geonet.yaml
  * 5class_baseline_DCN:       objectsnap_ob_noss_resnet_101_geonet.yaml
  * 5class_XiaoCube_DCN:       XiaoCube_resnet_101_geonet.yaml
  * 5class_MaskRCNN:           objectsnap_ob_resnet_101_geonet_maskrcnn.yaml
