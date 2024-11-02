;---plot ADD for regridded ERA-5& CESM2 CAM6  distribution figure
begin

;------- read in CESM2(CAM6)------------------------------------------------------------------------------------------
 ; lat 25*lon 46*lead 46*season 4
 accID1        = addfile("/glade/work/kumar34/SubXSP24/ncc_rev0/Corre_cesm2cam6v2_sm_prcp_lag_corre_0_45_leaddays_4_seasons_normalized.nc","r")
 ;accID1        = addfile("/glade/work/maruf/yanan_script/script_testing/Corre_cesm2cam6v2_sm_prcp_lag_corre_0_45_leaddays_4_seasons_normalized.nc","r")
 corre_sn_lag0  = accID1->corre_sn
 corre_sn_sig0  = accID1->corre_sn_sig
 corre_sn_sig0  = where(corre_sn_sig0.le.0.05,1,0)
 
 ;SMID          = addfile("/glade/work/yanand/USDA_FACT/Corre_Fig_H2OSOI/CAM6_ERA5_SM_0_5m_0_lead_1999_2021_organize.nc","r") 
 SMID          = addfile("/glade/work/maruf/yanan_script/script_testing/CAM6_ERA5_SM_2_89m_0_lead_1999_2021_organize.nc","r")  
 lon0          = SMID->lon
 lat0          = SMID->lat

 wgt = latRegWgt(lat0, "float", 0)

 corre_sn_lag0&lat = lat0
 corre_sn_lag0&lon = lon0

 corre_sn_lag0&lat@units="degrees_north"
 corre_sn_lag0&lon@units="degrees_east"

 corre_sn_sig0&lat = lat0
 corre_sn_sig0&lon = lon0

 corre_sn_sig0&lat@units="degrees_north"
 corre_sn_sig0&lon@units="degrees_east"

 ;corre_sn_lag0 = mask(corre_sn_lag0, (corre_sn_lag0.gt.0), True)
 ;corre_sn_sig0 = mask(corre_sn_sig0, (corre_sn_lag0.gt.0), True)

;------ read in IPSL variable -------------------------------------------------------------------------------------------
  ; lat 25*lon 59*lead 32*season 4
 accID1        = addfile("/glade/work/yanand/USDA_FACT/SubX_S2S/Corre_SubX_ESRL_FIMr1p1_sm_prcp_lag_corre_1_32_leaddays_4_seasons_normalized.nc","r")
 corre_sn_lag1  = accID1->corre_sn
 corre_sn_sig1  = accID1->corre_sn_sig
 corre_sn_sig1  = where(corre_sn_sig1.le.0.05,1,0)

 SMID          = addfile("/glade/work/yanand/USDA_FACT/SubX_S2S/SubX_ESRL_FIMr1p1/SubX_ESRL_FIMr1p1_forecast_CONUS_20170802_20220525.nc","r")
 lon1          = SMID->X
 lat1          = SMID->Y

 corre_sn_lag1&lat = lat1
 corre_sn_lag1&lon = lon1(::-1)

 corre_sn_lag1&lat@units="degrees_north"
 corre_sn_lag1&lon@units="degrees_east"

 corre_sn_sig1&lat = lat1
 corre_sn_sig1&lon = lon1(::-1)

 corre_sn_sig1&lat@units="degrees_north"
 corre_sn_sig1&lon@units="degrees_east"
 
; corre_sn_lag1 = mask(corre_sn_lag1, (corre_sn_lag1.gt.0), True)
; corre_sn_sig1 = mask(corre_sn_sig1, (corre_sn_lag1.gt.0), True)


 ;---------------------------------------------------------------
 
 neon_file = "/glade/work/yanand/USDA_FACT/Corre_Fig_H2OSOI/NEON_site_shapefile/NEON16_final1_gcs.shp"


 fm = addfile("/glade/u/home/kumar34/neon21/neon17_mask_CLM1deg.nc", "r")

 neon_mask = fm->neon_mask(:, {25.91:48.54}, {236.25:292.5})

 printVarSummary(neon_mask)


