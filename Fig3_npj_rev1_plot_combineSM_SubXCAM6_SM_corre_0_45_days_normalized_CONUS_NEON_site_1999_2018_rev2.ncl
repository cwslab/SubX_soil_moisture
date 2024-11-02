;---plot ADD for regridded ERA-5& CESM2 CAM6  distribution figure
begin
 ;--- lat 77* lon 81 * lead 46
 accID1    = addfile("/glade/work/yanand/USDA_FACT/combine_sm_obs/Corre_combineSM_CAM6_0_45_leaddays_normalized_1999_2018.nc","r")
 accID2    = addfile("/glade/work/yanand/USDA_FACT/combine_sm_obs/Corre_combineSM_CAM6climOCN_0_45_leaddays_normalized_1999_2018.nc","r")
 ;accID3    = addfile("/glade/work/yanand/USDA_FACT/combine_sm_obs/Corre_combineSM_CAM6climoOCNclimoATMv2_0_45_leaddays_normalized_1999_2018.nc","r")
 accID3    = addfile("/glade/work/yanand/USDA_FACT/combine_sm_obs/Corre_combineSM_CAM6climATM_0_45_leaddays_normalized_1999_2018.nc", "r")
 accID4    = addfile("/glade/work/yanand/USDA_FACT/combine_sm_obs/Corre_combineSM_CAM6climLND_0_45_leaddays_normalized_1999_2018.nc", "r")
 


 corre_yr0 = accID1->corre_yr
 corre_yr  = new((/25,46,46,4/),"float",corre_yr0@_FillValue)

 corre_yr(:,:,:,0) = accID1->corre_yr
 corre_yr(:,:,:,1) = accID2->corre_yr
 corre_yr(:,:,:,2) = accID3->corre_yr
 corre_yr(:,:,:,3) = accID4->corre_yr

; corre_yr = mask(corre_yr, (corre_yr.gt.0), True)

 ;corre_yr  = (/corre_yr^2/)

 corre_yr_sig          = corre_yr
 corre_yr_sig(:,:,:,0) = accID1->corre_yr_sig
 corre_yr_sig(:,:,:,1) = accID2->corre_yr_sig
 corre_yr_sig(:,:,:,2) = accID3->corre_yr_sig
 corre_yr_sig(:,:,:,3) = accID4->corre_yr_sig

 corre_yr_sig_P = where(corre_yr_sig.lt.0.05,1,0)
 corre_yr_sig   = (/corre_yr_sig_P/) 

 corre_yr_sig = mask(corre_yr_sig, (corre_yr.gt.0), True)

 ;--- lat 77*lon 81
 lat = accID1->lat
 lon = accID1->lon


  wgt = latRegWgt(lat, "float", 0)

 neon_file = "/glade/work/yanand/USDA_FACT/Corre_Fig_H2OSOI/NEON_site_shapefile/NEON16_final1_gcs.shp"


;********** Adding the NEON mask file***********************************


fm = addfile("/glade/u/home/kumar34/neon21/neon17_mask_CLM1deg.nc", "r")

neon_mask = fm->neon_mask(:, {25.91:48.54}, {236.25:292.5})

printVarSummary(neon_mask)

;exit 