;**************PLOT GRID GRAPH*******************************************************************
wks_type = "png"
wks_type@wkWidth = 3000
wks_type@wkHeight = 3000 
wks  = gsn_open_wks(wks_type, "Fi6_spatial_npj_rev1_plot")
;wks  = gsn_open_wks("x11","Corre_CAM6_ESRL_0_45_lead_2_kinds_NEON_region_normalized_1st_2nd_3rd_week_MAM_JJA")              ; send graphics to PNG file
 res                           = True              
 res@mpMinLatF                 = 24                ; zoom in on map
 res@mpMaxLatF                 = 50
 res@mpMinLonF                 = -125.5
 res@mpMaxLonF                 = -65.5

 res@mpOutlineBoundarySets     = "Geophysical"; turn on states
 res@mpUSStateLineColor        = "black"
 res@mpDataBaseVersion         = "MediumRes"             ; select database
 res@mpDataSetName             = "Earth..2"
 res@mpFillBoundarySets        = "USStates"
 res@mpOutlineOn               = True
 
 res@mpFillAreaSpecifiers  = (/"United States", "Mexico"/)
 ;res@mpMaskAreaSpecifiers  =  (/"Mexico"/)
 res@mpSpecifiedFillColors = (/"transparent","white"/)

 res@gsnDraw                   = False                  ; don't draw
 res@gsnFrame                  = False                  ; don't advance frame
 res@gsnAddCyclic              = False

 res@pmTickMarkDisplayMode = "Always" ;Add map lon lat mark

 res@cnFillOn = True
 res@cnLinesOn = False
 ;res@cnFillMode = "RasterFill"
 res@cnLineLabelsOn = False
 res@cnFillDrawOrder = "Predraw"
 res@cnLineDrawOrder = "Predraw"

 res@cnLevelSelectionMode = "ManualLevels"
 res@cnMinLevelValF = -0.45
 res@cnMaxLevelValF = 0.45
 res@cnLevelSpacingF = 0.05
 res@gsnSpreadColors = True

; res@cnLevelSelectionMode = "ExplicitLevels"
; res@cnLevels = (/0,0.025,0.05,0.075,0.1,0.15,0.2,0.3,0.4/)
; res@cnFillPalette = "CBR_wet"
; res@vcLevelPalette = "CBR_wet"

 ;--------------------------
 res@tmYROn = False
 res@tmYLOn = False
 res@tmXTOn = False
 res@tmXBOn = False
 ;--------------------------
 
 res@lbLabelBarOn = False
 resH = res
 resV = res
 resHV = res
 
 HoriTitle = (/"CESM2", "ESRL-FIM"/)
 ;VertTitle = (/"Lead 1-15 days", "Lead 8-22 days", "Lead 15-29 days"/)
 VertTitle = (/"MAM", "JJA", "SON", "DJF"/)


 plots = new((/4,2/), graphic)
 ;gsn_define_colormap(wks,"perc2_9lev")
  gsn_define_colormap(wks, "temp_19lev")

 seai = 0 
 resHV@tiMainOffsetYF = -0.01
 resHV@tiMainFontHeightF = 0.03
 resHV@tiMainString = HoriTitle(0)
 
 resHV@tiYAxisOn = True
 resHV@tiYAxisString = VertTitle(0)
 resHV@tiYAxisOffsetYF = 0
 resHV@tiYAxisOffsetXF = 0.01
 resHV@tiYAxisFontHeightF = 0.03
 acc_us = new((/4, 2/), "float", -99.0)



  
 plots(seai,0) = gsn_csm_contour_map(wks, corre_sn_lag0(:,:,21,0), resHV)
 acc_us(0, 0) =  wgt_areaave(corre_sn_lag0(:,:,21,0), wgt, 1.0, 0)  


 resH@tiMainOffsetYF = -0.01
 resH@tiMainFontHeightF = 0.03
 resH@tiMainString = HoriTitle(1)
 plots(seai,1) = gsn_csm_contour_map(wks, corre_sn_lag1(:,:,20,0), resH)
 acc_us(0, 1) =  wgt_areaave(corre_sn_lag1(:,:,20,0), wgt, 1.0, 0)
 



 resV@tiYAxisOn = True
 resV@tiYAxisString = VertTitle(1)
 resV@tiYAxisOffsetYF = 0
 resV@tiYAxisOffsetXF = 0.01
 resV@tiYAxisFontHeightF = 0.03
 plots(1,0) = gsn_csm_contour_map(wks, corre_sn_lag0(:,:,21,1), resV)
 acc_us(1, 0) = wgt_areaave(corre_sn_lag0(:,:,21,1), wgt, 1.0, 0) 



 resV@tiYAxisString = VertTitle(2)
 plots(2,0) = gsn_csm_contour_map(wks, corre_sn_lag0(:,:,21,2), resV)
  acc_us(2, 0) = wgt_areaave(corre_sn_lag0(:,:,21,2), wgt, 1.0, 0) 



 plots(1,1) = gsn_csm_contour_map(wks, corre_sn_lag1(:,:,20,1), res)
 acc_us(1, 1) = wgt_areaave(corre_sn_lag1(:,:,20,1), wgt, 1.0, 0)

 plots(2,1) = gsn_csm_contour_map(wks, corre_sn_lag1(:,:,20,2), res)
 acc_us(2, 1) = wgt_areaave(corre_sn_lag1(:,:,20,2), wgt, 1.0, 0) 



 resV@tiYAxisString = VertTitle(3)

 plots(3,0) = gsn_csm_contour_map(wks, corre_sn_lag0(:,:,21,3), resV)
 plots(3,1) = gsn_csm_contour_map(wks, corre_sn_lag1(:,:,20,3), res)

 acc_us(3, 0) = wgt_areaave(corre_sn_lag0(:,:,21,3), wgt, 1.0, 0)
 acc_us(3, 1) = wgt_areaave(corre_sn_lag1(:,:,20,3), wgt, 1.0, 0)

 P2 = new((/17, 8/), "float", -9999.0)
 
 printVarSummary(neon_mask(0, :, :))
 printVarSummary(corre_sn_lag1(:,:,20, 0))
 



 do i = 0, 16
    do j = 0, 3
       temp1 = corre_sn_lag0(:,:,21, j)
       temp1 = mask(temp1, neon_mask(i, :, :).eq.1., True)
       P2(i, j*2) = wgt_areaave(temp1, wgt, 1.0, 0)
      
       temp2 := corre_sn_lag1(:,:,20, j)
       ;temp1 = mask(temp1, neon_mask(i, :, :).eq.1., True)
       ;P2(i, j*2+1) = wgt_areaave(temp1, wgt, 1.0, 0)

    end do
 end do


;exit

 opt1 = True
 opt1@fout = "NEON17row_CESM2_ESRL_FIM_MAM_JJA_SON_DJF_8cls.txt"
 fmtx = "8f15.8"
 write_matrix(P2, fmtx, opt1)







   ;/
     ;res@lbOrientation = "Vertical"
     res@lbLabelBarOn = True
     res@lbBoxLinesOn = False            ; Turn off labelbar box lines
     res@lbLabelAutoStride = True        ; Control labelbar labels.
     res@pmLabelBarWidthF  = 1.3
     res@lbLabelFontHeightF = 0.024
     res@pmLabelBarHeightF  = 0.12
     res@lbBottomMarginF = -0.2
	;/ 

  ;----------- plot significant area -------------------
 res2 = True
 res2@gsnDraw            = False             ; don't draw yet
 res2@gsnFrame           = False             ; don't advance fra

 res2@gsnAddCyclic = False
 res2@gsnMaximize = True

 res2@cnInfoLabelOn       = False       ; turn off info label
 res2@cnLinesOn           = False       ; do not draw contour lines
 res2@cnLineLabelsOn      = False       ; do not draw contour labels
 res2@cnConstFEnableFill = True         ; Fill even scalar field is constant
 res2@cnFillScaleF        = 0.6         ; add extra density
 res2@cnFillDotSizeF = 0.0018

 res2@cnFillDrawOrder = "Predraw"
 res2@cnLineDrawOrder = "Predraw"

 res2@cnLevelSelectionMode = "ManualLevels"
 res2@cnMinLevelValF  =  0.8
 res2@cnMaxLevelValF  =  1.2
 res2@cnLevelSpacingF =  0.1

 opt = True
 opt@gsnShadeFillType = "pattern"       ; pattern fill
 opt@gsnShadeHigh = 17                  ; use pattern #2
 ;opt@gsnShadeLow  = 17
 res2@cnConstFEnableFill = True        ; Fill even scalar field is constant
 
 ;-------------------------------------------------------
 plots2 = new((/4,2/), graphic)
 seai = 0

 ;do seai = 0, 2
   plots2(seai,0) = gsn_csm_contour(wks, corre_sn_sig0(:,:,21,0), res2)
   plots2(seai,1) = gsn_csm_contour(wks, corre_sn_sig1(:,:,20,0), res2)

   plots2(seai,0) = gsn_contour_shade(plots2(seai,0), -0.2, 0.8, opt)
   plots2(seai,1) = gsn_contour_shade(plots2(seai,1), -0.2, 0.8, opt)

   overlay(plots(seai,0), plots2(seai,0))
   overlay(plots(seai,1), plots2(seai,1))
 ;end do



  seai = 1

 ;do seai = 0, 2
   plots2(seai,0) = gsn_csm_contour(wks, corre_sn_sig0(:,:,21,1), res2)
   plots2(seai,1) = gsn_csm_contour(wks, corre_sn_sig1(:,:,20,1), res2)

   plots2(seai,0) = gsn_contour_shade(plots2(seai,0), -0.2, 0.8, opt)
   plots2(seai,1) = gsn_contour_shade(plots2(seai,1), -0.2, 0.8, opt)

   overlay(plots(seai,0), plots2(seai,0))
   overlay(plots(seai,1), plots2(seai,1))
 ;end do

  seai = 2

 ;do seai = 0, 2
   plots2(seai,0) = gsn_csm_contour(wks, corre_sn_sig0(:,:,21,2), res2)
   plots2(seai,1) = gsn_csm_contour(wks, corre_sn_sig1(:,:,20,2), res2)

   plots2(seai,0) = gsn_contour_shade(plots2(seai,0), -0.2, 0.8, opt)
   plots2(seai,1) = gsn_contour_shade(plots2(seai,1), -0.2, 0.8, opt)

   overlay(plots(seai,0), plots2(seai,0))
   overlay(plots(seai,1), plots2(seai,1))
 ;end do


   seai = 3

 ;do seai = 0, 2
   plots2(seai,0) = gsn_csm_contour(wks, corre_sn_sig0(:,:,21,3), res2)
   plots2(seai,1) = gsn_csm_contour(wks, corre_sn_sig1(:,:,20,3), res2)

   plots2(seai,0) = gsn_contour_shade(plots2(seai,0), -0.2, 0.8, opt)
   plots2(seai,1) = gsn_contour_shade(plots2(seai,1), -0.2, 0.8, opt)

   overlay(plots(seai,0), plots2(seai,0))
   overlay(plots(seai,1), plots2(seai,1))
 ;end do



 plot1d = ndtooned(plots) 

 ;------------------define mpres-------------------------------
 pres              = True
 pres@gsLineThicknessF = 1.5
 pres@gsLineColor = "black"
 poly = new(8, "graphic")
 
 do i = 0, 7
   poly(i) = gsn_add_shapefile_polylines(wks,plot1d(i),neon_file,pres)
 end do
 
 ;---Panel Plotting---
 resP = True
 ;resP@gsnPanelLabelBar = True                ; add common colorbar
 resP@gsnMaximize = True
 resP@pmLabelBarWidthF  = 0.6
 resP@gsnPanelFigureStringsFontHeightF = 0.02
 ;resP@gsnPanelFigureStrings= (/"Lead 1-15 days", "Lead 16-30 days", "Lead 31-45 days"/) ; add strings to panel
 resP@tiMainString        = (/"CESM2(CAM6)"/)
 


 acc_us1d = ndtooned(acc_us)

  acc_us_num = new(8, "string")

 pan_num = (/"[b]", "[c]", "[d]", "[e]", "[f]", "[g]", "[h]", "[i]"/)


 do i = 0, 7

    acc_us_num(i) = pan_num(i)+" "+sprintf("%2.2f", acc_us1d(i))

 end do


 ;pan_num = (/"[b]", "[c]", "[d]", "[e]", "[f]", "[g]", "[h]", "[i]", "[j]", "[k]", "[l]", "[m]"/)





 resP = True
 ;resP@gsnPanelFigureStringsPerimOn = False
 ;resP@amJust = "BottomRight"
 ;resP@amParallelPosF=0.15
 ;resP@amOrthogonalPosF=-0.5
 ;resP@gsnPanelFigureStringsBackgroundFillColor = -1
 ;resP@lbLabelFontHeightF  = 0.02               ; make labels smaller
 ;resP@gsnPanelYWhiteSpacePercent = 5
 
 ;resP@lbLabelBarOn       = True
 ;resP@lbBoxLinesOn       = False
 ;resP@lbLabelFontHeightF = 0.01               ; make labels smaller
 ;resP@pmLabelBarWidthF   = 0.6
 ;resP@lbBottomMarginF    = -0.15
 ;resP@pmLabelBarHeightF = 0.08
 ;resP@gsnPanelLabelBar   = True
 
 resP = True
 resP@gsnPanelLabelBar = True                ; add common colorbar
 resP@gsnMaximize = True
 resP@pmLabelBarWidthF  = 0.9
 resP@gsnPanelFigureStringsFontHeightF = 0.013
 ;resP@gsnPanelFigureStrings= (/"Lead 1-15 days", "Lead 16-30 days", "Lead 31-45 days"/) ; add strings to panel

 resP@gsnPanelFigureStrings = acc_us_num
 ;;resP@tiMainString        = (/"CESM2(CAM6)"/)

 resP@gsnPanelFigureStringsPerimOn = False
 resP@amJust = "BottomLeft"
 ;resP@amParallelPosF=0.15
 ;resP@amOrthogonalPosF=-0.5
 ;;resP@gsnPanelFigureStringsBackgroundFillColor = "white"
 resP@lbLabelFontHeightF  = 0.02               ; make labels smaller
 ;resP@gsnPanelYWhiteSpacePercent = 5
 gsn_panel(wks,plot1d(0:3) ,(/2,2/),resP)







 ;gsn_panel(wks,plot1d ,(/4,2/),resP)
end
  
  
  
  