;**************PLOT GRID GRAPH*******************************************************************
wks_type = "png"
wks_type@wkWidth = 3000
wks_type@wkHeight = 3000 
wks  = gsn_open_wks(wks_type, "Fig3_npj_rev1_plot")
;wks  = gsn_open_wks("x11","Fig2_Corre_combineSM_cesm2cam6v2_0_45_lead_3_kinds_NEON_region_normalized_1st_2nd_3rd_week_rev2")              ; send graphics to PNG file
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
 res@cnMinLevelValF = -0.9
 res@cnMaxLevelValF = 0.9
 res@cnLevelSpacingF = 0.15
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
 
 HoriTitle = (/"ATM + OCN + LAND", "LAND + ATM", "LND + OCN", "ATM + OCN"/)
 VertTitle = (/"Lead 1-15 days", "Lead 16-30 days", "Lead 31-45 days"/)

 plots = new((/3,4/), graphic)
 gsn_define_colormap(wks,"GreenMagenta16")

 seai = 0 
 resHV@tiMainOffsetYF = -0.00
 resHV@tiMainFontHeightF = 0.03
 resHV@tiMainString = HoriTitle(0)
 
 resHV@tiYAxisOn = True
 resHV@tiYAxisString = VertTitle(0)
 resHV@tiYAxisOffsetYF = 0
 resHV@tiYAxisOffsetXF = 0.00
 resHV@tiYAxisFontHeightF = 0.03
  
 acc_us = new((/3, 4/), "float", -99.0)


 plots(seai,0) = gsn_csm_contour_map(wks, corre_yr(:,:,14*(seai+1)-7,0), resHV)

 acc_us(seai,0) = wgt_areaave(corre_yr(:,:,14*(seai+1)-7,0), wgt, 1.0, 0) 


 
 resH@tiMainOffsetYF = -0.00
 resH@tiMainFontHeightF = 0.03
 resH@tiMainString = HoriTitle(1)
 plots(seai,1) = gsn_csm_contour_map(wks, corre_yr(:,:,14*(seai+1)-7,1), resH)
 acc_us(seai,1) = wgt_areaave(corre_yr(:,:,14*(seai+1)-7,1), wgt, 1.0, 0) 



 resH@tiMainString = HoriTitle(2)  
 plots(seai,2) = gsn_csm_contour_map(wks, corre_yr(:,:,14*(seai+1)-7,2), resH)
 acc_us(seai,2) = wgt_areaave(corre_yr(:,:,14*(seai+1)-7,2), wgt, 1.0, 0)


 resH@tiMainString = HoriTitle(3)
 plots(seai,3) = gsn_csm_contour_map(wks, corre_yr(:,:,14*(seai+1)-7,3), resH)
 acc_us(seai,3) = wgt_areaave(corre_yr(:,:,14*(seai+1)-7,3), wgt, 1.0, 0)


 resV@tiYAxisOn = True
 resV@tiYAxisString = VertTitle(1)
 resV@tiYAxisOffsetYF = 0
 resV@tiYAxisOffsetXF = 0.00
 resV@tiYAxisFontHeightF = 0.03
 plots(1,0) = gsn_csm_contour_map(wks, corre_yr(:,:,14*(1+1)-7,0), resV)

 acc_us(1,0) = wgt_areaave(corre_yr(:,:,14*(1+1)-7,0), wgt, 1.0, 0) 


 resV@tiYAxisString = VertTitle(2)
 plots(2,0) = gsn_csm_contour_map(wks, corre_yr(:,:,14*(2+1)-7,0), resV)
 acc_us(2,0) = wgt_areaave(corre_yr(:,:,14*(2+1)-7,0), wgt, 1.0, 0)

 
 do seai = 1,2

   if (seai.eq.2) then
     ;res@lbOrientation = "Vertical"
     res@lbLabelBarOn = True
     res@lbBoxLinesOn = False            ; Turn off labelbar box lines
     res@lbLabelAutoStride = True        ; Control labelbar labels.
     res@pmLabelBarWidthF  = 3.0
     res@lbLabelFontHeightF = 0.035
     res@pmLabelBarHeightF  = 0.12
     res@lbBottomMarginF = -0.2
     res@pmLabelBarParallelPosF = 1.0 
   end if

   plots(seai,1) = gsn_csm_contour_map(wks, corre_yr(:,:,14*(seai+1)-7,1), res)
   acc_us(seai,1) = wgt_areaave(corre_yr(:,:,14*(seai+1)-7,1), wgt, 1.0, 0)

   res@lbLabelBarOn = False
   plots(seai,2) = gsn_csm_contour_map(wks, corre_yr(:,:,14*(seai+1)-7,2), res)
   acc_us(seai,2) = wgt_areaave(corre_yr(:,:,14*(seai+1)-7,2), wgt, 1.0, 0)

   plots(seai,3) = gsn_csm_contour_map(wks, corre_yr(:,:,14*(seai+1)-7,3), res)
   acc_us(seai,3) = wgt_areaave(corre_yr(:,:,14*(seai+1)-7,3), wgt, 1.0, 0)

 end do

 print(acc_us)

 ;exit



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
  ;res2@cnMinLevelValF  =  1.0
  ;res2@cnMaxLevelValF  =  0.0


 res2@cnLevelSpacingF =  0.1

 opt = True
 opt@gsnShadeFillType = "pattern"       ; pattern fill
 opt@gsnShadeHigh = 17                  ; use pattern #2
 ;opt@gsnShadeLow  = 17
 res2@cnConstFEnableFill = True        ; Fill even scalar field is constant
 
 ;-------------------------------------------------------
 plots2 = new((/3,4/), graphic)
 do seai = 0, 2
   plots2(seai,0) = gsn_csm_contour(wks, corre_yr_sig(:,:,(seai+1)*14-7,0), res2)
   plots2(seai,1) = gsn_csm_contour(wks, corre_yr_sig(:,:,(seai+1)*14-7,1), res2)
   plots2(seai,2) = gsn_csm_contour(wks, corre_yr_sig(:,:,(seai+1)*14-7,2), res2)
   plots2(seai,3) = gsn_csm_contour(wks, corre_yr_sig(:,:,(seai+1)*14-7,3), res2)

   plots2(seai,0) = gsn_contour_shade(plots2(seai,0), -0.2, 0.8, opt)
   plots2(seai,1) = gsn_contour_shade(plots2(seai,1), -0.2, 0.8, opt)
   plots2(seai,2) = gsn_contour_shade(plots2(seai,2), -0.2, 0.8, opt)
   plots2(seai,3) = gsn_contour_shade(plots2(seai,3), -0.2, 0.8, opt)

   overlay(plots(seai,0), plots2(seai,0))
   overlay(plots(seai,1), plots2(seai,1))
   overlay(plots(seai,2), plots2(seai,2))
   overlay(plots(seai,3), plots2(seai,3))

 end do

 plot1d = ndtooned(plots) 

 acc_us1d = ndtooned(acc_us)

 acc_us_num = new(12, "string")

 pan_num = (/"[a]", "[b]", "[c]", "[d]", "[e]", "[f]", "[g]", "[h]", "[i]", "[j]", "[k]", "[l]", "[m]", "[n]", "[o]"/)


 do i = 0, 11
  
    acc_us_num(i) = pan_num(i)+" "+sprintf("%3.2f", acc_us1d(i))

 end do 

 ;------------------define mpres-------------------------------
 pres              = True
 pres@gsLineThicknessF = 1.5
 pres@gsLineColor = "black"
 poly = new(12, "graphic")
 
 do i = 0, 11
   poly(i) = gsn_add_shapefile_polylines(wks,plot1d(i),neon_file,pres)
 end do
 
 ;---Panel Plotting---
 resP = True
 ;resP@gsnPanelLabelBar = True                ; add common colorbar
 resP@gsnMaximize = True
 resP@pmLabelBarWidthF  = 0.2
 resP@gsnPanelFigureStringsFontHeightF = 0.010
 ;resP@gsnPanelFigureStrings= (/"Lead 1-15 days", "Lead 16-30 days", "Lead 31-45 days"/) ; add strings to panel


 resP@gsnPanelFigureStrings = acc_us_num
 
 resP@tiMainString        = (/"CESM2(CAM6)"/)

 resP@gsnPanelFigureStringsPerimOn = False
 resP@amJust = "BottomLeft"
 ;resP@amParallelPosF=0.15
 ;resP@amOrthogonalPosF=-0.5
 resP@gsnPanelFigureStringsBackgroundFillColor = "white" 
 resP@lbLabelFontHeightF  = 0.02               ; make labels smaller
 ;resP@gsnPanelYWhiteSpacePercent = 5
 gsn_panel(wks,plot1d ,(/3,4/),resP)
end
  
  
  
  
